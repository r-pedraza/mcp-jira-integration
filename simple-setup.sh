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

# Create Python module structure
echo -e "${BLUE}🐍 Setting up Python module...${NC}"

cat > mcp_jira/__init__.py << 'EOF'
"""
MCP-JIRA Integration Module
Model Context Protocol server for JIRA connectivity
"""

__version__ = "1.0.0"
__author__ = "Your Team"
__description__ = "MCP server for JIRA integration using sooperset/mcp-atlassian"
EOF

cat > mcp_jira/__main__.py << 'EOF'
#!/usr/bin/env python3
"""
MCP-JIRA Local Configuration Checker
Validates local environment and configuration files
"""

import os
import sys
import json
from pathlib import Path

def check_environment():
    """Check environment variables and configuration"""
    print("🔍 Checking MCP-JIRA Configuration...")
    print("=" * 40)
    
    # Check .env file
    env_file = Path(".env")
    if env_file.exists():
        print("✅ .env file found")
        with open(env_file) as f:
            content = f.read()
            if "JIRA_URL" in content:
                print("✅ JIRA_URL configured")
            else:
                print("❌ JIRA_URL not found in .env")
    else:
        print("❌ .env file not found")
    
    # Check VS Code MCP configuration
    mcp_file = Path(".vscode/mcp.json")
    if mcp_file.exists():
        print("✅ .vscode/mcp.json found")
        try:
            with open(mcp_file) as f:
                config = json.load(f)
                if "mcp-atlassian" in config.get("servers", {}):
                    print("✅ mcp-atlassian server configured")
                else:
                    print("❌ mcp-atlassian server not configured")
        except json.JSONDecodeError:
            print("❌ Invalid JSON in mcp.json")
    else:
        print("❌ .vscode/mcp.json not found")
    
    # Check Docker
    docker_check = os.system("docker --version > /dev/null 2>&1")
    if docker_check == 0:
        print("✅ Docker is available")
    else:
        print("❌ Docker not found or not running")
    
    print("\n🏁 Configuration check completed")
    print("Run './configure.sh' to set up missing configurations")

if __name__ == "__main__":
    check_environment()
EOF

echo -e "${GREEN}✅ Python module created${NC}"

# Create requirements.txt
echo -e "${BLUE}📦 Creating requirements.txt...${NC}"

cat > requirements.txt << 'EOF'
# MCP-JIRA Integration Dependencies
# Model Context Protocol and JIRA connectivity

# Core dependencies
requests>=2.31.0
python-dotenv>=1.0.0

# Optional: For local development and testing
pytest>=7.4.0
black>=23.0.0
flake8>=6.0.0

# Documentation
mkdocs>=1.5.0
mkdocs-material>=9.0.0
EOF

echo -e "${GREEN}✅ requirements.txt created${NC}"

# Create .env template
echo -e "${BLUE}🔧 Creating configuration templates...${NC}"

cat > .env.template << 'EOF'
# MCP-JIRA Integration Environment Variables
# Copy this file to .env and fill in your actual values

# JIRA Server Configuration
JIRA_URL=https://your-jira-server.com
JIRA_PERSONAL_TOKEN=your_personal_access_token_here
JIRA_SSL_VERIFY=false

# Optional: Project filtering
JIRA_PROJECTS_FILTER=ECAPP,PROJECT2,PROJECT3

# Optional: Debug settings
DEBUG=false
LOG_LEVEL=INFO
EOF

# Create VS Code MCP configuration template
cat > .vscode/mcp.json.template << 'EOF'
{
  "servers": {
    "github": {
      "url": "https://api.githubcopilot.com/mcp"
    },
    "mcp-atlassian": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "-e", "JIRA_URL",
        "-e", "JIRA_PERSONAL_TOKEN",
        "-e", "JIRA_SSL_VERIFY",
        "ghcr.io/sooperset/mcp-atlassian:latest"
      ],
      "env": {
        "JIRA_URL": "https://your-jira-server.com",
        "JIRA_PERSONAL_TOKEN": "your_personal_access_token_here",
        "JIRA_SSL_VERIFY": "false"
      }
    }
  },
  "inputs": [
    {
      "id": "jira_mcp_path",
      "type": "promptString",
      "description": "Enter your Personal Access Token for MCP integration with Atlassian JIRA",
      "password": true
    }
  ]
}
EOF

echo -e "${GREEN}✅ Configuration templates created${NC}"

