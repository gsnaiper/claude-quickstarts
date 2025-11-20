# DevContainer Manager Skill

A comprehensive skill for managing Dev Containers in Claude Quickstarts with full CLAUDE_CODE_OAUTH_TOKEN support, daily workflows, maintenance, and troubleshooting.

## Skill Overview

This skill provides expert assistance with:
- Dev Container setup and configuration
- OAuth token management (CLAUDE_CODE_OAUTH_TOKEN, ANTHROPIC_API_KEY)
- Daily development workflows
- Troubleshooting and maintenance
- Security best practices
- Multi-project management

## Core Knowledge Base

### Project Structure

```
claude-quickstarts/
├── customer-support-agent/      # Node.js/Next.js/TypeScript
│   └── .devcontainer/
│       ├── devcontainer.json
│       └── README.md
├── financial-data-analyst/      # Node.js/Next.js/Recharts
│   └── .devcontainer/
│       ├── devcontainer.json
│       └── README.md
├── computer-use-demo/           # Python/Docker-in-Docker
│   └── .devcontainer/
│       ├── devcontainer.json
│       └── README.md
├── scripts/
│   ├── setup-devcontainer-oauth.sh
│   └── validate-oauth-setup.sh
├── DEVCONTAINER_GUIDE.md
└── CLAUDE_CODE_INTEGRATION.md
```

### Dev Container Configurations

#### Customer Support Agent
- **Technology**: Node.js 20, TypeScript, Next.js, Tailwind CSS
- **Ports**: 3000 (Next.js dev server)
- **Environment Variables**:
  - `CLAUDE_CODE_OAUTH_TOKEN` (required for Claude Code)
  - `ANTHROPIC_API_KEY` (required)
  - `AWS_ACCESS_KEY_ID` (optional)
  - `AWS_SECRET_ACCESS_KEY` (optional)
  - `AWS_SESSION_TOKEN` (optional)
- **VS Code Extensions**: ESLint, Prettier, Tailwind CSS, TypeScript
- **Env File**: `.env.local`

#### Financial Data Analyst
- **Technology**: Node.js 20, TypeScript, Next.js, Recharts
- **Ports**: 3000 (Next.js dev server)
- **Environment Variables**:
  - `CLAUDE_CODE_OAUTH_TOKEN` (required for Claude Code)
  - `ANTHROPIC_API_KEY` (required)
  - `NEXT_PUBLIC_API_URL` (optional)
- **VS Code Extensions**: ESLint, Prettier, Tailwind CSS, TypeScript
- **Env File**: `.env.local`

#### Computer Use Demo
- **Technology**: Python 3.11, Docker-in-Docker, Streamlit
- **Ports**: 8501 (Streamlit), 5900 (VNC), 6080 (noVNC), 8080 (HTTP)
- **Environment Variables**:
  - `CLAUDE_CODE_OAUTH_TOKEN` (required for Claude Code)
  - `ANTHROPIC_API_KEY` (required)
  - `API_PROVIDER` (default: "anthropic")
  - `WIDTH` (default: 1024)
  - `HEIGHT` (default: 768)
- **VS Code Extensions**: Python, Pylance, Ruff, Black
- **Env File**: `.env`
- **Special**: Requires privileged mode for Docker-in-Docker

## Available Commands

### Automation Scripts

**Setup Script**: `./scripts/setup-devcontainer-oauth.sh`
- Interactive project selection
- Creates `.env`/`.env.local` files
- Validates environment variables
- Adds files to `.gitignore`
- Supports all three projects

**Validation Script**: `./scripts/validate-oauth-setup.sh`
- Checks environment variables
- Validates `.env` files
- Verifies `.gitignore` configuration
- Tests API connectivity
- Provides detailed diagnostics

### Project-Specific Commands

**Customer Support Agent & Financial Data Analyst**:
```bash
npm run dev        # Full UI development server
npm run dev:left   # Left sidebar only
npm run dev:right  # Right sidebar only
npm run dev:chat   # Chat interface only
npm run lint       # Run ESLint
npm run build      # Production build
```

