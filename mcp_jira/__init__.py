"""
MCP-JIRA Integration Module

Este módulo proporciona la integración entre Model Context Protocol (MCP) y JIRA
usando el servidor mcp-atlassian de Sooperset.

Author: MCP-JIRA Team
License: MIT
"""

__version__ = "1.0.0"
__author__ = "MCP-JIRA Team"
__email__ = "support@example.com"

# Información del paquete
PACKAGE_NAME = "mcp-jira"
DESCRIPTION = "Integración Model Context Protocol (MCP) con JIRA"
URL = "https://github.com/your-username/mcp-jira-skeleton"

# Configuración por defecto
DEFAULT_JIRA_SERVER = "https://your-domain.atlassian.net"
DEFAULT_MCP_SERVER = "ghcr.io/sooperset/mcp-atlassian:latest"

# Versiones compatibles
SUPPORTED_PYTHON_VERSIONS = ["3.8", "3.9", "3.10", "3.11", "3.12"]
REQUIRED_MCP_VERSION = ">=0.4.0"

def get_version():
    """Retorna la versión actual del módulo."""
    return __version__

def get_package_info():
    """Retorna información completa del paquete."""
    return {
        "name": PACKAGE_NAME,
        "version": __version__,
        "description": DESCRIPTION,
        "author": __author__,
        "url": URL,
        "supported_python": SUPPORTED_PYTHON_VERSIONS,
        "mcp_version": REQUIRED_MCP_VERSION
    }