# Create utility scripts
echo -e "${BLUE}🛠️ Creating utility scripts...${NC}"

# Configure script
cat > configure.sh << 'EOF'
#!/bin/bash

# MCP-JIRA Configuration Script
# Quick setup of environment and configuration files

set -e

echo "🔧 MCP-JIRA Configuration Setup"
echo "================================"

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "📝 Creating .env from template..."
    cp .env.template .env
    echo "✅ .env file created"
    echo "⚠️  Please edit .env file with your actual JIRA credentials"
else
    echo "✅ .env file already exists"
fi

# Check if mcp.json exists
if [ ! -f ".vscode/mcp.json" ]; then
    echo "📝 Creating .vscode/mcp.json from template..."
    cp .vscode/mcp.json.template .vscode/mcp.json
    echo "✅ mcp.json file created"
    echo "⚠️  Please edit .vscode/mcp.json with your actual JIRA credentials"
else
    echo "✅ .vscode/mcp.json file already exists"
fi

echo ""
echo "🎯 Next steps:"
echo "1. Edit .env file with your JIRA URL and token"
echo "2. Edit .vscode/mcp.json with your JIRA credentials"
echo "3. Run ./verify-setup.sh to test the configuration"
echo "4. Open project in VS Code"
EOF

# Verify setup script
cat > verify-setup.sh << 'EOF'
#!/bin/bash

# MCP-JIRA Setup Verification Script
# Checks all dependencies and configuration

set -e

echo "🔍 MCP-JIRA Setup Verification"
echo "==============================="

# Check Docker
echo "🐳 Checking Docker..."
if command -v docker &> /dev/null; then
    echo "✅ Docker is installed"
    if docker info &> /dev/null; then
        echo "✅ Docker is running"
    else
        echo "❌ Docker is not running. Please start Docker."
        exit 1
    fi
else
    echo "❌ Docker is not installed. Please install Docker Desktop."
    exit 1
fi

# Check VS Code
echo ""
echo "📝 Checking VS Code..."
if command -v code &> /dev/null; then
    echo "✅ VS Code is installed"
else
    echo "❌ VS Code is not in PATH. Please install VS Code or add it to PATH."
fi

# Check Python
echo ""
echo "🐍 Checking Python..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "✅ Python is installed: $PYTHON_VERSION"
else
    echo "⚠️  Python3 not found. Recommended for local development."
fi

# Check configuration files
echo ""
echo "🔧 Checking configuration files..."

if [ -f ".env" ]; then
    echo "✅ .env file exists"
    if grep -q "your_personal_access_token_here" .env; then
        echo "⚠️  .env file contains template values. Please update with real credentials."
    else
        echo "✅ .env file appears to be configured"
    fi
else
    echo "❌ .env file not found. Run ./configure.sh first."
fi

if [ -f ".vscode/mcp.json" ]; then
    echo "✅ .vscode/mcp.json exists"
    if grep -q "your_personal_access_token_here" .vscode/mcp.json; then
        echo "⚠️  mcp.json contains template values. Please update with real credentials."
    else
        echo "✅ mcp.json appears to be configured"
    fi
else
    echo "❌ .vscode/mcp.json not found. Run ./configure.sh first."
fi

# Test MCP-Atlassian container
echo ""
echo "🧪 Testing MCP-Atlassian container..."
if docker pull ghcr.io/sooperset/mcp-atlassian:latest &> /dev/null; then
    echo "✅ MCP-Atlassian container downloaded successfully"
else
    echo "⚠️  Could not download MCP-Atlassian container. Check internet connection."
fi

# Run local configuration check
echo ""
echo "🏁 Running local configuration check..."
if [ -f "mcp_jira/__main__.py" ]; then
    python3 mcp_jira/__main__.py
else
    echo "❌ mcp_jira/__main__.py not found"
fi

echo ""
echo "🎉 Verification completed!"
echo ""
echo "📋 Summary:"
echo "- ✅ Docker: Ready"
echo "- ✅ Project structure: Created"
echo "- ⚠️  Configuration: Update .env and mcp.json with your credentials"
echo "- 🚀 Ready to open in VS Code"
EOF

# Make scripts executable
chmod +x configure.sh
chmod +x verify-setup.sh

echo -e "${GREEN}✅ Utility scripts created and made executable${NC}"

# Create .gitignore
echo -e "${BLUE}🔒 Creating .gitignore...${NC}"

