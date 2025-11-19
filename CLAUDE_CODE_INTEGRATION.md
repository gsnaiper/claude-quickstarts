# Claude Code Integration Guide

This guide explains how to use the Claude Quickstarts with **Claude Code** and the `CLAUDE_CODE_OAUTH_TOKEN` for seamless authentication in Dev Containers.

## What is Claude Code?

Claude Code is Anthropic's official CLI tool for Claude, designed to help developers interact with Claude directly from their development environment. It supports OAuth authentication for secure, seamless integration.

## Quick Setup

### Automated Setup (Recommended)

We provide an automated setup script that configures your Dev Container with the `CLAUDE_CODE_OAUTH_TOKEN`:

```bash
# 1. Set your Claude Code OAuth token
export CLAUDE_CODE_OAUTH_TOKEN="your-token-here"

# 2. Run the setup script
./scripts/setup-devcontainer-oauth.sh

# 3. Validate your setup
./scripts/validate-oauth-setup.sh
```

The setup script will:
- ✅ Verify your `CLAUDE_CODE_OAUTH_TOKEN` is set
- ✅ Optionally configure your `ANTHROPIC_API_KEY`
- ✅ Create `.env` or `.env.local` files with your credentials
- ✅ Add them to `.gitignore` for security
- ✅ Validate your Dev Container configuration

### Manual Setup

If you prefer manual configuration:

#### 1. Set Environment Variables

**macOS/Linux:**
```bash
# Add to ~/.bashrc, ~/.zshrc, or ~/.profile
export CLAUDE_CODE_OAUTH_TOKEN="your-token-here"
export ANTHROPIC_API_KEY="sk-ant-api03-..."

# Reload your shell
source ~/.bashrc  # or ~/.zshrc
```

**Windows (PowerShell):**
```powershell
# Add to your PowerShell profile
$env:CLAUDE_CODE_OAUTH_TOKEN = "your-token-here"
$env:ANTHROPIC_API_KEY = "sk-ant-api03-..."
```

#### 2. Create .env Files

**For Node.js projects** (customer-support-agent, financial-data-analyst):
```bash
# Create .env.local
cat > .env.local <<EOF
CLAUDE_CODE_OAUTH_TOKEN=your-token-here
ANTHROPIC_API_KEY=sk-ant-api03-...
EOF
```

**For Python projects** (computer-use-demo):
```bash
# Create .env
cat > .env <<EOF
CLAUDE_CODE_OAUTH_TOKEN=your-token-here
ANTHROPIC_API_KEY=sk-ant-api03-...
API_PROVIDER=anthropic
WIDTH=1024
HEIGHT=768
EOF
```

#### 3. Verify .gitignore

Ensure your `.env` files are ignored:
```bash
# Check .gitignore contains:
.env
.env.local
.env*.local
```

## Using with Dev Containers

All Claude Quickstart projects now include `CLAUDE_CODE_OAUTH_TOKEN` support in their Dev Container configurations.

### Local Development with VS Code

1. Ensure Docker Desktop is running
2. Set your environment variables (see above)
3. Open the project in VS Code:
   ```bash
   cd customer-support-agent  # or any project
   code .
   ```
4. Click "Reopen in Container" when prompted
5. Your tokens are automatically available inside the container!

### Verify Inside Container

Once inside the Dev Container:
```bash
# Run the validation script
./scripts/validate-oauth-setup.sh

# Or manually check
echo $CLAUDE_CODE_OAUTH_TOKEN
echo $ANTHROPIC_API_KEY
```

## Using with GitHub Codespaces

GitHub Codespaces provides a secure way to store secrets in the cloud.

### Setting Up Codespaces Secrets

1. Go to your GitHub profile → **Settings**
2. Navigate to **Codespaces** → **Secrets**
3. Click **New secret**
4. Add the following secrets:
   - Name: `CLAUDE_CODE_OAUTH_TOKEN`, Value: your token
   - Name: `ANTHROPIC_API_KEY`, Value: your API key

### Creating a Codespace

1. Go to the repository on GitHub
2. Click **Code** → **Codespaces** → **Create codespace**
3. Your secrets are automatically loaded!
4. Verify with: `./scripts/validate-oauth-setup.sh`

## Dev Container Configuration

