# Claude Code Skills

This directory contains Claude Code skills that provide expert assistance for working with the Claude Quickstarts repository.

## Available Skills

### DevContainer Manager (`devcontainer-manager`)

A comprehensive skill for managing Dev Containers with full CLAUDE_CODE_OAUTH_TOKEN support.

**Capabilities**:
- 🔧 Dev Container setup and configuration
- 🔐 OAuth token management (CLAUDE_CODE_OAUTH_TOKEN, ANTHROPIC_API_KEY)
- 📅 Daily development workflows
- 🔍 Troubleshooting and diagnostics
- 🛡️ Security best practices
- 📦 Multi-project management
- 🔄 Maintenance tasks

**Usage**:

In Claude Code, simply reference tasks related to Dev Containers, and the skill will automatically provide context-aware assistance.

**Example interactions**:
- "Help me set up the customer support agent Dev Container"
- "Why isn't my CLAUDE_CODE_OAUTH_TOKEN being recognized?"
- "What's the daily workflow for the financial data analyst project?"
- "How do I troubleshoot API authentication errors?"
- "Show me how to rotate my OAuth tokens"

## Skill Structure

```
.claude/
├── README.md                      # This file
└── skills/
    └── devcontainer-manager.md    # DevContainer management skill
```

## How Skills Work

Skills are markdown files that provide Claude Code with deep, structured knowledge about specific domains. When you ask questions or request help related to the skill's domain, Claude Code uses this knowledge to provide accurate, contextual assistance.

The DevContainer Manager skill contains:
- Complete project structure and configurations
- All environment variables and their purposes
- Available commands for each project
- OAuth token setup methods
- Daily workflows and best practices
- Comprehensive troubleshooting guides
- Security guidelines
- Common tasks with step-by-step instructions

## Adding Custom Skills

To add your own skills:

1. Create a new markdown file in `.claude/skills/`
2. Structure it with clear sections and information
3. Include practical examples and commands
4. Document common issues and solutions

Example:
```bash
# Create a new skill
touch .claude/skills/my-custom-skill.md

# Edit with your preferred editor
code .claude/skills/my-custom-skill.md
```

## Skill Best Practices

**DO**:
- ✅ Keep skills focused on specific domains
- ✅ Include practical, actionable information
- ✅ Provide clear examples and commands
- ✅ Document common issues and solutions
- ✅ Update skills when processes change

**DON'T**:
- ❌ Include sensitive information (tokens, keys)
- ❌ Make skills too broad or unfocused
- ❌ Forget to update when things change
- ❌ Duplicate information across skills

## Contributing

To improve existing skills or add new ones:

1. Make your changes to the skill files
2. Test the skill with Claude Code
3. Ensure accuracy and completeness
4. Submit a pull request

## Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Main DevContainer Guide](../DEVCONTAINER_GUIDE.md)
- [Claude Code Integration Guide](../CLAUDE_CODE_INTEGRATION.md)