cat > .gitignore << 'EOF'
# Environment variables - NEVER commit real credentials
.env

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
venv/
env/
ENV/

# VS Code
.vscode/settings.json
.vscode/launch.json
.vscode/mcp.json

# Logs
*.log
logs/

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Temporary files
*.tmp
*.temp
*.swp
*.swo

# Documentation builds
docs/_build/
site/
EOF

echo -e "${GREEN}✅ .gitignore created${NC}"

# Create simple setup script
echo -e "${BLUE}⚡ Creating simple setup script...${NC}"

cat > simple-setup.sh << 'EOF'
#!/bin/bash

# MCP-JIRA Simple Setup Script
# Creates basic project structure with essential files only
# Usage: ./simple-setup.sh [PROJECT_NAME]

set -e

PROJECT_NAME=${1:-"MCP-JIRA-SIMPLE"}

echo "⚡ MCP-JIRA Simple Setup"
echo "========================"
echo "Project: $PROJECT_NAME"

# Create basic structure
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

mkdir -p mcp_jira
mkdir -p .vscode

# Create basic files
cat > README.md << 'EOREADME'
# MCP-JIRA Integration

Basic setup for Model Context Protocol (MCP) server connecting to JIRA.

## Quick Start

1. Copy `.env.template` to `.env` and configure your JIRA credentials
2. Copy `.vscode/mcp.json.template` to `.vscode/mcp.json` and update credentials
3. Open in VS Code with MCP extension installed

## Configuration

- JIRA_URL: Your JIRA server URL
- JIRA_PERSONAL_TOKEN: Your personal access token
- JIRA_SSL_VERIFY: Set to "false" for self-signed certificates
EOREADME

cat > .env.template << 'EOENV'
JIRA_URL=https://your-jira-server.com
JIRA_PERSONAL_TOKEN=your_token_here
JIRA_SSL_VERIFY=false
EOENV

cat > .vscode/mcp.json.template << 'EOMCP'
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
EOMCP

cat > mcp_jira/__init__.py << 'EOINIT'
"""MCP-JIRA Integration - Simple Setup"""
__version__ = "1.0.0"
EOINIT

cat > .gitignore << 'EOGIT'
.env
.vscode/mcp.json
__pycache__/
*.pyc
.DS_Store
EOGIT

echo "✅ Simple setup completed for $PROJECT_NAME"
echo "📝 Next: Configure .env and .vscode/mcp.json files"
EOF

chmod +x simple-setup.sh

echo -e "${GREEN}✅ Simple setup script created${NC}"

# Create documentation
echo -e "${BLUE}📚 Creating documentation...${NC}"

cat > docs/SETUP_GUIDE.md << 'EOF'
# MCP-JIRA Setup Guide

## Prerequisites

- Docker Desktop installed and running
- VS Code with MCP extension
- JIRA Server/Data Center access
- Personal Access Token from JIRA

## Step-by-Step Setup

### 1. Clone and Setup

```bash
git clone <your-repo>
cd mcp-jira-integration
chmod +x *.sh
./setup-mcp-jira.sh MyProject
```

### 2. Configure Credentials

```bash
cd MyProject
./configure.sh
# Edit .env with your JIRA URL and token
# Edit .vscode/mcp.json with your credentials
```

### 3. Verify Installation

```bash
./verify-setup.sh
```

### 4. Open in VS Code

```bash
code .
```

## Configuration Details

### JIRA Personal Access Token

1. Login to your JIRA Server
2. Go to Profile → Personal Access Tokens
3. Create new token with appropriate permissions
4. Copy token to .env and mcp.json files

### Environment Variables

- `JIRA_URL`: Full URL to your JIRA server
- `JIRA_PERSONAL_TOKEN`: Token from step above
- `JIRA_SSL_VERIFY`: Set to "false" for self-signed certificates

## Usage Examples

Once configured, you can use natural language queries in VS Code:

- "List all JIRA projects"
- "Show issues in ECAPP project"
- "Generate release summary for version 25.28"
- "Find high priority bugs in current sprint"

## Troubleshooting

### Common Issues

1. **Authentication Error**: Verify token and permissions
2. **SSL Error**: Set `JIRA_SSL_VERIFY=false`
3. **Docker Error**: Ensure Docker is running
4. **Connection Error**: Check JIRA URL and network access
EOF

