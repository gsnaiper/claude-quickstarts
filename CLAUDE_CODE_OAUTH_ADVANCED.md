# Advanced Claude Code OAuth Token Guide

This document provides deep technical knowledge about CLAUDE_CODE_OAUTH_TOKEN authentication for advanced users, CI/CD pipelines, and headless environments.

## Table of Contents

- [OAuth Token vs API Key Authentication](#oauth-token-vs-api-key-authentication)
- [Token Generation and Structure](#token-generation-and-structure)
- [Headless Usage](#headless-usage)
- [Token Lifecycle Management](#token-lifecycle-management)
- [Advanced Configuration](#advanced-configuration)
- [CI/CD Integration](#cicd-integration)
- [Troubleshooting](#troubleshooting)

## OAuth Token vs API Key Authentication

Claude Code supports multiple authentication methods, which differ based on your account type:

### Authentication Methods

**1. Claude Console (API Account)**
- Uses Anthropic Console (console.anthropic.com)
- Requires organization with billing
- Creates dedicated "Claude Code" workspace
- Uses OAuth to obtain API key behind the scenes
- No exposed API keys to user - all access through OAuth

**2. Claude App (Pro/Max Subscription)**
- Uses claude.ai account (Pro or Max plan)
- Unified billing with web app
- OAuth login with claude.ai credentials
- Receives Bearer access token
- Token stored securely (Keychain/encrypted file)
- **No direct API key** - uses OAuth token for authorization

**3. Enterprise Platforms**
- Amazon Bedrock
- Google Vertex AI
- Azure Foundry
- Custom enterprise configurations

### Key Difference

**Pro/Max users don't have an API key**. Instead, the CLI relies on an OAuth access token obtained via interactive login. Internally, Claude Code treats this similar to an API key - it injects it as an `Authorization: Bearer ...` header on requests. But the token is managed by Anthropic's OAuth system.

## Token Generation and Structure

### Generating OAuth Token

For automated or headless environments (CI, Docker, remote IDEs), use the `claude setup-token` command:

```bash
# On a machine with browser access
claude setup-token
```

This will:
1. Open browser to Anthropic's auth page (console.anthropic.com or claude.ai OAuth)
2. After authorization, print an OAuth token string

Example output:
```
Your token:
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyX2lkIiwiZXhwIjoxNzU0NDE4NzM1fQ...
```

**Important**: This token represents your Claude Code session credential. It's a bearer token that grants access to your Claude account usage. Keep it secure!

### Token Structure

When you log in interactively, Claude stores tokens in `~/.claude/.credentials.json`:

```json
{
  "claudeAiOauth": {
    "accessToken": "sk-ant-oat01-...",
    "refreshToken": "sk-ant-ort01-...",
    "expiresAt": 1754418735285,
    "scopes": ["user:inference", "user:profile"],
    "subscriptionType": "pro"
  }
}
```

**Components**:
- **accessToken**: Short-lived bearer token for API requests
- **refreshToken**: Long-lived token to obtain new access tokens
- **expiresAt**: Unix timestamp when access token expires
- **scopes**: Permissions granted to token
- **subscriptionType**: Account type (pro, max, api)

## Headless Usage

### Environment Variables

Claude Code recognizes these environment variables for headless authentication:

```bash
# Primary OAuth token variable
export CLAUDE_CODE_OAUTH_TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."

# Skip interactive onboarding prompts
export CLAUDE_CODE_BYPASS_ONBOARDING="1"

# Alternative token variable (CLI prepends "Bearer " automatically)
export ANTHROPIC_AUTH_TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
```

**Recommended**: Use `CLAUDE_CODE_OAUTH_TOKEN` for clarity and consistency.

### Basic Headless Usage

```bash
# Set token
export CLAUDE_CODE_OAUTH_TOKEN="your-token-here"
export CLAUDE_CODE_BYPASS_ONBOARDING="1"

# Run Claude Code non-interactively
claude -p --dangerously-skip-permissions "Create hello.py that prints 42"
```

### Docker/Container Usage

**docker-compose.yml**:
```yaml
services:
  claude-dev:
    build: .
    environment:
      - CLAUDE_CODE_OAUTH_TOKEN=${CLAUDE_CODE_OAUTH_TOKEN}
      - CLAUDE_CODE_BYPASS_ONBOARDING=1
    env_file:
      - .env  # Never commit this file!
```

**.env file** (gitignored):
```bash
CLAUDE_CODE_OAUTH_TOKEN=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
ANTHROPIC_API_KEY=sk-ant-api03-...
```

**devcontainer.json**:
```json
{
  "remoteEnv": {
    "CLAUDE_CODE_OAUTH_TOKEN": "${localEnv:CLAUDE_CODE_OAUTH_TOKEN}",
    "CLAUDE_CODE_BYPASS_ONBOARDING": "1"
  }
}
```

### Python SDK Example (E2B Sandbox)

```python
from e2b import Sandbox
import os

# Launch sandbox with Claude Code
sbx = Sandbox(
    "anthropic-claude-code",
    envs={
        "CLAUDE_CODE_OAUTH_TOKEN": os.environ["CLAUDE_CODE_OAUTH_TOKEN"],
        "CLAUDE_CODE_BYPASS_ONBOARDING": "1",
    },
    timeout=5*60  # 5 minutes
)

# Run command in sandbox
result = sbx.commands.run(
    "claude -p --dangerously-skip-permissions 'Create hello.py that prints 42'",
    timeout=0
)
print(result.stdout)
sbx.kill()
```

## Token Lifecycle Management

### Token Expiration

OAuth tokens are **not permanent** - they expire after some time (typically days to weeks).

**Signs of expired token**:
- HTTP 401 Unauthorized errors
- "Authentication failed" messages
- Prompts for re-login

### Token Rotation Strategy

**Option 1: Manual Rotation**
```bash
# Every N days (e.g., weekly)
1. Run: claude setup-token
2. Copy new token
3. Update environment variables/secrets
4. Restart services using the token
```

**Option 2: Automated Rotation Script**
```bash
#!/bin/bash
# rotate-claude-token.sh

# Generate new token (requires interactive browser)
NEW_TOKEN=$(claude setup-token 2>&1 | grep -oP 'eyJ[A-Za-z0-9_-]*\.[A-Za-z0-9_-]*\.[A-Za-z0-9_-]*')

# Update in secrets manager (example: AWS Secrets Manager)
aws secretsmanager update-secret \
  --secret-id claude-code-oauth-token \
  --secret-string "$NEW_TOKEN"

# Update in .env files
for dir in customer-support-agent financial-data-analyst computer-use-demo; do
  if [ -f "$dir/.env.local" ] || [ -f "$dir/.env" ]; then
    sed -i "s/CLAUDE_CODE_OAUTH_TOKEN=.*/CLAUDE_CODE_OAUTH_TOKEN=$NEW_TOKEN/" "$dir/.env"*
  fi
done

echo "Token rotated successfully"
```

**Option 3: Using Refresh Token**

If you have access to `~/.claude/.credentials.json`, you can extract the refresh token:

```bash
# Extract refresh token
REFRESH_TOKEN=$(jq -r '.claudeAiOauth.refreshToken' ~/.claude/.credentials.json)

# Use refresh token to get new access token (requires calling Anthropic's token endpoint)
# Note: This is advanced and requires knowledge of OAuth2 refresh flow
```

### Monitoring Token Expiration

**Decode JWT to check expiration**:
```bash
#!/bin/bash
# check-token-expiration.sh

TOKEN="$CLAUDE_CODE_OAUTH_TOKEN"

# Decode JWT (requires jq)
PAYLOAD=$(echo $TOKEN | cut -d. -f2)
# Add padding if needed
PADDING=$((4 - ${#PAYLOAD} % 4))
[ $PADDING -ne 4 ] && PAYLOAD="${PAYLOAD}$(printf '=%.0s' $(seq 1 $PADDING))"

# Decode base64
DECODED=$(echo $PAYLOAD | base64 -d 2>/dev/null)
EXPIRY=$(echo $DECODED | jq -r '.exp')

# Check if expired
CURRENT_TIME=$(date +%s)
if [ $CURRENT_TIME -gt $EXPIRY ]; then
  echo "Token expired on $(date -d @$EXPIRY)"
  exit 1
else
  echo "Token valid until $(date -d @$EXPIRY)"
  exit 0
fi
```

### Fallback Strategies

**1. Credential File Copying**
```bash
# Copy credentials from authenticated machine to target
scp ~/.claude/.credentials.json user@target-machine:~/.claude/

# On target machine, Claude Code will use these credentials
```

**2. Interactive Re-login**
```bash
# If token expired in dev environment
claude /login

# Follow browser flow
# New token will be stored in ~/.claude/.credentials.json
```

**3. Emergency Token Regeneration**
```bash
# Generate new token immediately
claude setup-token

# Update all environments
# - GitHub Secrets
# - .env files
# - CI/CD variables
```

## Advanced Configuration

### Dynamic Token Fetching with apiKeyHelper

Claude Code supports an `apiKeyHelper` configuration that runs a shell command to fetch tokens dynamically:

**~/.claude/settings.json**:
```json
{
  "apiKeyHelper": "/path/to/get-token.sh"
}
```

**get-token.sh**:
```bash
#!/bin/bash
# Fetch token from secrets manager or check expiration

# Check if current token is valid
if check-token-expiration.sh; then
  # Return current token
  echo "$CLAUDE_CODE_OAUTH_TOKEN"
else
  # Fetch fresh token from secrets manager
  aws secretsmanager get-secret-value \
    --secret-id claude-code-oauth-token \
    --query SecretString \
    --output text
fi
```

**Environment Variable**:
```bash
# Control how often apiKeyHelper is called (milliseconds)
export CLAUDE_CODE_API_KEY_HELPER_TTL_MS=300000  # 5 minutes
```

This allows Claude Code to automatically refresh tokens every 5 minutes (or on 401 errors).

### Using Credentials File in Containers

**Mount credentials into container**:
```yaml
# docker-compose.yml
services:
  claude-dev:
    volumes:
      - ~/.claude:/root/.claude:ro  # Read-only mount
```

This gives the container access to both access and refresh tokens, enabling automatic token refresh.

### Multiple Account Management

**Separate credentials per project**:
```bash
# Project A
export CLAUDE_CODE_OAUTH_TOKEN="token-for-project-a"
cd project-a && code .

# Project B
export CLAUDE_CODE_OAUTH_TOKEN="token-for-project-b"
cd project-b && code .
```

**Or use separate credential files**:
```bash
# Set custom credentials location
export CLAUDE_HOME=/path/to/project-a/.claude
claude <commands>

# Different project
export CLAUDE_HOME=/path/to/project-b/.claude
claude <commands>
```

## CI/CD Integration

### GitHub Actions

**.github/workflows/claude-code.yml**:
```yaml
name: Claude Code Integration
on: [push]

jobs:
  code-assistant:
    runs-on: ubuntu-latest
    env:
      CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
      CLAUDE_CODE_BYPASS_ONBOARDING: '1'

    steps:
      - uses: actions/checkout@v3

      - name: Install Claude Code
        run: |
          curl -fsSL https://api.claude.com/install.sh | sh
          echo "$HOME/.claude/bin" >> $GITHUB_PATH

      - name: Validate Token
        run: |
          if [ -z "$CLAUDE_CODE_OAUTH_TOKEN" ]; then
            echo "Error: CLAUDE_CODE_OAUTH_TOKEN not set"
            exit 1
          fi
          # Check token expiration
          ./scripts/check-token-expiration.sh

      - name: Run Claude Code Analysis
        run: claude -p "Analyze this repository and suggest improvements"

      - name: Auto-commit Changes
        run: |
          git config user.name "Claude Code Bot"
          git config user.email "bot@example.com"
          git add -A
          git diff --quiet && git diff --staged --quiet || \
            git commit -m "chore: Claude Code improvements"
          git push
```

**Add Secret**:
1. Repository Settings → Secrets → Actions
2. Add `CLAUDE_CODE_OAUTH_TOKEN`
3. Never expose in logs or outputs

### GitLab CI

**.gitlab-ci.yml**:
```yaml
claude_code_job:
  image: ubuntu:latest
  variables:
    CLAUDE_CODE_OAUTH_TOKEN: $CLAUDE_CODE_OAUTH_TOKEN
    CLAUDE_CODE_BYPASS_ONBOARDING: "1"

  before_script:
    - apt-get update && apt-get install -y curl jq
    - curl -fsSL https://api.claude.com/install.sh | sh
    - export PATH="$HOME/.claude/bin:$PATH"

  script:
    - claude -p "Review code for security issues"

  only:
    - main
```

**Add Variable**:
1. Project Settings → CI/CD → Variables
2. Add `CLAUDE_CODE_OAUTH_TOKEN` (protected, masked)

### Jenkins Pipeline

```groovy
pipeline {
  agent any

  environment {
    CLAUDE_CODE_OAUTH_TOKEN = credentials('claude-code-oauth-token')
    CLAUDE_CODE_BYPASS_ONBOARDING = '1'
  }

  stages {
    stage('Setup') {
      steps {
        sh 'curl -fsSL https://api.claude.com/install.sh | sh'
      }
    }

    stage('Code Review') {
      steps {
        sh '''
          export PATH="$HOME/.claude/bin:$PATH"
          claude -p "Review recent changes and provide feedback"
        '''
      }
    }
  }
}
```

## Troubleshooting

### Known Issues

#### Issue 1: Token Not Recognized on First Run

**Problem**: Even with `CLAUDE_CODE_OAUTH_TOKEN` set, Claude Code still prompts for login on first run.

**Status**: Known bug tracked by Anthropic (GitHub Issue #8938)

**Workarounds**:
1. Set `CLAUDE_CODE_BYPASS_ONBOARDING=1`
2. Complete setup once interactively, then use token
3. Mount pre-configured `~/.claude` directory
4. Wait for Anthropic to fix this bug

```bash
# Workaround: One-time interactive setup
docker run -it --rm \
  -e CLAUDE_CODE_OAUTH_TOKEN="$TOKEN" \
  -e CLAUDE_CODE_BYPASS_ONBOARDING=1 \
  -v claude-config:/root/.claude \
  your-image \
  claude /status

# Subsequent runs will work without prompts
```

#### Issue 2: Token Expired Mid-Session

**Problem**: Token expires during long-running CI job

**Solution**:
```yaml
# GitHub Actions example
- name: Run Long Task
  timeout-minutes: 30
  run: |
    # Check token before starting
    ./scripts/check-token-expiration.sh || {
      echo "Token expired, please rotate"
      exit 1
    }

    # Run task
    claude -p "Long running task"
```

#### Issue 3: Token Works Locally but Not in CI

**Problem**: Token works on local machine but fails in CI

**Checklist**:
1. Verify token is correctly set in CI secrets
2. Check for extra whitespace in secret value
3. Ensure `CLAUDE_CODE_BYPASS_ONBOARDING=1` is set
4. Verify CI runner has internet access to api.anthropic.com
5. Check token hasn't expired since you set it

```bash
# Debug in CI
- name: Debug Token
  run: |
    echo "Token length: ${#CLAUDE_CODE_OAUTH_TOKEN}"
    echo "Token prefix: ${CLAUDE_CODE_OAUTH_TOKEN:0:10}..."
    echo "Bypass onboarding: $CLAUDE_CODE_BYPASS_ONBOARDING"
```

### Security Considerations

**DO**:
- ✅ Treat token like a password
- ✅ Use encrypted secrets in CI/CD
- ✅ Rotate tokens regularly (monthly recommended)
- ✅ Monitor for expiration
- ✅ Use read-only mounts for credential files
- ✅ Audit token usage in logs
- ✅ Revoke compromised tokens immediately

**DON'T**:
- ❌ Commit tokens to git
- ❌ Log token values
- ❌ Share tokens between unrelated projects
- ❌ Use production tokens in development
- ❌ Store tokens in plain text
- ❌ Expose tokens in error messages

### Token Revocation

If a token is compromised:

```bash
# 1. Generate new token
claude setup-token

# 2. Update all locations using old token
# - CI/CD secrets
# - .env files
# - Container configurations
# - Secrets managers

# 3. Old token will be invalid after expiration
# (Anthropic doesn't provide explicit revocation endpoint yet)

# 4. For immediate revocation, change password on:
# - console.anthropic.com (for API accounts)
# - claude.ai (for Pro/Max accounts)
```

## Resources

- [Claude Code Official Docs - Setup](https://code.claude.com/docs/en/setup)
- [Claude Code Official Docs - IAM](https://code.claude.com/docs/en/iam)
- [Claude Code Official Docs - Settings](https://code.claude.com/docs/en/settings)
- [Depot.dev - Claude Code Quickstart](https://depot.dev/docs/agents/claude-code/quickstart)
- [GitHub Issue #8938 - Token Authentication Bug](https://github.com/anthropics/claude-code/issues/8938)

## Summary

- **CLAUDE_CODE_OAUTH_TOKEN** enables headless Claude Code usage
- Token obtained via `claude setup-token` command
- Tokens expire - implement rotation strategy
- Use `CLAUDE_CODE_BYPASS_ONBOARDING=1` for non-interactive environments
- Advanced users can leverage `apiKeyHelper` for dynamic token management
- Treat tokens as sensitive credentials - never commit, always encrypt
- Monitor expiration and have fallback plans
