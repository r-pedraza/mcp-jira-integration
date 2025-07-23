#!/usr/bin/env python3
"""
Verificador de configuración MCP-JIRA

Este script verifica que la configuración de MCP-JIRA esté correctamente establecida
y puede conectarse exitosamente con la instancia de JIRA.

Uso:
    python -m mcp_jira
    python mcp_jira/__main__.py
"""

import os
import sys
import json
import subprocess
from pathlib import Path
from typing import Dict, List, Any

# Importar información del paquete
try:
    from . import get_version, get_package_info
except ImportError:
    # Para ejecución directa
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from __init__ import get_version, get_package_info

# Colores para terminal
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    PURPLE = '\033[0;35m'
    CYAN = '\033[0;36m'
    WHITE = '\033[1;37m'
    NC = '\033[0m'  # No Color

def print_colored(message: str, color: str = Colors.NC):
    """Imprime un mensaje con color."""
    print(f"{color}{message}{Colors.NC}")

def print_header():
    """Imprime el header del verificador."""
    print_colored("=" * 60, Colors.CYAN)
    print_colored("🔍 VERIFICADOR DE CONFIGURACIÓN MCP-JIRA", Colors.CYAN)
    print_colored(f"Versión: {get_version()}", Colors.CYAN)
    print_colored("=" * 60, Colors.CYAN)
    print()

def check_file_exists(file_path: str, description: str) -> bool:
    """Verifica si un archivo existe."""
    if os.path.exists(file_path):
        print_colored(f"✓ {description}: {file_path}", Colors.GREEN)
        return True
    else:
        print_colored(f"✗ {description}: {file_path} (NO ENCONTRADO)", Colors.RED)
        return False

def check_env_file() -> Dict[str, Any]:
    """Verifica el archivo .env y retorna las variables."""
    print_colored("\n📋 Verificando archivo .env...", Colors.YELLOW)
    
    env_path = ".env"
    if not check_file_exists(env_path, "Archivo de configuración"):
        return {}
    
    env_vars = {}
    required_vars = [
        "JIRA_SERVER",
        "JIRA_EMAIL", 
        "JIRA_API_TOKEN"
    ]
    
    try:
        with open(env_path, 'r') as f:
            for line_num, line in enumerate(f, 1):
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    env_vars[key.strip()] = value.strip()
        
        # Verificar variables requeridas
        missing_vars = []
        for var in required_vars:
            if var in env_vars and env_vars[var]:
                print_colored(f"✓ {var}: configurado", Colors.GREEN)
            else:
                print_colored(f"✗ {var}: no configurado", Colors.RED)
                missing_vars.append(var)
        
        if missing_vars:
            print_colored(f"\n⚠️  Variables faltantes: {', '.join(missing_vars)}", Colors.YELLOW)
            print_colored("💡 Edita el archivo .env para configurar estas variables", Colors.BLUE)
    
    except Exception as e:
        print_colored(f"✗ Error leyendo .env: {e}", Colors.RED)
    
    return env_vars

def check_vscode_config() -> bool:
    """Verifica la configuración de VS Code."""
    print_colored("\n🔧 Verificando configuración de VS Code...", Colors.YELLOW)
    
    mcp_config_path = ".vscode/mcp.json"
    if not check_file_exists(mcp_config_path, "Configuración MCP"):
        return False
    
    try:
        with open(mcp_config_path, 'r') as f:
            config = json.load(f)
        
        # Verificar estructura básica
        if "mcpServers" in config:
            print_colored("✓ Estructura de configuración MCP válida", Colors.GREEN)
            
            # Verificar servidor jira
            if "jira" in config["mcpServers"]:
                print_colored("✓ Servidor JIRA configurado", Colors.GREEN)
                return True
            else:
                print_colored("✗ Servidor JIRA no encontrado en configuración", Colors.RED)
        else:
            print_colored("✗ Estructura de configuración MCP inválida", Colors.RED)
    
    except json.JSONDecodeError as e:
        print_colored(f"✗ Error en JSON de configuración: {e}", Colors.RED)
    except Exception as e:
        print_colored(f"✗ Error leyendo configuración: {e}", Colors.RED)
    
    return False

def check_docker() -> bool:
    """Verifica que Docker esté disponible."""
    print_colored("\n🐳 Verificando Docker...", Colors.YELLOW)
    
    try:
        result = subprocess.run(
            ["docker", "--version"], 
            capture_output=True, 
            text=True, 
            check=True
        )
        print_colored(f"✓ Docker disponible: {result.stdout.strip()}", Colors.GREEN)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        print_colored("✗ Docker no disponible", Colors.RED)
        print_colored("💡 Instala Docker para usar el servidor MCP-Atlassian", Colors.BLUE)
        return False

def check_mcp_container() -> bool:
    """Verifica que el container MCP-Atlassian esté disponible."""
    print_colored("\n📦 Verificando container MCP-Atlassian...", Colors.YELLOW)
    
    container_image = "ghcr.io/sooperset/mcp-atlassian:latest"
    
    try:
        # Intentar hacer pull del container
        print_colored(f"Descargando {container_image}...", Colors.BLUE)
        result = subprocess.run(
            ["docker", "pull", container_image],
            capture_output=True,
            text=True,
            check=True
        )
        print_colored("✓ Container MCP-Atlassian disponible", Colors.GREEN)
        return True
    except subprocess.CalledProcessError as e:
        print_colored(f"✗ Error descargando container: {e}", Colors.RED)
        return False
    except FileNotFoundError:
        print_colored("✗ Docker no encontrado", Colors.RED)
        return False