cat > docs/API_EXAMPLES.md << 'EOF'
# MCP-JIRA API Examples

## Basic Queries

### List Projects
```
Query: "List all available JIRA projects"
```

### Get Issue Details
```
Query: "Show me details of issue ECAPP-10352"
```

### Search by JQL
```
Query: "Search issues with JQL: project = ECAPP AND status = 'In Progress'"
```

## Advanced Examples

### Release Summary
```
Query: "Generate a markdown summary of all issues in release 25.28 for project ECAPP"
```

### Developer Workload
```
Query: "How many open issues are assigned to each developer in ECAPP?"
```

### Sprint Analysis
```
Query: "Show me all issues in the current sprint for board 'ECAPP Board'"
```

### Issue Linking
```
Query: "Find all issues linked to ECAPP-10352"
```

## JQL Examples

### By Status
```jql
project = ECAPP AND status IN ("To Do", "In Progress", "Review")
```

### By Release
```jql
project = ECAPP AND fixVersion = "25.28"
```

### By Priority
```jql
project = ECAPP AND priority IN (High, Critical)
```

### By Assignee
```jql
project = ECAPP AND assignee = currentUser()
```

### Recent Updates
```jql
project = ECAPP AND updated >= -7d
```

### By Labels
```jql
project = ECAPP AND labels IN (frontend, backend, urgent)
```
EOF

echo -e "${GREEN}✅ Documentation created${NC}"

# Create final README for the project
cat > README.md << 'EOF'
# MCP-JIRA Integration Project

Model Context Protocol (MCP) server for connecting with JIRA using sooperset/mcp-atlassian.

## 🚀 Quick Start

```bash
# 1. Clone this repository
git clone <your-repo-url>
cd mcp-jira-integration

# 2. Run setup script
chmod +x *.sh
./setup-mcp-jira.sh MyJiraProject

# 3. Configure credentials
cd MyJiraProject
./configure.sh
# Edit .env and .vscode/mcp.json with your JIRA credentials

# 4. Verify setup
./verify-setup.sh

# 5. Open in VS Code
code .
```

## 📁 Project Structure

```
MyJiraProject/
├── README.md                   # Project documentation
├── requirements.txt            # Python dependencies
├── .env.template              # Environment variables template
├── .gitignore                 # Git ignore rules
├── configure.sh               # Configuration script
├── verify-setup.sh            # Setup verification
├── simple-setup.sh            # Alternative simple setup
├── mcp_jira/                  # Python module
│   ├── __init__.py
│   └── __main__.py            # Local config checker
├── .vscode/
│   └── mcp.json.template      # VS Code MCP configuration
└── docs/                      # Documentation
    ├── SETUP_GUIDE.md
    └── API_EXAMPLES.md
```

## 🔧 Configuration

1. **JIRA Personal Access Token**: Generate in JIRA Server
2. **Environment Variables**: Configure in `.env` file
3. **VS Code MCP**: Configure in `.vscode/mcp.json`

## 📊 Usage

Use natural language queries in VS Code:
- "List all JIRA projects"
- "Show issues for release 25.28"
- "Generate release summary in markdown"

## 🛠️ Scripts

- `setup-mcp-jira.sh`: Complete project setup
- `simple-setup.sh`: Basic setup only
- `configure.sh`: Quick configuration
- `verify-setup.sh`: Installation verification

## 📚 Documentation

- [Setup Guide](docs/SETUP_GUIDE.md)
- [API Examples](docs/API_EXAMPLES.md)

## 🔗 Resources

