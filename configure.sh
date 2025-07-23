#!/bin/bash

# configure.sh
# Script para configurar los archivos de entorno desde los templates
# Este script copia y personaliza los templates según el entorno local

set -e

echo "⚙️  Configurando entorno MCP-JIRA..."
echo "===================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar progreso
show_progress() {
    echo -e "${BLUE}→${NC} $1"
}

# Función para mostrar éxito
show_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Función para mostrar advertencia
show_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Función para mostrar error
show_error() {
    echo -e "${RED}✗${NC} $1"
}

# 1. Verificar que estamos en el directorio correcto
if [ ! -d "templates" ]; then
    show_error "Directorio 'templates' no encontrado."
    echo "Asegúrate de ejecutar este script desde el directorio raíz del proyecto."
    exit 1
fi

# 2. Configurar archivo .env
show_progress "Configurando archivo .env..."
if [ -f ".env" ]; then
    show_warning "El archivo .env ya existe. Se creará una copia de respaldo."
    cp .env .env.backup.$(date +%Y%m%d_%H%M%S)
fi

if [ -f "templates/.env.template" ]; then
    cp templates/.env.template .env
    show_success "Archivo .env creado desde template"
    
    # Generar valores por defecto
    echo "" >> .env
    echo "# Configuración generada automáticamente" >> .env
    echo "# $(date)" >> .env
    
    show_warning "📝 Recuerda configurar las siguientes variables en .env:"
    echo "   - JIRA_SERVER (URL de tu instancia JIRA)"
    echo "   - JIRA_EMAIL (tu email de JIRA)"
    echo "   - JIRA_API_TOKEN (token de API de JIRA)"
    echo "   - JIRA_PROJECTS_FILTER (opcional: proyectos a incluir)"
else
    show_error "Template .env.template no encontrado"
    exit 1
fi

# 3. Configurar directorio .vscode si no existe
show_progress "Configurando directorio .vscode..."
if [ ! -d ".vscode" ]; then
    mkdir -p .vscode
    show_success "Directorio .vscode creado"
fi

# 4. Configurar archivo mcp.json
show_progress "Configurando archivo mcp.json..."
if [ -f ".vscode/mcp.json" ]; then
    show_warning "El archivo .vscode/mcp.json ya existe. Se creará una copia de respaldo."
    cp .vscode/mcp.json .vscode/mcp.json.backup.$(date +%Y%m%d_%H%M%S)
fi

if [ -f "templates/mcp.json.template" ]; then
    cp templates/mcp.json.template .vscode/mcp.json
    show_success "Archivo .vscode/mcp.json creado desde template"
else
    show_error "Template mcp.json.template no encontrado"
    exit 1
fi

# 5. Configurar .gitignore si no existe
show_progress "Configurando .gitignore..."
if [ ! -f ".gitignore" ] && [ -f "templates/gitignore.template" ]; then
    cp templates/gitignore.template .gitignore
    show_success "Archivo .gitignore creado desde template"
elif [ -f ".gitignore" ]; then
    show_success "Archivo .gitignore ya existe"
else
    show_warning "Template gitignore.template no encontrado"
fi

# 6. Verificar estructura de módulo Python
show_progress "Verificando módulo Python..."
if [ ! -d "mcp_jira" ]; then
    show_error "Directorio mcp_jira no encontrado"
    exit 1
fi

if [ ! -f "mcp_jira/__init__.py" ]; then
    show_error "Archivo mcp_jira/__init__.py no encontrado"
    exit 1
fi

if [ ! -f "mcp_jira/__main__.py" ]; then
    show_error "Archivo mcp_jira/__main__.py no encontrado"
    exit 1
fi

show_success "Módulo Python verificado"

# 7. Verificar requirements.txt
show_progress "Verificando dependencias..."
if [ ! -f "requirements.txt" ]; then
    show_error "Archivo requirements.txt no encontrado"
    exit 1
fi

show_success "Archivo requirements.txt verificado"

# 8. Hacer scripts ejecutables
show_progress "Configurando permisos de scripts..."
for script in *.sh; do
    if [ -f "$script" ]; then
        chmod +x "$script"
        show_success "Script $script configurado como ejecutable"
    fi
done

# 9. Mostrar próximos pasos
echo ""
echo -e "${YELLOW}🎉 Configuración completada exitosamente!${NC}"
echo "========================================="
echo ""
echo "📋 Próximos pasos:"
echo "1. Edita el archivo .env con tus credenciales de JIRA:"
echo "   nano .env  # o usa tu editor preferido"
echo ""
echo "2. Verifica la configuración:"
echo "   ./verify-setup.sh"
echo ""
echo "3. Instala las dependencias Python:"
echo "   pip install -r requirements.txt"
echo ""
echo "4. Prueba la conexión con JIRA:"
echo "   python -m mcp_jira"
echo ""
echo "5. Configura VS Code con la extensión MCP:"
echo "   - Abre VS Code en este directorio"
echo "   - La configuración MCP se cargará automáticamente desde .vscode/mcp.json"
echo ""
echo -e "${GREEN}✨ ¡Tu entorno MCP-JIRA está listo!${NC}"
