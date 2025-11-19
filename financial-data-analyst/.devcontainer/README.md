# Financial Data Analyst Dev Container

This Dev Container configuration provides a complete development environment for the Financial Data Analyst quickstart with secure OAuth token management.

## Features

- **Node.js 20**: Latest LTS version with TypeScript support
- **VS Code Extensions**: ESLint, Prettier, Tailwind CSS IntelliSense, and more
- **GitHub CLI**: Pre-installed for GitHub OAuth operations
- **Port Forwarding**: Automatically forwards port 3000 for Next.js dev server
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
4. The container will automatically load these secrets

### Method 2: Local Environment Variables

Set environment variables in your local shell before opening the Dev Container:

```bash
export CLAUDE_CODE_OAUTH_TOKEN="your-token-here"
export ANTHROPIC_API_KEY="your-api-key-here"
```

The `remoteEnv` configuration will automatically pass these to the container.

### Method 3: Local .env File

1. Create a `.env.local` file in the financial-data-analyst directory:
```
CLAUDE_CODE_OAUTH_TOKEN=your-token-here
ANTHROPIC_API_KEY=your-api-key-here
```

2. The Next.js application will automatically load these variables

**IMPORTANT**: Never commit `.env.local` files! They're already in `.gitignore`.

## Getting Started

1. Open this folder in VS Code
2. When prompted, click "Reopen in Container"
3. Wait for the container to build and dependencies to install
4. Run `npm run dev` to start the development server
5. Open http://localhost:3000 in your browser

## Available Commands

- `npm run dev` - Start development server
- `npm run lint` - Run ESLint
- `npm run build` - Build for production
- `npm start` - Start production server

## Working with Financial Data

This project uses Recharts for data visualization. The Dev Container includes all necessary dependencies for:
- Interactive charts and graphs
- Real-time data analysis with Claude
- Financial metrics calculation
- Data export functionality

## Security Best Practices

- ✅ Use GitHub Codespaces Secrets for cloud development
- ✅ Use local environment variables or .env.local for local development
- ✅ Never commit API keys or tokens to version control
- ✅ Rotate credentials regularly
- ❌ Never hardcode tokens in devcontainer.json
- ❌ Never share .env files publicly

## Using GitHub CLI with OAuth

The GitHub CLI is pre-installed. To authenticate:

```bash
gh auth login
```

This will initiate an OAuth flow to securely authenticate with GitHub.

## Additional Configuration

If you need to access external financial data APIs, add their tokens using the same methods:

```bash
# In your shell or Codespaces secrets
export ALPHA_VANTAGE_API_KEY="your-key"
export FINANCIAL_MODELING_PREP_KEY="your-key"
```

Then update `devcontainer.json` to include them in `remoteEnv`.
