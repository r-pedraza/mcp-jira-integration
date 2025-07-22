# 🚀 MCP-JIRA Integration Setup

**Model Context Protocol (MCP) server for connecting with JIRA using sooperset/mcp-atlassian from VS Code.**

## 📋 Prerequisites

- VS Code installed
- Docker installed and running
- JIRA Server/Data Center access (not Atlassian Cloud)
- JIRA Personal Access Token
- MCP-compatible VS Code extension

## 🚀 Quick Start

### Option A: Automatic Setup (Recommended)

```bash
# Clone this repository
git clone <your-repo-url>
cd mcp-jira-integration

# Make scripts executable
chmod +x *.sh

# Run complete setup
./setup-mcp-jira.sh MyJiraProject

# Verify installation
cd MyJiraProject
./verify-setup.sh

# Configure your credentials
./configure.sh
```

### Option B: Simple Setup

```bash
# Basic setup without extras
./simple-setup.sh MyJiraProject
```

## 🔧 Configuration

1. **Generate JIRA Personal Access Token**
   - Go to your JIRA Server instance
   - Navigate to **User Profile** → **Personal Access Tokens**
   - Create new token with read permissions
   - **⚠️ IMPORTANT**: Save the token securely

2. **Configure Environment Variables**
   ```bash
   # Edit .env file
   JIRA_URL=https://your-jira-server.com
   JIRA_PERSONAL_TOKEN=your_token_here
   JIRA_SSL_VERIFY=false
   ```

3. **Setup VS Code MCP Configuration**
   - File will be created at `.vscode/mcp.json`
   - Update with your JIRA credentials

## 📊 Usage Examples

### Basic Queries
```
"List all available JIRA projects"
"What issues are in ECAPP project for release 25.28?"
"Give me details of issue ECAPP-10745"
```

### Advanced Queries
```
"Generate a markdown summary of all issues in release 25.28 for ECAPP project"
"How many issues does each developer have assigned in ECAPP project?"
"Search issues with JQL: project = ECAPP AND fixVersion = '25.28'"
```

## 🛠️ Available Scripts

| Script | Purpose |
|--------|---------|
| `setup-mcp-jira.sh` | **Complete setup** with full structure and configuration |
| `simple-setup.sh` | **Basic setup** with essential files only |
| `configure.sh` | **Quick configuration** of variables and templates |
| `verify-setup.sh` | **Verification** of installation and dependencies |

## 🔗 Resources

- [Model Context Protocol](https://modelcontextprotocol.io/)
- [MCP-Atlassian Plugin](https://github.com/sooperset/mcp-atlassian)
- [JIRA REST API Documentation](https://docs.atlassian.com/software/jira/docs/api/REST/latest/)

## 🐛 Troubleshooting

### Authentication Error (401)
- Verify token validity
- Check token permissions
- For JIRA Server: use Personal Access Token (not Cloud API Token)

### SSL Connection Error
```json
"JIRA_SSL_VERIFY": "false"
```

### Docker Not Found
- Install Docker Desktop
- Verify Docker is in PATH
- Restart VS Code after Docker installation

## 📝 License

MIT License - feel free to use and modify.

---

**Ready!** You can now query JIRA information directly from VS Code using natural language. 🚀

*Created on July 22, 2025*