- [Model Context Protocol](https://modelcontextprotocol.io/)
- [MCP-Atlassian Plugin](https://github.com/sooperset/mcp-atlassian)
- [JIRA REST API](https://docs.atlassian.com/software/jira/docs/api/REST/latest/)
EOF

echo -e "${GREEN}✅ Project README created${NC}"

# Create GitHub workflow (optional)
mkdir -p .github/workflows

cat > .github/workflows/verify.yml << 'EOF'
name: Verify MCP-JIRA Setup

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  verify-scripts:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Make scripts executable
      run: chmod +x *.sh
    
    - name: Test setup script
      run: ./setup-mcp-jira.sh TestProject
    
    - name: Verify project structure
      run: |
        cd TestProject
        ls -la
        test -f README.md
        test -f .env.template
        test -f .vscode/mcp.json.template
        test -f configure.sh
        test -f verify-setup.sh
    
    - name: Test configuration script
      run: |
        cd TestProject
        ./configure.sh
        test -f .env
        test -f .vscode/mcp.json
EOF

echo -e "${GREEN}✅ GitHub workflow created${NC}"

# Final summary
echo ""
echo -e "${PURPLE}🎉 MCP-JIRA Integration Setup Complete!${NC}"
echo -e "${PURPLE}=====================================s${NC}"
echo ""
echo -e "${CYAN}📁 Project created: ${YELLOW}$PROJECT_NAME${NC}"
echo ""
echo -e "${BLUE}📋 What was created:${NC}"
echo -e "  ✅ Complete project structure"
echo -e "  ✅ Configuration templates (.env.template, mcp.json.template)"
echo -e "  ✅ Utility scripts (configure.sh, verify-setup.sh, simple-setup.sh)"
echo -e "  ✅ Python module with local config checker"
echo -e "  ✅ Documentation (setup guide, API examples)"
echo -e "  ✅ .gitignore with security best practices"
echo -e "  ✅ GitHub workflow for CI/CD"
echo ""
echo -e "${YELLOW}🎯 Next steps:${NC}"
echo -e "  1. ${CYAN}cd $PROJECT_NAME${NC}"
echo -e "  2. ${CYAN}./configure.sh${NC} - Setup configuration files"
echo -e "  3. Edit .env and .vscode/mcp.json with your JIRA credentials"
echo -e "  4. ${CYAN}./verify-setup.sh${NC} - Verify installation"
echo -e "  5. ${CYAN}code .${NC} - Open in VS Code"
echo ""
echo -e "${GREEN}🚀 Ready to commit to GitHub and share with your team!${NC}"
EOF

chmod +x setup-mcp-jira.sh

echo -e "${GREEN}✅ Main setup script created and made executable${NC}"

<function_calls>
<invoke name="create_file">
<parameter name="content">#!/bin/bash

# MCP-JIRA Simple Setup Script
# Creates basic project structure with essential files only
# Usage: ./simple-setup.sh [PROJECT_NAME]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_NAME=${1:-"MCP-JIRA-SIMPLE"}

echo -e "${BLUE}⚡ MCP-JIRA Simple Setup${NC}"
echo -e "${BLUE}========================${NC}"
echo -e "Project: ${YELLOW}$PROJECT_NAME${NC}"

# Create basic structure
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

mkdir -p mcp_jira
mkdir -p .vscode

# Create basic files
cat > README.md << 'EOREADME'
# MCP-JIRA Integration

Basic setup for Model Context Protocol (MCP) server connecting to JIRA.

## Quick Start

1. Copy `.env.template` to `.env` and configure your JIRA credentials
2. Copy `.vscode/mcp.json.template` to `.vscode/mcp.json` and update credentials
3. Open in VS Code with MCP extension installed

## Configuration

- JIRA_URL: Your JIRA server URL
- JIRA_PERSONAL_TOKEN: Your personal access token
- JIRA_SSL_VERIFY: Set to "false" for self-signed certificates

## Usage Examples

- "List all JIRA projects"
- "Show issues in ECAPP project for release 25.28"
- "Generate markdown summary of release issues"
EOREADME

cat > .env.template << 'EOENV'
# MCP-JIRA Configuration
JIRA_URL=https://your-jira-server.com
JIRA_PERSONAL_TOKEN=your_token_here
JIRA_SSL_VERIFY=false
EOENV

cat > .vscode/mcp.json.template << 'EOMCP'
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
EOMCP

cat > mcp_jira/__init__.py << 'EOINIT'
"""MCP-JIRA Integration - Simple Setup"""
__version__ = "1.0.0"
EOINIT

cat > requirements.txt << 'EOREQ'
# Basic dependencies for MCP-JIRA integration
requests>=2.31.0
python-dotenv>=1.0.0
EOREQ

cat > .gitignore << 'EOGIT'
# Sensitive files - never commit credentials
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
EOGIT

echo -e "${GREEN}✅ Simple setup completed for $PROJECT_NAME${NC}"
echo ""
echo -e "${YELLOW}📝 Next steps:${NC}"
echo -e "  1. cd $PROJECT_NAME"
echo -e "  2. Copy .env.template to .env and configure"
echo -e "  3. Copy .vscode/mcp.json.template to .vscode/mcp.json and configure"
echo -e "  4. Open in VS Code: code ."
