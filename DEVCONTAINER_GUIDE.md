# Dev Container Templates with OAuth Token Support

This guide covers the Dev Container configurations available for Claude Quickstarts, with a focus on secure OAuth token and API key management.

## Overview

Each quickstart project includes a `.devcontainer` configuration that provides:
- Pre-configured development environment with all required tools
- Automatic dependency installation
- VS Code extensions for the tech stack
- Port forwarding for local development
- **Secure OAuth token and API key management**

## Available Dev Containers

### 1. Customer Support Agent
- **Technology**: Node.js 20, TypeScript, Next.js, Tailwind CSS
- **Location**: `customer-support-agent/.devcontainer/`
- **Ports**: 3000 (Next.js dev server)
- **Required Tokens**: `ANTHROPIC_API_KEY`, optional AWS credentials

### 2. Financial Data Analyst
- **Technology**: Node.js 20, TypeScript, Next.js, Recharts
- **Location**: `financial-data-analyst/.devcontainer/`
- **Ports**: 3000 (Next.js dev server)
- **Required Tokens**: `ANTHROPIC_API_KEY`

### 3. Computer Use Demo
- **Technology**: Python 3.11, Docker-in-Docker, Streamlit
- **Location**: `computer-use-demo/.devcontainer/`
- **Ports**: 8501 (Streamlit), 5900 (VNC), 6080 (noVNC), 8080 (HTTP)
- **Required Tokens**: `ANTHROPIC_API_KEY`

## OAuth Token & API Key Management

### Security Principles

**NEVER** commit sensitive credentials to version control. All our Dev Container configurations follow these best practices:

✅ **DO**:
- Use GitHub Codespaces Secrets for cloud development
- Use local environment variables for local development
- Use .env.local or .env files (ensure they're in .gitignore)
- Rotate credentials regularly
- Use `remoteEnv` to reference local environment variables

❌ **DON'T**:
- Hardcode API keys in devcontainer.json
- Commit .env files to git
- Share credentials in chat or documentation
- Use the same credentials across multiple environments

### Method 1: GitHub Codespaces Secrets (Recommended for Cloud)

Perfect for development in GitHub Codespaces.

1. Navigate to your GitHub profile
2. Go to **Settings** → **Codespaces** → **Secrets**
3. Click **New secret**
4. Add your secrets:
   - `ANTHROPIC_API_KEY`: Your Claude API key
   - `AWS_ACCESS_KEY_ID`: (Optional) For AWS Bedrock
   - `AWS_SECRET_ACCESS_KEY`: (Optional) For AWS Bedrock
   - `AWS_SESSION_TOKEN`: (Optional) For AWS Bedrock

When you launch a Codespace, these secrets are automatically available via the `remoteEnv` configuration.

#### Per-Repository Secrets

For project-specific secrets:
1. Go to your repository → **Settings** → **Secrets and variables** → **Codespaces**
2. Add repository-specific secrets
3. These override user-level secrets for this repository

### Method 2: Local Environment Variables (Recommended for Local Development)

Perfect for development on your local machine.

**On macOS/Linux:**
```bash
# Add to ~/.bashrc, ~/.zshrc, or ~/.profile
export ANTHROPIC_API_KEY="sk-ant-api03-..."
export AWS_ACCESS_KEY_ID="AKIA..."
export AWS_SECRET_ACCESS_KEY="..."

# Reload your shell
source ~/.bashrc  # or ~/.zshrc
```

**On Windows (PowerShell):**
```powershell
# Add to your PowerShell profile
$env:ANTHROPIC_API_KEY = "sk-ant-api03-..."
$env:AWS_ACCESS_KEY_ID = "AKIA..."
$env:AWS_SECRET_ACCESS_KEY = "..."
```

**On Windows (CMD):**
```cmd
setx ANTHROPIC_API_KEY "sk-ant-api03-..."
setx AWS_ACCESS_KEY_ID "AKIA..."
setx AWS_SECRET_ACCESS_KEY "..."
```

The Dev Container's `remoteEnv` configuration automatically passes these variables into the container:

```json
"remoteEnv": {
  "ANTHROPIC_API_KEY": "${localEnv:ANTHROPIC_API_KEY}"
}
```

### Method 3: .env Files (Local Development Alternative)

Perfect for project-specific configurations.

**For Next.js projects** (customer-support-agent, financial-data-analyst):
```bash
# Create .env.local in the project root
cat > customer-support-agent/.env.local <<EOF
ANTHROPIC_API_KEY=sk-ant-api03-...
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
EOF
```

**For Python projects** (computer-use-demo):
```bash
# Create .env in the project root
cat > computer-use-demo/.env <<EOF
ANTHROPIC_API_KEY=sk-ant-api03-...
API_PROVIDER=anthropic
WIDTH=1024
HEIGHT=768
EOF
```

**Important**: These files are already in `.gitignore`. Never commit them!

### Method 4: Docker Run Flags (For Production-like Testing)

When running Docker containers directly:

```bash
# Customer Support Agent or Financial Data Analyst
docker run -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY -p 3000:3000 my-image

# Computer Use Demo
docker run \
  -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
  -v $(pwd)/computer_use_demo:/home/computeruse/computer_use_demo/ \
  -p 5900:5900 -p 8501:8501 -p 6080:6080 -p 8080:8080 \
  -it computer-use-demo:local
```

## OAuth Flow Examples

### GitHub OAuth with GitHub CLI

All Dev Containers include the GitHub CLI for OAuth operations:

```bash
# Authenticate with GitHub
gh auth login

# This starts an OAuth flow:
# 1. Opens your browser
# 2. You authorize the GitHub CLI
# 3. Token is securely stored in the container

# Verify authentication
gh auth status

# Use GitHub API
gh repo list
gh pr list
gh issue create
```

### Anthropic API Key

Get your API key from [console.anthropic.com](https://console.anthropic.com):

1. Sign up or log in
2. Go to **API Keys**
3. Create a new key
4. Copy the key (starts with `sk-ant-api03-...`)
5. Store it using one of the methods above

## Getting Started with Dev Containers

### Prerequisites

- **VS Code**: Install from [code.visualstudio.com](https://code.visualstudio.com)
- **Dev Containers Extension**: Install from VS Code marketplace
- **Docker Desktop**: Install from [docker.com](https://www.docker.com/products/docker-desktop)

### Opening a Project in a Dev Container

1. Clone this repository:
   ```bash
   git clone https://github.com/anthropics/claude-quickstarts.git
   cd claude-quickstarts
   ```

2. Set up your API keys (choose one method above)

3. Open a project in VS Code:
   ```bash
   cd customer-support-agent
   code .
   ```

4. When VS Code opens, you'll see a notification:
   **"Folder contains a Dev Container configuration file. Reopen in Container?"**

   Click **"Reopen in Container"**

5. VS Code will:
   - Build the dev container
   - Install dependencies (via `postCreateCommand`)
   - Configure extensions and settings
   - Forward ports
   - Inject your environment variables

6. Start developing! The terminal is already inside the container.

### Using GitHub Codespaces

1. Navigate to the repository on GitHub
2. Click **Code** → **Codespaces** → **Create codespace on main**
3. GitHub will:
   - Create a cloud development environment
   - Load your Codespaces secrets
   - Build and configure the dev container
   - Open VS Code in your browser

4. Start developing immediately - everything is pre-configured!

## Verification Steps

After opening a Dev Container, verify your setup:

### Verify Environment Variables

```bash
# Check if API key is loaded
echo $ANTHROPIC_API_KEY

# Should output your key (or "sk-ant-api03-..." pattern)
# If empty, check your configuration method
```

### Verify Dependencies

**Node.js projects:**
```bash
node --version  # Should be v20.x.x
npm --version   # Should be 10.x.x
npm list        # Show installed packages
```

**Python project:**
```bash
python --version  # Should be 3.11.x
pip list         # Show installed packages
docker --version # Should show Docker version (for computer-use-demo)
```

### Verify GitHub CLI

```bash
gh --version
gh auth status
```

## Customizing Dev Containers

Each `.devcontainer/devcontainer.json` can be customized:

### Adding VS Code Extensions

```json
"customizations": {
  "vscode": {
    "extensions": [
      "dbaeumer.vscode-eslint",
      "your-publisher.your-extension"
    ]
  }
}
```

### Adding Environment Variables

```json
"remoteEnv": {
  "MY_CUSTOM_VAR": "${localEnv:MY_CUSTOM_VAR}",
  "STATIC_VALUE": "some-value"
}
```

### Adding Features

```json
"features": {
  "ghcr.io/devcontainers/features/aws-cli:1": {
    "version": "latest"
  }
}
```

Browse available features at [containers.dev/features](https://containers.dev/features)

### Forwarding Additional Ports

```json
"forwardPorts": [3000, 8000, 9000],
"portsAttributes": {
  "8000": {
    "label": "API Server",
    "onAutoForward": "notify"
  }
}
```

## Troubleshooting

### API Key Not Loading

**Symptom**: `echo $ANTHROPIC_API_KEY` returns empty

**Solutions**:
1. Check your local environment: `echo $ANTHROPIC_API_KEY` (in your host terminal)
2. For Codespaces: Verify secrets at GitHub Settings → Codespaces → Secrets
3. Rebuild the container: Command Palette → "Dev Containers: Rebuild Container"
4. Check `devcontainer.json` `remoteEnv` section matches your variable names

### Port Conflicts

**Symptom**: "Port 3000 is already in use"

**Solutions**:
1. Stop other processes using the port: `lsof -ti:3000 | xargs kill`
2. Change the port in your project's configuration
3. Modify `forwardPorts` in `devcontainer.json`

### Container Won't Build

**Symptom**: Build fails with errors

**Solutions**:
1. Check Docker Desktop is running
2. Clear Docker cache: `docker system prune -a`
3. Check internet connection (downloads base images)
4. Review build logs in VS Code OUTPUT panel

### GitHub CLI OAuth Fails

**Symptom**: `gh auth login` fails

**Solutions**:
1. Check internet connection
2. Try alternative auth method: `gh auth login --web`
3. Use a personal access token: `gh auth login --with-token`

## Advanced Use Cases

### Multi-Project Monorepo

If you're working on multiple quickstarts:

```bash
# Open the root in VS Code
code .

# Each project has its own devcontainer
# Right-click a project folder → "Reopen in Container"
```

### CI/CD Integration

Dev Containers can be used in GitHub Actions:

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
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

### Custom Base Images

To use a custom base image:

```json
{
  "build": {
    "dockerfile": "Dockerfile",
    "context": "."
  }
}
```

Create a `Dockerfile` in the `.devcontainer` directory.

## Best Practices

1. **Keep devcontainer.json in sync**: If you add new environment variables, update the `remoteEnv` section
2. **Document project-specific tokens**: Update the project's `.devcontainer/README.md`
3. **Test in a clean environment**: Periodically rebuild containers to ensure reproducibility
4. **Use secrets for CI/CD**: GitHub Actions, GitLab CI, etc. have their own secret management
5. **Rotate credentials**: Regularly update API keys and tokens
6. **Review permissions**: Use least-privilege principle for API keys

## Additional Resources

- [Dev Containers Documentation](https://containers.dev)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
- [GitHub Codespaces](https://github.com/features/codespaces)
- [Claude API Documentation](https://docs.anthropic.com)
- [GitHub CLI Manual](https://cli.github.com/manual/)

## Support

If you encounter issues:
1. Check project-specific README in `.devcontainer/README.md`
2. Review this guide's troubleshooting section
3. Open an issue in the [claude-quickstarts repository](https://github.com/anthropics/claude-quickstarts/issues)
4. Join the [Anthropic Discord community](https://www.anthropic.com/discord)
