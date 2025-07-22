#!/bin/bash

# MCP-JIRA Integration - Complete Setup Script
# Creates a full project structure with configuration templates and verification scripts
# Usage: ./setup-mcp-jira.sh [PROJECT_NAME]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default project name
PROJECT_NAME=${1:-"MCP-JIRA-PROJECT"}

echo -e "${CYAN}🚀 MCP-JIRA Integration Setup${NC}"
echo -e "${CYAN}================================${NC}"
echo -e "Project name: ${YELLOW}$PROJECT_NAME${NC}"
echo ""

# Create project directory
echo -e "${BLUE}📁 Creating project structure...${NC}"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Create main directories
mkdir -p mcp_jira
mkdir -p .vscode
mkdir -p scripts
mkdir -p docs

echo -e "${GREEN}✅ Directory structure created${NC}"

# Create requirements.txt
echo -e "${BLUE}📦 Creating requirements.txt...${NC}"
cat > requirements.txt << 'REQUIREMENTS_EOF'
# MCP-JIRA Integration Dependencies
requests>=2.31.0
python-dotenv>=1.0.0
pytest>=7.4.0
black>=23.0.0
flake8>=6.0.0
REQUIREMENTS_EOF

# Create Python module
echo -e "${BLUE}🐍 Setting up Python module...${NC}"
cat > mcp_jira/__init__.py << 'INIT_EOF'
"""MCP-JIRA Integration Module"""
__version__ = "1.0.0"
__author__ = "Your Team"
INIT_EOF

cat > mcp_jira/__main__.py << 'MAIN_EOF'
#!/usr/bin/env python3
"""MCP-JIRA Local Configuration Checker"""

import os
import sys
import json
from pathlib import Path

def check_environment():
    print("🔍 Checking MCP-JIRA Configuration...")
    print("=" * 40)
    
    # Check .env file
    env_file = Path(".env")
    if env_file.exists():
        print("✅ .env file found")
    else:
        print("❌ .env file not found")
    
    # Check VS Code MCP configuration
    mcp_file = Path(".vscode/mcp.json")
    if mcp_file.exists():
        print("✅ .vscode/mcp.json found")
    else:
        print("❌ .vscode/mcp.json not found")
    
    # Check Docker
    docker_check = os.system("docker --version > /dev/null 2>&1")
    if docker_check == 0:
        print("✅ Docker is available")
    else:
        print("❌ Docker not found")
    
    print("\n🏁 Configuration check completed")

if __name__ == "__main__":
    check_environment()
MAIN_EOF

# Create .env template
echo -e "${BLUE}🔧 Creating configuration templates...${NC}"
cat > .env.template << 'ENV_EOF'
# MCP-JIRA Integration Environment Variables
JIRA_URL=https://your-jira-server.com
JIRA_PERSONAL_TOKEN=your_personal_access_token_here
JIRA_SSL_VERIFY=false
JIRA_PROJECTS_FILTER=ECAPP,PROJECT2
ENV_EOF

# Create VS Code MCP configuration template
cat > .vscode/mcp.json.template << 'MCP_EOF'
{
  "servers": {
    "mcp-atlassian": {
      "command": "docker",
      "args": [
        "run", "--rm", "-i",
        "-e", "JIRA_URL",
        "-e", "JIRA_PERSONAL_TOKEN",
        "-e", "JIRA_SSL_VERIFY",
        "ghcr.io/sooperset/mcp-atlassian:latest"
      ],
      "env": {
        "JIRA_URL": "https://your-jira-server.com",
        "JIRA_PERSONAL_TOKEN": "your_token_here",
        "JIRA_SSL_VERIFY": "false"
      }
    }
  }
}
MCP_EOF

# Create utility scripts
echo -e "${BLUE}🛠️ Creating utility scripts...${NC}"

# Configure script
cat > configure.sh << 'CONFIGURE_EOF'
#!/bin/bash
echo "🔧 MCP-JIRA Configuration Setup"
echo "================================"

if [ ! -f ".env" ]; then
    cp .env.template .env
    echo "✅ .env file created from template"
else
    echo "✅ .env file already exists"
fi