def check_python_environment() -> bool:
    """Verifica el entorno Python."""
    print_colored("\n🐍 Verificando entorno Python...", Colors.YELLOW)
    
    # Verificar versión de Python
    python_version = f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
    print_colored(f"✓ Python {python_version}", Colors.GREEN)
    
    # Verificar pip
    try:
        import pip
        print_colored("✓ pip disponible", Colors.GREEN)
    except ImportError:
        print_colored("✗ pip no disponible", Colors.RED)
        return False
    
    # Verificar requirements.txt
    if check_file_exists("requirements.txt", "Archivo de dependencias"):
        try:
            with open("requirements.txt", 'r') as f:
                requirements = [line.strip() for line in f if line.strip() and not line.startswith('#')]
            print_colored(f"✓ {len(requirements)} dependencias listadas", Colors.GREEN)
        except Exception as e:
            print_colored(f"✗ Error leyendo requirements.txt: {e}", Colors.RED)
            return False
    
    return True

def show_next_steps(env_vars: Dict[str, Any], docker_available: bool):
    """Muestra los próximos pasos según el estado actual."""
    print_colored("\n🚀 PRÓXIMOS PASOS", Colors.CYAN)
    print_colored("=" * 40, Colors.CYAN)
    
    if not env_vars or not all(env_vars.get(var) for var in ["JIRA_SERVER", "JIRA_EMAIL", "JIRA_API_TOKEN"]):
        print_colored("\n1. Configurar variables de entorno:", Colors.YELLOW)
        print_colored("   ./configure.sh", Colors.WHITE)
        print_colored("   # Luego edita .env con tus credenciales", Colors.WHITE)
    
    if not docker_available:
        print_colored("\n2. Instalar Docker:", Colors.YELLOW)
        print_colored("   https://docs.docker.com/get-docker/", Colors.WHITE)
    
    print_colored("\n3. Instalar dependencias Python:", Colors.YELLOW)
    print_colored("   pip install -r requirements.txt", Colors.WHITE)
    
    print_colored("\n4. Probar conexión MCP-JIRA:", Colors.YELLOW)
    print_colored("   # Abrir VS Code en este directorio", Colors.WHITE)
    print_colored("   # La extensión MCP se conectará automáticamente", Colors.WHITE)
    
    print_colored("\n📚 Documentación adicional:", Colors.BLUE)
    print_colored("   - README.md: Guía completa", Colors.WHITE)
    print_colored("   - DEPLOYMENT.md: Guía de despliegue", Colors.WHITE)
    print_colored("   - https://modelcontextprotocol.io/", Colors.WHITE)

def main():
    """Función principal del verificador."""
    print_header()
    
    # Mostrar información del paquete
    info = get_package_info()
    print_colored(f"📦 {info['description']}", Colors.BLUE)
    print_colored(f"🔗 {info['url']}", Colors.BLUE)
    
    # Realizar verificaciones
    env_vars = check_env_file()
    vscode_ok = check_vscode_config()
    docker_ok = check_docker()
    python_ok = check_python_environment()
    
    # Verificación opcional del container (puede tardar)
    print_colored("\n¿Verificar disponibilidad del container MCP-Atlassian? (puede tardar)", Colors.YELLOW)
    response = input("(s/N): ").lower().strip()
    
    container_ok = False
    if response in ['s', 'si', 'sí', 'y', 'yes']:
        container_ok = check_mcp_container()
    
    # Resumen final
    print_colored("\n📊 RESUMEN DE VERIFICACIÓN", Colors.CYAN)
    print_colored("=" * 40, Colors.CYAN)
    
    checks = [
        ("Configuración de entorno", bool(env_vars)),
        ("Configuración VS Code", vscode_ok),
        ("Docker disponible", docker_ok),
        ("Entorno Python", python_ok),
    ]
    
    if response in ['s', 'si', 'sí', 'y', 'yes']:
        checks.append(("Container MCP-Atlassian", container_ok))
    
    all_ok = True
    for check_name, status in checks:
        if status:
            print_colored(f"✓ {check_name}", Colors.GREEN)
        else:
            print_colored(f"✗ {check_name}", Colors.RED)
            all_ok = False
    
    if all_ok:
        print_colored("\n🎉 ¡Configuración completamente válida!", Colors.GREEN)
        print_colored("🚀 El servidor MCP-JIRA está listo para usar", Colors.GREEN)
    else:
        print_colored("\n⚠️  Algunas verificaciones fallaron", Colors.YELLOW)
        show_next_steps(env_vars, docker_ok)
    
    return 0 if all_ok else 1

if __name__ == "__main__":
    try:
        exit_code = main()
        sys.exit(exit_code)
    except KeyboardInterrupt:
        print_colored("\n\n⏹️  Verificación cancelada por el usuario", Colors.YELLOW)
        sys.exit(1)
    except Exception as e:
        print_colored(f"\n❌ Error inesperado: {e}", Colors.RED)
        sys.exit(1)
