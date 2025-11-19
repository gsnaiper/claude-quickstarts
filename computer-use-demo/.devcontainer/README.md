# Computer Use Demo Dev Container

This Dev Container configuration provides a complete development environment for the Computer Use Demo with Docker-in-Docker support and secure OAuth token management.

## Features

- **Python 3.11**: Matches the production environment
- **Docker-in-Docker**: Build and run the computer use demo container from within the dev container
- **VS Code Extensions**: Ruff, Pylance, Black, and more for Python development
- **GitHub CLI**: Pre-installed for GitHub OAuth operations
- **Port Forwarding**: Automatically forwards ports for Streamlit (8501), VNC (5900), noVNC (6080), and HTTP (8080)
- **Secure Token Management**: Environment variables for API keys and OAuth tokens

## OAuth Token Setup

### Quick Setup with Claude Code

For automated setup with `CLAUDE_CODE_OAUTH_TOKEN`:

```bash
# From the repository root
export CLAUDE_CODE_OAUTH_TOKEN="your-token-here"
./scripts/setup-devcontainer-oauth.sh
```

See [CLAUDE_CODE_INTEGRATION.md](../../CLAUDE_CODE_INTEGRATION.md) for full Claude Code integration details.

### Method 1: GitHub Codespaces Secrets (Recommended for Codespaces)

1. Go to your GitHub profile → Settings → Codespaces → Secrets
2. Add `CLAUDE_CODE_OAUTH_TOKEN` for Claude Code integration
3. Add `ANTHROPIC_API_KEY` with your Claude API key
4. Optionally configure:
   - `API_PROVIDER` (default: "anthropic")
   - `WIDTH` (default: 1024)
   - `HEIGHT` (default: 768)

### Method 2: Local Environment Variables

Set environment variables in your local shell before opening the Dev Container:

```bash
export CLAUDE_CODE_OAUTH_TOKEN="your-token-here"
export ANTHROPIC_API_KEY="your-api-key-here"
export API_PROVIDER="anthropic"  # or "bedrock", "vertex"
```

The `remoteEnv` configuration will automatically pass these to the container.

### Method 3: Local .env File

1. Create a `.env` file in the computer-use-demo directory:
```
CLAUDE_CODE_OAUTH_TOKEN=your-token-here
ANTHROPIC_API_KEY=your-api-key-here
API_PROVIDER=anthropic
WIDTH=1024
HEIGHT=768
```

2. Load the variables before running the container

**IMPORTANT**: Never commit `.env` files! Add them to `.gitignore`.

## Getting Started

1. Open this folder in VS Code
2. When prompted, click "Reopen in Container"
3. Wait for the container to build and dependencies to install
4. Build the computer use demo Docker image:
   ```bash
   docker build . -t computer-use-demo:local
   ```
5. Run the container:
   ```bash
   docker run \
     -e ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
     -v $(pwd)/computer_use_demo:/home/computeruse/computer_use_demo/ \
     -v $HOME/.anthropic:/home/computeruse/.anthropic \
     -p 5900:5900 -p 8501:8501 -p 6080:6080 -p 8080:8080 \
     -it computer-use-demo:local
   ```

## Available Commands

### Development & Testing
- `ruff check .` - Lint Python code
- `ruff format .` - Format Python code
- `pyright` - Type check
- `pytest` - Run tests
- `pytest tests/path_to_test.py::test_name -v` - Run specific test

### Docker Operations
- `docker build . -t computer-use-demo:local` - Build the demo image
- `docker ps` - List running containers
- `docker logs <container-id>` - View container logs
- `docker exec -it <container-id> bash` - Access container shell

### Quick Setup Script
```bash
./setup.sh  # Run the setup script to configure the environment
```

## Architecture

This dev container uses Docker-in-Docker to allow you to:
1. Develop and test the Python code directly
2. Build the full computer use demo Docker image
3. Run and test the complete demo environment
4. Debug issues in both the code and the container

## Accessing the Demo

Once the computer use demo container is running:

- **Streamlit UI**: http://localhost:8501
- **noVNC Web Interface**: http://localhost:6080
- **VNC Direct**: vnc://localhost:5900

## Security Best Practices

- ✅ Use GitHub Codespaces Secrets for cloud development
- ✅ Use local environment variables or .env for local development
- ✅ Never commit API keys or tokens to version control
- ✅ Rotate credentials regularly
- ✅ Mount ~/.anthropic for persistent credential storage
- ❌ Never hardcode tokens in devcontainer.json
- ❌ Never share .env files publicly
- ❌ Never commit the .anthropic directory

## Using GitHub CLI with OAuth

The GitHub CLI is pre-installed. To authenticate:

```bash
gh auth login
```

This will initiate an OAuth flow to securely authenticate with GitHub.

## Troubleshooting

### Docker Socket Permission Issues
If you get permission errors accessing Docker, ensure the container is running in privileged mode (already configured in devcontainer.json).

### Port Already in Use
If ports are already in use, stop other containers:
```bash
docker ps
docker stop <container-id>
```

### API Key Not Loading
Verify the environment variable is set:
```bash
echo $ANTHROPIC_API_KEY
```

If empty, check your secrets/environment variable configuration.

## Alternative API Providers

To use Bedrock or Vertex AI instead of Anthropic:

```bash
# For AWS Bedrock
export API_PROVIDER="bedrock"
export AWS_REGION="us-east-1"

# For Google Vertex AI
export API_PROVIDER="vertex"
export GCP_PROJECT_ID="your-project-id"
export GCP_REGION="us-central1"
```

Update `devcontainer.json` to include these in `remoteEnv`.
