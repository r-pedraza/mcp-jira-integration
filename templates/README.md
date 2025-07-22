# MCP-JIRA Integration Templates

This directory contains template files for setting up MCP-JIRA integration.

## Files Description

- `.env.template` - Environment variables template
- `mcp.json.template` - VS Code MCP configuration template
- `README.template.md` - Project README template
- `gitignore.template` - Git ignore template

## Usage

These templates are automatically used by the setup scripts. You can also use them manually:

```bash
# Copy and customize templates
cp .env.template .env
cp mcp.json.template .vscode/mcp.json

# Edit with your actual values
nano .env
nano .vscode/mcp.json
```

## Template Variables

Replace these placeholders with your actual values:

- `{{JIRA_URL}}` - Your JIRA server URL
- `{{JIRA_TOKEN}}` - Your Personal Access Token
- `{{PROJECT_NAME}}` - Your project name
- `{{DESCRIPTION}}` - Project description