**Computer Use Demo**:
```bash
# Development & Testing
ruff check .                        # Lint Python code
ruff format .                       # Format Python code
pyright                            # Type checking
pytest                             # Run all tests
pytest tests/test_file.py::test_name -v  # Run specific test

# Docker Operations
docker build . -t computer-use-demo:local  # Build demo image
docker ps                                   # List containers
docker logs <container-id>                  # View logs
docker exec -it <container-id> bash        # Container shell

# Setup
./setup.sh                                  # Environment setup
```

## OAuth Token Management

### Token Types and Sources

1. **CLAUDE_CODE_OAUTH_TOKEN**
   - Purpose: Claude Code CLI authentication
   - Format: Varies (Claude Code specific)
   - Required for: Claude Code integration
   - Obtained from: Claude Code OAuth flow

2. **ANTHROPIC_API_KEY**
   - Purpose: Direct Anthropic API access
   - Format: `sk-ant-api03-...`
   - Required for: All projects
   - Obtained from: https://console.anthropic.com

### Token Configuration Methods

#### Method 1: GitHub Codespaces Secrets (Cloud Development)

**Setup**:
1. GitHub Settings → Codespaces → Secrets
2. Add secrets:
   - `CLAUDE_CODE_OAUTH_TOKEN`
   - `ANTHROPIC_API_KEY`
3. Create Codespace
4. Tokens automatically loaded

**Use Case**: Cloud development, team collaboration

#### Method 2: Local Environment Variables (Local Development)

**Setup**:
```bash
# Add to ~/.bashrc, ~/.zshrc, or ~/.profile
export CLAUDE_CODE_OAUTH_TOKEN="your-token-here"
export ANTHROPIC_API_KEY="sk-ant-api03-..."

# Reload shell
source ~/.bashrc
```

**Use Case**: Local development, personal machine

#### Method 3: .env Files (Project-Specific)

**Setup**:
```bash
# Node.js projects - create .env.local
cat > customer-support-agent/.env.local <<EOF
CLAUDE_CODE_OAUTH_TOKEN=your-token-here
ANTHROPIC_API_KEY=sk-ant-api03-...
EOF

# Python project - create .env
cat > computer-use-demo/.env <<EOF
CLAUDE_CODE_OAUTH_TOKEN=your-token-here
ANTHROPIC_API_KEY=sk-ant-api03-...
API_PROVIDER=anthropic
WIDTH=1024
HEIGHT=768
EOF
```

**Use Case**: Project-specific configurations, testing

#### Method 4: Automated Setup Script

**Setup**:
```bash
export CLAUDE_CODE_OAUTH_TOKEN="your-token-here"
./scripts/setup-devcontainer-oauth.sh
```

**Use Case**: Quick setup, new developers

## Daily Workflows

### Morning Setup

```bash
# 1. Start Docker Desktop (if local)
# 2. Pull latest changes
git pull origin main

# 3. Verify environment
./scripts/validate-oauth-setup.sh

# 4. Open project in Dev Container
cd customer-support-agent  # or any project
code .
# Click "Reopen in Container"

# 5. Start development server
npm run dev  # or appropriate command
```

### Development Cycle

**Node.js Projects**:
```bash
# 1. Start dev server
npm run dev

# 2. Make changes to code
# 3. Check linting
npm run lint

# 4. Fix linting issues
npm run lint -- --fix

# 5. Test locally
# Visit http://localhost:3000

# 6. Build for production
npm run build
```

**Python Project**:
```bash
# 1. Make changes to code

# 2. Format code
ruff format .

# 3. Lint code
ruff check .

# 4. Type check
pyright

# 5. Run tests
pytest

# 6. Build and test Docker image
docker build . -t computer-use-demo:local
docker run -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
  -p 5900:5900 -p 8501:8501 -p 6080:6080 -p 8080:8080 \
  -it computer-use-demo:local
```

### Git Workflow

