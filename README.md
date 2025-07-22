# 🚀 MCP-JIRA Integration Skeleton

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/r-pedraza/mcp-jira-integration)](https://github.com/r-pedraza/mcp-jira-integration/releases)
[![GitHub](https://img.shields.io/github/license/r-pedraza/mcp-jira-integration)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/r-pedraza/mcp-jira-integration?style=social)](https://github.com/r-pedraza/mcp-jira-integration/stargazers)

**Complete project skeleton for connecting VS Code to JIRA using Model Context Protocol (MCP). Get your team querying JIRA with natural language in minutes, not hours!**

## ✨ Features

- 🚀 **One-command setup** - Complete project scaffolding in seconds
- 🔒 **Security-first** - No credentials in git, template-based configuration
- 📚 **Comprehensive docs** - Setup guides, examples, and troubleshooting
- 🎯 **Team ready** - Perfect for organizations and development teams
- 🌍 **Cross-platform** - Works on macOS, Linux, and Windows
- ⚡ **Natural language queries** - "Show me high-priority bugs in project X"

## 📋 Prerequisites

- VS Code installed
- Docker Desktop running
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

## 🎬 Demo

<details>
<summary>🎯 Click to see setup demo</summary>

```bash
# Clone repository
git clone https://github.com/r-pedraza/mcp-jira-integration.git
cd mcp-jira-integration

# Run setup (takes ~30 seconds)
./setup-mcp-jira.sh MyJiraProject
# 🚀 MCP-JIRA Integration Setup
# ================================
# Project name: MyJiraProject
# 📁 Creating project structure...
# ✅ Directory structure created
# 📦 Creating requirements.txt...
# 🐍 Setting up Python module...
# 🔧 Creating configuration templates...
# 🛠️ Creating utility scripts...
# 🔒 Creating .gitignore...
# 📚 Creating documentation...
# ✅ All files created successfully

# Configure your credentials
cd MyJiraProject
./configure.sh
# 🔧 MCP-JIRA Configuration Setup
# ================================
# ✅ .env file created from template
# ✅ mcp.json file created from template
# ⚠️  Please edit .env and .vscode/mcp.json with your JIRA credentials

# Edit .env and .vscode/mcp.json with your actual JIRA details
# Then verify everything works
./verify-setup.sh
# 🔍 MCP-JIRA Setup Verification
# ===============================
# ✅ Docker is installed
# ✅ .env file exists
# ✅ .vscode/mcp.json exists
# 🎉 Verification completed!

# Open in VS Code and start querying!
code .
```

</details>

## 🏗️ What Gets Created

The setup script generates a complete project structure:

```
MyJiraProject/
├── 📄 README.md                   # Project documentation
├── 📦 requirements.txt            # Python dependencies  
├── 🔧 .env.template/.env         # Environment configuration
├── 🔒 .gitignore                 # Git ignore rules (protects credentials)
├── ⚙️ configure.sh               # Configuration helper script
├── ✅ verify-setup.sh            # Setup verification script
├── 🐍 mcp_jira/                  # Python module
│   ├── __init__.py
│   └── __main__.py               # Local configuration checker
├── 🎨 .vscode/
│   └── mcp.json                  # VS Code MCP configuration
└── 📚 docs/                      # Documentation
    └── SETUP_GUIDE.md           # Detailed setup instructions
```

## 🔒 Security Features

- ✅ **No sensitive data in repository** - Only templates with placeholder values
- ✅ **Credential protection** - Real tokens and URLs never committed to git
- ✅ **SSL flexibility** - Support for self-signed certificates in corporate environments
- ✅ **Project filtering** - Limit access to specific JIRA projects for performance
- ✅ **Template system** - Safe configuration management

## 🌍 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| 🍎 **macOS** | ✅ Full Support | Tested on macOS Monterey+ |
| 🐧 **Linux** | ✅ Full Support | Ubuntu, CentOS, Fedora, etc. |
| 🪟 **Windows** | ✅ Supported | Works with WSL2 and Git Bash |

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

## 🤝 Contributing

We welcome contributions! Here's how you can help:

- 🐛 **Report bugs** by opening an issue
- 💡 **Suggest features** for better JIRA integration  
- 📖 **Improve documentation** with examples and guides
- 🔧 **Submit PRs** for bug fixes and enhancements
- ⭐ **Star the repository** to show your support

### Development Setup

```bash
# Fork and clone your fork
git clone https://github.com/YOUR-USERNAME/mcp-jira-integration.git
cd mcp-jira-integration

# Test your changes
./setup-mcp-jira.sh TestProject
cd TestProject
./verify-setup.sh
```

## 📞 Support & Community

- 📖 **Documentation**: Check our [Setup Guide](docs/SETUP_GUIDE.md)
- 🐛 **Issues**: [Report bugs or request features](https://github.com/r-pedraza/mcp-jira-integration/issues)
- 💬 **Discussions**: [Join the community discussions](https://github.com/r-pedraza/mcp-jira-integration/discussions)
- 📧 **Contact**: Open an issue for support questions

## 🙏 Acknowledgments

This project is built on top of excellent open-source tools:

- 🤖 [Model Context Protocol](https://modelcontextprotocol.io/) - AI assistant integration framework
- 🔌 [MCP-Atlassian Plugin](https://github.com/sooperset/mcp-atlassian) - JIRA connectivity for MCP
- 🐳 [Docker](https://www.docker.com/) - Containerized deployment
- 🎨 [VS Code](https://code.visualstudio.com/) - The best code editor

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Star History

If this project helped you, please consider giving it a star! ⭐

[![Star History Chart](https://api.star-history.com/svg?repos=r-pedraza/mcp-jira-integration&type=Date)](https://github.com/r-pedraza/mcp-jira-integration)

---

<div align="center">

**🚀 Ready to revolutionize your JIRA workflow with VS Code?**

[Get Started Now](https://github.com/r-pedraza/mcp-jira-integration) • [View Documentation](docs/SETUP_GUIDE.md) • [Report Issues](https://github.com/r-pedraza/mcp-jira-integration/issues)

Made with ❤️ for development teams worldwide

</div>

---

**Ready!** You can now query JIRA information directly from VS Code using natural language. 🚀

*Created on July 22, 2025*
