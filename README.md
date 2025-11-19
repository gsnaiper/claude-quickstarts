# Claude Quickstarts

Claude Quickstarts is a collection of projects designed to help developers quickly get started with building  applications using the Claude API. Each quickstart provides a foundation that you can easily build upon and customize for your specific needs.

## Getting Started

To use these quickstarts, you'll need an Claude API key. If you don't have one yet, you can sign up for free at [console.anthropic.com](https://console.anthropic.com).

## Available Quickstarts

### Customer Support Agent

A customer support agent powered by Claude. This project demonstrates how to leverage Claude's natural language understanding and generation capabilities to create an AI-assisted customer support system with access to a knowledge base.

[Go to Customer Support Agent Quickstart](./customer-support-agent)

### Financial Data Analyst

A financial data analyst powered by Claude. This project demonstrates how to leverage Claude's capabilities with interactive data visualization to analyze financial data via chat.

[Go to Financial Data Analyst Quickstart](./financial-data-analyst)

### Computer Use Demo

An environment and tools that Claude can use to control a desktop computer. This project demonstrates how to leverage the computer use capabilities of the new Claude 3.5 Sonnet model.

[Go to Computer Use Demo Quickstart](./computer-use-demo)

## General Usage

Each quickstart project comes with its own README and setup instructions. Generally, you'll follow these steps:

1. Clone this repository
2. Navigate to the specific quickstart directory
3. Install the required dependencies
4. Set up your Claude API key as an environment variable
5. Run the quickstart application

## Dev Container Support

All quickstart projects include **Dev Container** configurations for a seamless development experience with secure OAuth token management. Dev Containers provide:

- ✨ **Pre-configured environments** with all dependencies installed
- 🔐 **Secure OAuth token and API key management** (never commit secrets!)
- 🛠️ **VS Code extensions** tailored for each tech stack
- 🚀 **One-click setup** in VS Code or GitHub Codespaces
- 🔄 **Consistent development** across different machines

### Quick Start with Dev Containers

**Option 1: VS Code + Docker Desktop**
1. Install [VS Code](https://code.visualstudio.com) and [Docker Desktop](https://www.docker.com/products/docker-desktop)
2. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
3. Set up your API key (see [DEVCONTAINER_GUIDE.md](./DEVCONTAINER_GUIDE.md))
4. Open any project folder in VS Code
5. Click "Reopen in Container" when prompted

**Option 2: GitHub Codespaces**
1. Add your `ANTHROPIC_API_KEY` to [GitHub Codespaces Secrets](https://github.com/settings/codespaces)
2. Click **Code** → **Codespaces** → **Create codespace** on this repository
3. Start coding immediately in your browser!

📖 **Full Guides**:
- [DEVCONTAINER_GUIDE.md](./DEVCONTAINER_GUIDE.md) - Comprehensive Dev Container setup and OAuth token management
- [CLAUDE_CODE_INTEGRATION.md](./CLAUDE_CODE_INTEGRATION.md) - Claude Code integration with `CLAUDE_CODE_OAUTH_TOKEN`

### Automated Setup Scripts

For quick setup with Claude Code OAuth tokens:

```bash
# 1. Set your Claude Code OAuth token
export CLAUDE_CODE_OAUTH_TOKEN="your-token-here"

# 2. Run the automated setup
./scripts/setup-devcontainer-oauth.sh

# 3. Validate your configuration
./scripts/validate-oauth-setup.sh
```

## Explore Further

To deepen your understanding of working with Claude and the Claude API, check out these resources:

- [Claude API Documentation](https://docs.claude.com)
- [Claude Cookbooks](https://github.com/anthropics/claude-cookbooks) - A collection of code snippets and guides for common tasks
- [Claude API Fundamentals Course](https://github.com/anthropics/courses/tree/master/anthropic_api_fundamentals)

## Contributing

We welcome contributions to the Claude Quickstarts repository! If you have ideas for new quickstart projects or improvements to existing ones, please open an issue or submit a pull request.

## Community and Support

- Join our [Anthropic Discord community](https://www.anthropic.com/discord) for discussions and support
- Check out the [Anthropic support documentation](https://support.anthropic.com) for additional help

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