```bash
# 1. Create feature branch
git checkout -b feature/my-feature

# 2. Make changes
# ... edit files ...

# 3. Stage and commit
git add .
git commit -m "feat: add new feature"

# 4. Push to remote
git push -u origin feature/my-feature

# 5. Create pull request
gh pr create --title "Add new feature" --body "Description"
```

## Maintenance & Support

### Regular Maintenance Tasks

#### Daily
- Verify tokens are valid: `./scripts/validate-oauth-setup.sh`
- Pull latest changes: `git pull`
- Update dependencies: `npm install` or `pip install -r requirements.txt`
- Check Docker disk usage: `docker system df`

#### Weekly
- Update Docker images: Rebuild dev containers
- Review and clear Docker cache: `docker system prune`
- Update VS Code extensions
- Check for security updates

#### Monthly
- Rotate OAuth tokens and API keys
- Review and update .gitignore
- Audit environment variable usage
- Clean up unused containers: `docker container prune`

### Token Rotation

```bash
# 1. Generate new tokens
# - Get new CLAUDE_CODE_OAUTH_TOKEN from Claude Code
# - Get new ANTHROPIC_API_KEY from console.anthropic.com

# 2. Update environment variables
export CLAUDE_CODE_OAUTH_TOKEN="new-token"
export ANTHROPIC_API_KEY="new-key"

# 3. Update .env files
./scripts/setup-devcontainer-oauth.sh

# 4. Update GitHub Codespaces Secrets
# Go to GitHub Settings → Codespaces → Secrets → Update

# 5. Rebuild containers
# Command Palette → "Dev Containers: Rebuild Container"

# 6. Validate new setup
./scripts/validate-oauth-setup.sh
```

### Troubleshooting Guide

#### Problem: CLAUDE_CODE_OAUTH_TOKEN Not Found

**Symptoms**:
- `echo $CLAUDE_CODE_OAUTH_TOKEN` returns empty
- Validation script reports token not set

**Solutions**:
1. Check local environment: `env | grep CLAUDE_CODE_OAUTH_TOKEN`
2. Verify shell profile is loaded: `source ~/.bashrc`
3. For Codespaces: Check GitHub Settings → Codespaces → Secrets
4. Rebuild container: Command Palette → "Dev Containers: Rebuild Container"
5. Run setup script: `./scripts/setup-devcontainer-oauth.sh`

#### Problem: API Authentication Failed (401)

**Symptoms**:
- API returns 401 Unauthorized
- Applications can't connect to Claude API

**Solutions**:
1. Verify API key format: Should start with `sk-ant-api03-`
2. Check key hasn't expired
3. Test directly: `curl -H "x-api-key: $ANTHROPIC_API_KEY" https://api.anthropic.com/v1/messages`
4. Regenerate key at console.anthropic.com
5. Update all .env files with new key

#### Problem: Container Won't Build

**Symptoms**:
- Dev Container build fails
- Docker errors during build

**Solutions**:
1. Check Docker Desktop is running
2. Clear Docker cache: `docker system prune -a`
3. Check internet connection
4. Review build logs in VS Code OUTPUT panel
5. Try rebuilding: Command Palette → "Dev Containers: Rebuild Container"
6. Check disk space: `docker system df`

#### Problem: Port Already in Use

**Symptoms**:
- "Port 3000 is already in use"
- Can't start dev server

**Solutions**:
1. Find process using port: `lsof -ti:3000`
2. Kill process: `lsof -ti:3000 | xargs kill`
3. Stop other containers: `docker ps`, `docker stop <container-id>`
4. Change port in package.json or .env
5. Restart Docker Desktop

#### Problem: .env File Not Loaded

**Symptoms**:
- Environment variables in .env but not available
- App can't find configuration

**Solutions**:
1. For Node.js: Use `.env.local` (Next.js auto-loads)
2. For Python: Ensure .env is in correct directory
3. Rebuild container to pick up new files
4. Verify file is not in .gitignore (should be!)
5. Check file has correct syntax (no spaces around =)

#### Problem: GitHub CLI OAuth Failed

**Symptoms**:
- `gh auth login` fails
- Can't authenticate with GitHub

