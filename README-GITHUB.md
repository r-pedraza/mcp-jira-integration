# 🚀 MCP-JIRA Integration - GitHub Skeleton

**Complete project skeleton for Model Context Protocol (MCP) server connecting to JIRA using sooperset/mcp-atlassian.**

This repository provides everything your team needs to quickly set up MCP-JIRA integration in VS Code.

## 📋 Prerequisites

- VS Code installed
- Docker Desktop installed and running
- JIRA Server/Data Center access (not Atlassian Cloud)
- Personal Access Token from JIRA
- MCP-compatible VS Code extension

## 🚀 Quick Start

### Option A: Complete Setup (Recommended)

```bash
# 1. Clone this repository
git clone https://github.com/your-org/mcp-jira-integration.git
cd mcp-jira-integration

# 2. Make scripts executable
chmod +x *.sh

# 3. Run complete setup
./setup-mcp-jira.sh MyJiraProject

# 4. Configure credentials
cd MyJiraProject
./configure.sh

# 5. Edit configuration files with your JIRA details
# - Edit .env file
# - Edit .vscode/mcp.json file

# 6. Verify everything works
./verify-setup.sh

# 7. Open in VS Code
code .
```

### Option B: Simple Setup

For a minimal setup with just the essential files:

```bash
./simple-setup.sh MySimpleProject
cd MySimpleProject
# Configure .env and .vscode/mcp.json manually
```

## 📁 What Gets Created

The setup script creates a complete project structure:

```
MyJiraProject/
├── README.md                   # Project documentation
├── requirements.txt            # Python dependencies
├── .env.template              # Environment variables template
├── .env                       # Your configuration (created by configure.sh)
├── .gitignore                 # Git ignore rules (protects credentials)
├── configure.sh               # Quick configuration script
├── verify-setup.sh            # Setup verification script
├── simple-setup.sh            # Alternative minimal setup
├── mcp_jira/                  # Python module
│   ├── __init__.py           # Module initialization
│   └── __main__.py           # Local configuration checker
├── .vscode/
│   ├── mcp.json.template     # VS Code MCP configuration template
│   └── mcp.json              # Your MCP config (created by configure.sh)
├── docs/                      # Documentation
│   ├── SETUP_GUIDE.md        # Detailed setup instructions
│   └── API_EXAMPLES.md       # Usage examples and JQL queries
├── scripts/                   # Additional utility scripts
└── .github/
    └── workflows/
        └── verify.yml         # GitHub Actions workflow
```

## 🔧 Configuration Steps

### 1. Get JIRA Personal Access Token

1. Login to your JIRA Server instance
2. Navigate to **User Profile** → **Personal Access Tokens**
3. Create a new token with read permissions
4. **⚠️ IMPORTANT**: Save the token securely

### 2. Configure Environment Variables

The `configure.sh` script will create `.env` from the template. Edit it with:

```bash
JIRA_URL=https://your-jira-server.com
JIRA_PERSONAL_TOKEN=your_actual_token_here
JIRA_SSL_VERIFY=false
```

### 3. Configure VS Code MCP

The script also creates `.vscode/mcp.json` from the template. Update it with your credentials.

## 🛠️ Available Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `setup-mcp-jira.sh` | **Complete setup** with full structure | `./setup-mcp-jira.sh ProjectName` |
| `simple-setup.sh` | **Basic setup** with essential files only | `./simple-setup.sh ProjectName` |
| `configure.sh` | **Quick configuration** of templates | `./configure.sh` |
| `verify-setup.sh` | **Verification** of installation and deps | `./verify-setup.sh` |

## 📊 Usage Examples

Once configured and opened in VS Code with MCP extension, you can use natural language queries:

### Basic Queries
```
"List all available JIRA projects"
"Show me issues in ECAPP project for release 25.28"
"Give me details of issue ECAPP-10352"
```

### Advanced Queries
```
"Generate a markdown summary of all issues in release 25.28 for ECAPP project"
"How many open issues are assigned to each developer in ECAPP?"
"Search issues with JQL: project = ECAPP AND status = 'In Progress'"
```

### JQL Examples
```
"Find high priority bugs: project = ECAPP AND priority = High AND issuetype = Bug"
"Show recent updates: project = ECAPP AND updated >= -7d"
"List my assignments: assignee = currentUser() AND status != Closed"
```

## 🔒 Security Features

- **Credentials protection**: `.env` and `mcp.json` are in `.gitignore`
- **Template files**: Only templates are committed to git
- **Token masking**: Secure handling of Personal Access Tokens
- **SSL flexibility**: Option to disable SSL verification for internal servers

## 🧪 Testing Your Setup

After configuration, run the verification script:

```bash
./verify-setup.sh
```

This checks:
- ✅ Docker installation and status
- ✅ VS Code availability
- ✅ Configuration file presence
- ✅ MCP-Atlassian container download
- ✅ Local environment validation

## 🐛 Troubleshooting

### Common Issues

**Authentication Error (401)**
- Verify your Personal Access Token is correct
- Check token permissions in JIRA
- For JIRA Server: use Personal Access Token (not Cloud API Token)

**SSL Certificate Error**
```bash
# In .env file
JIRA_SSL_VERIFY=false
```

**Docker Not Found**
- Install Docker Desktop
- Ensure Docker is running
- Restart VS Code after Docker installation

**MCP Extension Issues**
- Install MCP-compatible extension in VS Code
- Check VS Code Command Palette for MCP commands
- Verify `.vscode/mcp.json` syntax

## 📚 Documentation

- [Detailed Setup Guide](docs/SETUP_GUIDE.md)
- [API Examples and JQL Reference](docs/API_EXAMPLES.md)
- [Model Context Protocol Documentation](https://modelcontextprotocol.io/)
- [MCP-Atlassian Plugin](https://github.com/sooperset/mcp-atlassian)

## 🤝 Team Collaboration

### For Repository Maintainers

1. Fork this repository to your organization
2. Update URLs and team-specific configurations
3. Add your JIRA server details to documentation
4. Set up GitHub Actions for automated testing

### For Team Members

1. Clone the team repository
2. Run setup script with your preferred project name
3. Configure with your personal JIRA token
4. Start querying JIRA from VS Code!

## 🔄 GitHub Actions

The skeleton includes a GitHub workflow (`.github/workflows/verify.yml`) that:
- Tests script execution
- Verifies project structure creation
- Validates configuration templates
- Ensures setup process works correctly

## 📈 Advanced Features

### Custom Queries Module

The skeleton includes a Python module structure for custom query development:

```python
# mcp_jira/queries.py (you can create this)
class JiraQueries:
    @staticmethod
    def release_summary(project, version):
        return f"project = {project} AND fixVersion = '{version}'"
```

### VS Code Shortcuts

Add custom keybindings for frequent queries:

```json
// .vscode/keybindings.json
[
  {
    "key": "ctrl+shift+j",
    "command": "workbench.action.chat.open",
    "args": {"query": "List JIRA projects"}
  }
]
```

## 📄 License

MIT License - Feel free to use and modify for your organization.

## 🎯 Ready to Deploy

This skeleton is ready to:
- ✅ Commit to your GitHub repository
- ✅ Share with your development team
- ✅ Use in CI/CD pipelines
- ✅ Customize for your organization's needs

---

**🚀 Get your team connected to JIRA through VS Code in minutes, not hours!**

*Created on July 22, 2025*