All three quickstart projects include the `CLAUDE_CODE_OAUTH_TOKEN` in their `devcontainer.json`:

```json
{
  "remoteEnv": {
    "CLAUDE_CODE_OAUTH_TOKEN": "${localEnv:CLAUDE_CODE_OAUTH_TOKEN}",
    "ANTHROPIC_API_KEY": "${localEnv:ANTHROPIC_API_KEY}"
  }
}
```

This configuration:
- References your local environment variables via `${localEnv:...}`
- Automatically loads GitHub Codespaces secrets
- Never commits sensitive data to version control

## Available Scripts

### setup-devcontainer-oauth.sh

Automated setup script that configures your Dev Container environment.

**Usage:**
```bash
# Set your token first
export CLAUDE_CODE_OAUTH_TOKEN="your-token-here"

# Run setup
./scripts/setup-devcontainer-oauth.sh

# Follow the interactive prompts
```

**Features:**
- Interactive project selection
- Creates `.env` files automatically
- Adds files to `.gitignore`
- Validates Dev Container configuration
- Supports all three quickstart projects

### validate-oauth-setup.sh

Validation script that checks your OAuth token configuration.

**Usage:**
```bash
./scripts/validate-oauth-setup.sh
```

**Checks:**
- ✅ Environment variables are set
- ✅ `.env` files exist and contain tokens
- ✅ `.env` files are in `.gitignore`
- ✅ Dev Container configuration is correct
- ✅ API connectivity (if inside container)

**Example output:**
```
🔍 Validating OAuth Token Setup
================================

Environment Variables Check:
----------------------------
✓ CLAUDE_CODE_OAUTH_TOKEN: cco_...abc123
✓ ANTHROPIC_API_KEY: sk-ant...xyz789

.env Files Check:
-----------------
✓ Found: .env.local
  - Contains CLAUDE_CODE_OAUTH_TOKEN
  - Contains ANTHROPIC_API_KEY

Security Check:
---------------
✓ .env files are in .gitignore

Dev Container Configuration:
----------------------------
✓ Found .devcontainer/devcontainer.json
✓ CLAUDE_CODE_OAUTH_TOKEN referenced in devcontainer
✓ ANTHROPIC_API_KEY referenced in devcontainer

Summary:
--------
✓ All checks passed! Your OAuth setup is complete.
```

## Security Best Practices

### ✅ DO:
- Use the automated setup scripts
- Store tokens in environment variables or `.env` files
- Add `.env*` files to `.gitignore`
- Use GitHub Codespaces Secrets for cloud development
- Rotate credentials regularly
- Use separate tokens for different environments (dev, staging, prod)

### ❌ DON'T:
- Hardcode tokens in source code
- Commit `.env` files to git
- Share tokens in chat, email, or documentation
- Use production tokens in development
- Share your `.env` files publicly
- Commit your `~/.anthropic` directory

## Troubleshooting

### Token Not Found

**Problem:** `CLAUDE_CODE_OAUTH_TOKEN` is empty or not set

**Solutions:**
1. Check your environment: `echo $CLAUDE_CODE_OAUTH_TOKEN`
2. Verify shell profile is loaded: `source ~/.bashrc`
3. For Codespaces: Check GitHub Settings → Codespaces → Secrets
4. Rebuild container: Command Palette → "Dev Containers: Rebuild Container"

### .env File Not Loaded

**Problem:** Environment variables set in `.env` but not available

**Solutions:**
1. For Node.js projects: Use `.env.local` (Next.js loads this automatically)
2. For Python projects: Use `.env` and load it manually if needed
3. Rebuild the container to pick up new files
4. Verify the file is in the correct directory (project root)

### API Authentication Failed

**Problem:** API returns 401 Unauthorized

**Solutions:**
1. Verify your `ANTHROPIC_API_KEY` is correct
2. Check the key hasn't expired
3. Ensure you're using the right key format (starts with `sk-ant-api03-`)
4. Test connectivity: `curl -H "x-api-key: $ANTHROPIC_API_KEY" https://api.anthropic.com/v1/messages`

### Container Can't Access Environment Variables

**Problem:** Variables set on host but not in container