**Solutions**:
1. Check internet connection
2. Try alternative: `gh auth login --web`
3. Use personal access token: `gh auth login --with-token`
4. Clear existing auth: `gh auth logout`, then retry

#### Problem: Docker-in-Docker Not Working (Computer Use Demo)

**Symptoms**:
- Can't build Docker images inside container
- Docker commands fail

**Solutions**:
1. Verify privileged mode in devcontainer.json: `"privileged": true`
2. Check Docker socket mount: `ls -la /var/run/docker.sock`
3. Restart Docker Desktop
4. Rebuild container as root user
5. Check Docker daemon is running: `docker info`

## Security Best Practices

### Token Management

**DO**:
- ✅ Use GitHub Codespaces Secrets for cloud development
- ✅ Use local environment variables for local development
- ✅ Use .env files for project-specific configurations
- ✅ Add `.env*` to .gitignore
- ✅ Rotate credentials regularly (monthly)
- ✅ Use separate tokens for dev/staging/prod
- ✅ Run validation script regularly
- ✅ Use the automated setup script

**DON'T**:
- ❌ Hardcode tokens in source code
- ❌ Commit .env files to git
- ❌ Share tokens in chat, email, or docs
- ❌ Use production tokens in development
- ❌ Share .env files publicly
- ❌ Commit ~/.anthropic directory
- ❌ Store tokens in container images

### File Security

**Always in .gitignore**:
```
.env
.env.local
.env*.local
.anthropic/
*.key
*.pem
secrets/
```

**Regular Audits**:
```bash
# Check for accidentally committed secrets
git log --all --full-history -- .env*
git log --all --full-history -- *secret*
git log --all --full-history -- *key*

# Scan for hardcoded tokens
rg -i "sk-ant-api03" --type-not gitignore
rg -i "CLAUDE_CODE_OAUTH_TOKEN\s*=\s*['\"]" --type-not gitignore
```

## Advanced Use Cases

### Multi-Project Setup

```bash
# Setup all projects at once
export CLAUDE_CODE_OAUTH_TOKEN="your-token"
export ANTHROPIC_API_KEY="your-key"

# Run setup for all
./scripts/setup-devcontainer-oauth.sh
# Select option 4 (All projects)

# Verify all
for dir in customer-support-agent financial-data-analyst computer-use-demo; do
  cd $dir
  ../scripts/validate-oauth-setup.sh
  cd ..
done
```

### Custom Token per Project

```bash
# Different tokens for different projects
cd customer-support-agent
cat > .env.local <<EOF
CLAUDE_CODE_OAUTH_TOKEN=token-for-support
ANTHROPIC_API_KEY=key-for-support
EOF

cd ../financial-data-analyst
cat > .env.local <<EOF
CLAUDE_CODE_OAUTH_TOKEN=token-for-analyst
ANTHROPIC_API_KEY=key-for-analyst
EOF
```

### CI/CD Integration

**GitHub Actions Example**:
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
          runCmd: |
            npm install
            npm run lint
            npm run build
        env:
          CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

### Custom Dev Container Features

Add custom features to devcontainer.json:
```json
{
  "features": {
    "ghcr.io/devcontainers/features/aws-cli:1": {
      "version": "latest"
    },
    "ghcr.io/devcontainers/features/terraform:1": {
      "version": "latest"
    }
  }
}
```

## Quick Reference Commands

### Setup & Validation
```bash
# Initial setup
export CLAUDE_CODE_OAUTH_TOKEN="token"
./scripts/setup-devcontainer-oauth.sh

# Validate setup
./scripts/validate-oauth-setup.sh

# Check environment
env | grep -E "(CLAUDE_CODE_OAUTH_TOKEN|ANTHROPIC_API_KEY)"
```

### Container Management
```bash
# Rebuild container
# Command Palette → "Dev Containers: Rebuild Container"

# Reopen in container
# Command Palette → "Dev Containers: Reopen in Container"

# Show container logs
# Command Palette → "Dev Containers: Show Container Log"
```

