# Customer Support Agent Dev Container

This Dev Container configuration provides a complete development environment for the Customer Support Agent quickstart with secure OAuth token management.

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
4. Optionally add AWS credentials if using Bedrock:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_SESSION_TOKEN`

### Method 2: Local Environment Variables

Set environment variables in your local shell before opening the Dev Container:

```bash
export CLAUDE_CODE_OAUTH_TOKEN="your-token-here"
export ANTHROPIC_API_KEY="your-api-key-here"
export AWS_ACCESS_KEY_ID="your-aws-key"
export AWS_SECRET_ACCESS_KEY="your-aws-secret"
```

The `remoteEnv` configuration will automatically pass these to the container.

### Method 3: Local .env File

1. Create a `.env.local` file in the customer-support-agent directory:
```
CLAUDE_CODE_OAUTH_TOKEN=your-token-here
ANTHROPIC_API_KEY=your-api-key-here
AWS_ACCESS_KEY_ID=your-aws-key
AWS_SECRET_ACCESS_KEY=your-aws-secret
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

- `npm run dev` - Start development server with full UI
- `npm run dev:left` - Development server with left sidebar only
- `npm run dev:right` - Development server with right sidebar only
- `npm run dev:chat` - Development server with chat only
- `npm run lint` - Run ESLint
- `npm run build` - Build for production

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