if [ ! -f ".vscode/mcp.json" ]; then
    cp .vscode/mcp.json.template .vscode/mcp.json
    echo "✅ mcp.json file created from template"
else
    echo "✅ .vscode/mcp.json file already exists"
fi

echo "⚠️  Please edit .env and .vscode/mcp.json with your JIRA credentials"
CONFIGURE_EOF

# Verify script
cat > verify-setup.sh << 'VERIFY_EOF'
#!/bin/bash
echo "🔍 MCP-JIRA Setup Verification"
echo "==============================="

# Check Docker
if command -v docker &> /dev/null; then
    echo "✅ Docker is installed"
else
    echo "❌ Docker not found"
fi

# Check configuration files
if [ -f ".env" ]; then
    echo "✅ .env file exists"
else
    echo "❌ .env file not found"
fi

if [ -f ".vscode/mcp.json" ]; then
    echo "✅ .vscode/mcp.json exists"
else
    echo "❌ .vscode/mcp.json not found"
fi

echo "🎉 Verification completed!"
VERIFY_EOF

# Make scripts executable
chmod +x configure.sh
chmod +x verify-setup.sh

# Create .gitignore
echo -e "${BLUE}🔒 Creating .gitignore...${NC}"
cat > .gitignore << 'GITIGNORE_EOF'
# Sensitive files
.env
.vscode/mcp.json

# Python
__pycache__/
*.pyc
*.pyo
*.pyd
.Python

# OS
.DS_Store
Thumbs.db

# Logs
*.log
GITIGNORE_EOF

# Create documentation
echo -e "${BLUE}📚 Creating documentation...${NC}"
cat > docs/SETUP_GUIDE.md << 'SETUP_EOF'
# MCP-JIRA Setup Guide

## Quick Start

1. Run setup script: `./setup-mcp-jira.sh MyProject`
2. Configure credentials: `cd MyProject && ./configure.sh`
3. Edit .env and mcp.json files with your JIRA details
4. Verify setup: `./verify-setup.sh`
5. Open in VS Code: `code .`

## Configuration

- JIRA_URL: Your JIRA server URL
- JIRA_PERSONAL_TOKEN: Personal access token from JIRA
- JIRA_SSL_VERIFY: Set to "false" for self-signed certificates

## Usage Examples

- "List all JIRA projects"
- "Show issues in ECAPP project for release 25.28"
- "Generate markdown summary of release issues"
SETUP_EOF

# Create project README
cat > README.md << 'README_EOF'
# MCP-JIRA Integration Project

Model Context Protocol server for connecting with JIRA.

## Quick Start

1. Run `./configure.sh` to setup configuration files
2. Edit `.env` and `.vscode/mcp.json` with your JIRA credentials
3. Run `./verify-setup.sh` to test the setup
4. Open in VS Code with MCP extension

## Configuration

Update these files with your JIRA details:
- `.env` - Environment variables
- `.vscode/mcp.json` - VS Code MCP configuration

## Usage

Use natural language queries in VS Code:
- "List all JIRA projects"
- "Show issues for release 25.28"
- "Generate release summary"

## Resources

- [MCP Documentation](https://modelcontextprotocol.io/)
- [MCP-Atlassian Plugin](https://github.com/sooperset/mcp-atlassian)
README_EOF

echo -e "${GREEN}✅ All files created successfully${NC}"
echo ""
echo -e "${PURPLE}🎉 MCP-JIRA Integration Setup Complete!${NC}"
echo -e "${PURPLE}=======================================${NC}"
echo ""
echo -e "${CYAN}📁 Project created: ${YELLOW}$PROJECT_NAME${NC}"
echo ""
echo -e "${YELLOW}🎯 Next steps:${NC}"
echo -e "  1. ${CYAN}cd $PROJECT_NAME${NC}"
echo -e "  2. ${CYAN}./configure.sh${NC} - Setup configuration files"
echo -e "  3. Edit .env and .vscode/mcp.json with your JIRA credentials"
echo -e "  4. ${CYAN}./verify-setup.sh${NC} - Verify installation"
echo -e "  5. ${CYAN}code .${NC} - Open in VS Code"
echo ""
echo -e "${GREEN}🚀 Ready to commit to GitHub and share with your team!${NC}"
