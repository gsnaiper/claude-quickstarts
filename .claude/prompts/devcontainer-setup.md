# DevContainer Quick Setup

Use this prompt to quickly set up a Dev Container with OAuth token support.

## Quick Start Prompt

```
I need help setting up the Dev Container for [project-name] with CLAUDE_CODE_OAUTH_TOKEN.

My setup:
- Environment: [local/codespaces]
- Operating System: [macOS/Linux/Windows]
- Already have tokens: [yes/no]

Please guide me through the setup process step by step.
```

## Common Scenarios

### Scenario 1: First Time Setup (Local)

```
I'm setting up the customer-support-agent Dev Container on my local macOS machine for the first time. I have my CLAUDE_CODE_OAUTH_TOKEN and ANTHROPIC_API_KEY ready. Please walk me through the automated setup process.
```

### Scenario 2: GitHub Codespaces

```
I want to develop using GitHub Codespaces. How do I configure my CLAUDE_CODE_OAUTH_TOKEN and ANTHROPIC_API_KEY as Codespaces secrets for the financial-data-analyst project?
```

### Scenario 3: Troubleshooting

```
My Dev Container for computer-use-demo is not recognizing my CLAUDE_CODE_OAUTH_TOKEN. Can you help me debug this issue?
```

### Scenario 4: Multi-Project Setup

```
I need to work on all three quickstart projects. How do I set up Dev Containers for all of them with the same OAuth tokens?
```

### Scenario 5: Token Rotation

```
I need to rotate my CLAUDE_CODE_OAUTH_TOKEN and ANTHROPIC_API_KEY across all projects. What's the best way to do this securely?
```

## Expected Assistance

When you use these prompts, Claude Code (with the DevContainer Manager skill) will:

1. ✅ Assess your specific situation
2. ✅ Provide step-by-step instructions
3. ✅ Recommend the best token configuration method
4. ✅ Run or suggest appropriate scripts
5. ✅ Validate your setup
6. ✅ Troubleshoot any issues
7. ✅ Ensure security best practices

## Quick Commands Reference

Always available to help:

```bash
# Automated setup
./scripts/setup-devcontainer-oauth.sh

# Validation
./scripts/validate-oauth-setup.sh

# Manual check
echo $CLAUDE_CODE_OAUTH_TOKEN
echo $ANTHROPIC_API_KEY
```

## Tips for Better Assistance

1. **Be Specific**: Mention the exact project you're working on
2. **Share Context**: Describe your environment (local/cloud, OS)
3. **Include Errors**: Share error messages if troubleshooting
4. **State Your Goal**: What are you trying to achieve?
5. **Mention Constraints**: Any special requirements or limitations?

## Related Resources

- [Full DevContainer Guide](../../DEVCONTAINER_GUIDE.md)
- [Claude Code Integration](../../CLAUDE_CODE_INTEGRATION.md)
- [Project-specific READMEs](../../customer-support-agent/.devcontainer/README.md)