**Solutions:**
1. Verify `remoteEnv` in `devcontainer.json` references the correct variables
2. Use `${localEnv:VARIABLE_NAME}` syntax in `devcontainer.json`
3. For Codespaces, ensure secrets are added to GitHub settings
4. Rebuild container after changing environment variables

### Scripts Not Executable

**Problem:** `Permission denied` when running scripts

**Solution:**
```bash
chmod +x scripts/setup-devcontainer-oauth.sh
chmod +x scripts/validate-oauth-setup.sh
```

## Advanced Use Cases

### Using Multiple Tokens

If you need different tokens for different projects:

```bash
# Project-specific .env files
cd customer-support-agent
cat > .env.local <<EOF
CLAUDE_CODE_OAUTH_TOKEN=token-for-support-agent
ANTHROPIC_API_KEY=key-for-support-agent
EOF

cd ../financial-data-analyst
cat > .env.local <<EOF
CLAUDE_CODE_OAUTH_TOKEN=token-for-analyst
ANTHROPIC_API_KEY=key-for-analyst
EOF
```

### CI/CD Integration

For GitHub Actions or other CI/CD:

```yaml
name: CI
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: devcontainers/ci@v0.3
        with:
          runCmd: npm test
        env:
          CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

### Custom Token Rotation

Set up token rotation for enhanced security:

```bash
#!/bin/bash
# rotate-tokens.sh

# Generate new tokens (replace with your actual rotation logic)
NEW_OAUTH_TOKEN=$(your-token-generation-command)
NEW_API_KEY=$(your-api-key-generation-command)

# Update all projects
for dir in customer-support-agent financial-data-analyst computer-use-demo; do
  if [ -f "$dir/.env" ] || [ -f "$dir/.env.local" ]; then
    # Update .env files
    sed -i "s/CLAUDE_CODE_OAUTH_TOKEN=.*/CLAUDE_CODE_OAUTH_TOKEN=$NEW_OAUTH_TOKEN/" "$dir/.env"* 2>/dev/null
    sed -i "s/ANTHROPIC_API_KEY=.*/ANTHROPIC_API_KEY=$NEW_API_KEY/" "$dir/.env"* 2>/dev/null
    echo "✓ Updated $dir"
  fi
done
```

## Getting Your Tokens

### CLAUDE_CODE_OAUTH_TOKEN

The `CLAUDE_CODE_OAUTH_TOKEN` is obtained through Claude Code's OAuth flow.

### ANTHROPIC_API_KEY

1. Go to [console.anthropic.com](https://console.anthropic.com)
2. Sign up or log in
3. Navigate to **API Keys**
4. Click **Create Key**
5. Copy the key (starts with `sk-ant-api03-...`)
6. Store it securely using one of the methods above

## Project-Specific Configuration

Each quickstart project has its own requirements:

### Customer Support Agent
```bash
# Required
CLAUDE_CODE_OAUTH_TOKEN=...
ANTHROPIC_API_KEY=...

# Optional (for AWS Bedrock)
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_SESSION_TOKEN=...
```

### Financial Data Analyst
```bash
# Required
CLAUDE_CODE_OAUTH_TOKEN=...
ANTHROPIC_API_KEY=...

# Optional
NEXT_PUBLIC_API_URL=...
```

### Computer Use Demo
```bash
# Required
CLAUDE_CODE_OAUTH_TOKEN=...
ANTHROPIC_API_KEY=...

# Optional
API_PROVIDER=anthropic  # or "bedrock", "vertex"
WIDTH=1024
HEIGHT=768
```

## Additional Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [DEVCONTAINER_GUIDE.md](./DEVCONTAINER_GUIDE.md) - Comprehensive Dev Container guide
- [Dev Containers Documentation](https://containers.dev)
- [GitHub Codespaces Secrets](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-secrets-for-your-codespaces)
- [Anthropic API Documentation](https://docs.anthropic.com)

## Support

If you encounter issues:
1. Run `./scripts/validate-oauth-setup.sh` for diagnostics
2. Check the troubleshooting section above
3. Review project-specific READMEs in `.devcontainer/README.md`
4. Open an issue in the [claude-quickstarts repository](https://github.com/anthropics/claude-quickstarts/issues)
5. Join the [Anthropic Discord community](https://www.anthropic.com/discord)