### Docker Commands
```bash
# List containers
docker ps -a

# View logs
docker logs <container-id>

# Clean up
docker system prune -a

# Check disk usage
docker system df
```

### Debugging
```bash
# Check token is set
echo $CLAUDE_CODE_OAUTH_TOKEN
echo $ANTHROPIC_API_KEY

# Validate .env file
cat .env.local  # or .env

# Check gitignore
cat .gitignore | grep env

# Test API connectivity
curl -H "x-api-key: $ANTHROPIC_API_KEY" \
  https://api.anthropic.com/v1/messages
```

## Common Tasks

### Task: Setup New Developer

```bash
# 1. Clone repository
git clone https://github.com/anthropics/claude-quickstarts.git
cd claude-quickstarts

# 2. Get tokens
# - CLAUDE_CODE_OAUTH_TOKEN from Claude Code
# - ANTHROPIC_API_KEY from console.anthropic.com

# 3. Run automated setup
export CLAUDE_CODE_OAUTH_TOKEN="token"
export ANTHROPIC_API_KEY="key"
./scripts/setup-devcontainer-oauth.sh

# 4. Validate
./scripts/validate-oauth-setup.sh

# 5. Open project
cd customer-support-agent
code .
# Click "Reopen in Container"
```

### Task: Update Dependencies

**Node.js Projects**:
```bash
# Inside Dev Container
npm install
npm audit fix
npm update
```

**Python Project**:
```bash
# Inside Dev Container
pip install --upgrade pip
pip install -r computer_use_demo/requirements.txt --upgrade
```

### Task: Debug API Issues

```bash
# 1. Validate environment
./scripts/validate-oauth-setup.sh

# 2. Check token format
echo $ANTHROPIC_API_KEY | head -c 20

# 3. Test API directly
curl -v -X POST https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{
    "model": "claude-sonnet-4-5-20250929",
    "max_tokens": 10,
    "messages": [{"role": "user", "content": "test"}]
  }'

# 4. Check application logs
# For Node.js: Check terminal running npm run dev
# For Python: Check Streamlit logs
```

### Task: Migrate to New Machine

```bash
# Old Machine - Export (optional if using GitHub Secrets)
echo "CLAUDE_CODE_OAUTH_TOKEN=$CLAUDE_CODE_OAUTH_TOKEN"
echo "ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY"

# New Machine - Import
export CLAUDE_CODE_OAUTH_TOKEN="token"
export ANTHROPIC_API_KEY="key"

# Add to shell profile
echo 'export CLAUDE_CODE_OAUTH_TOKEN="token"' >> ~/.bashrc
echo 'export ANTHROPIC_API_KEY="key"' >> ~/.bashrc

# Clone and setup
git clone https://github.com/anthropics/claude-quickstarts.git
cd claude-quickstarts
./scripts/setup-devcontainer-oauth.sh
```

## Documentation References

- **DEVCONTAINER_GUIDE.md**: Comprehensive Dev Container setup
- **CLAUDE_CODE_INTEGRATION.md**: Claude Code integration details
- **Project READMEs**: `.devcontainer/README.md` in each project
- **Script Help**: Run scripts with no arguments for help

## Support Resources

- **Validation Script**: `./scripts/validate-oauth-setup.sh` for diagnostics
- **Anthropic Discord**: https://www.anthropic.com/discord
- **Claude API Docs**: https://docs.anthropic.com
- **Dev Containers Docs**: https://containers.dev
- **GitHub Issues**: https://github.com/anthropics/claude-quickstarts/issues

## Skill Activation

When activated, I will:
1. ✅ Help with Dev Container setup and configuration
2. ✅ Assist with OAuth token management
3. ✅ Guide through daily workflows
4. ✅ Troubleshoot issues with detailed diagnostics
5. ✅ Provide security best practices
6. ✅ Support multi-project management
7. ✅ Help with maintenance tasks
8. ✅ Offer advanced configuration guidance

I have deep knowledge of all three projects, their specific requirements, common issues, and solutions. I can help with everything from initial setup to production deployment.
