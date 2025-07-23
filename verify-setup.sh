#!/bin/bash

# verify-setup.sh
# Script para verificar la configuración del servidor MCP-JIRA
# Este script valida que todos los componentes necesarios estén correctamente configurados

set -e

echo "🔍 Verificando configuración del servidor MCP-JIRA..."
echo "=============================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para mostrar estado
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

# Variables
ERRORS=0

# 1. Verificar estructura de directorios
echo -e "\n${YELLOW}1. Verificando estructura de directorios...${NC}"
if [ -d "mcp_jira" ]; then
    print_status 0 "Directorio mcp_jira existe"
else
    print_status 1 "Directorio mcp_jira no encontrado"
    ((ERRORS++))
fi

if [ -d "templates" ]; then
    print_status 0 "Directorio templates existe"
else
    print_status 1 "Directorio templates no encontrado"
    ((ERRORS++))
fi

# 2. Verificar archivos principales
echo -e "\n${YELLOW}2. Verificando archivos principales...${NC}"
files=(
    "mcp_jira/__init__.py"
    "mcp_jira/__main__.py"
    "requirements.txt"
    "README.md"
    "LICENSE"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        print_status 0 "Archivo $file existe"
    else
        print_status 1 "Archivo $file no encontrado"
        ((ERRORS++))
    fi
done

# 3. Verificar templates
echo -e "\n${YELLOW}3. Verificando templates...${NC}"
templates=(
    "templates/.env.template"
    "templates/mcp.json.template"
    "templates/gitignore.template"
)

for template in "${templates[@]}"; do
    if [ -f "$template" ]; then
        print_status 0 "Template $template existe"
    else
        print_status 1 "Template $template no encontrado"
        ((ERRORS++))
    fi
done

# 4. Verificar scripts de configuración
echo -e "\n${YELLOW}4. Verificando scripts de configuración...${NC}"
scripts=(
    "setup-mcp-jira.sh"
    "simple-setup.sh"
    "configure.sh"
)

for script in "${scripts[@]}"; do
    if [ -f "$script" ]; then
        if [ -x "$script" ]; then
            print_status 0 "Script $script existe y es ejecutable"
        else
            print_status 1 "Script $script existe pero no es ejecutable"
            echo "  → Ejecuta: chmod +x $script"
            ((ERRORS++))
        fi
    else
        print_status 1 "Script $script no encontrado"
        ((ERRORS++))
    fi
done

# 5. Verificar Python y dependencias
echo -e "\n${YELLOW}5. Verificando Python y dependencias...${NC}"
if command -v python3 &> /dev/null; then
    python_version=$(python3 --version 2>&1)
    print_status 0 "Python3 disponible: $python_version"
else
    print_status 1 "Python3 no encontrado"
    ((ERRORS++))
fi

if command -v pip3 &> /dev/null; then
    print_status 0 "pip3 disponible"
else
    print_status 1 "pip3 no encontrado"
    ((ERRORS++))
fi

# 6. Validar sintaxis de archivos Python
echo -e "\n${YELLOW}6. Validando sintaxis de archivos Python...${NC}"
for pyfile in mcp_jira/*.py; do
    if [ -f "$pyfile" ]; then
        if python3 -m py_compile "$pyfile" 2>/dev/null; then
            print_status 0 "Sintaxis válida: $pyfile"
        else
            print_status 1 "Error de sintaxis en: $pyfile"
            ((ERRORS++))
        fi
    fi
done

# 7. Verificar formato de requirements.txt
echo -e "\n${YELLOW}7. Verificando requirements.txt...${NC}"
if [ -f "requirements.txt" ]; then
    if [ -s "requirements.txt" ]; then
        line_count=$(wc -l < requirements.txt)
        print_status 0 "requirements.txt contiene $line_count líneas"
        
        # Verificar que no haya líneas vacías o malformadas
        if grep -q "^$" requirements.txt; then
            print_status 1 "requirements.txt contiene líneas vacías"
            ((ERRORS++))
        fi
    else
        print_status 1 "requirements.txt está vacío"
        ((ERRORS++))
    fi
fi

# 8. Verificar configuración Git (si es un repositorio)
echo -e "\n${YELLOW}8. Verificando configuración Git...${NC}"
if [ -d ".git" ]; then
    print_status 0 "Repositorio Git inicializado"
    
    if [ -f ".gitignore" ]; then
        print_status 0 "Archivo .gitignore existe"
    else
        print_status 1 "Archivo .gitignore no encontrado"
        echo "  → Considera crear uno usando: cp templates/gitignore.template .gitignore"
    fi
else
    print_status 1 "No es un repositorio Git"
    echo "  → Ejecuta: git init"
fi

# 9. Verificar estructura del workflow de GitHub Actions
echo -e "\n${YELLOW}9. Verificando GitHub Actions...${NC}"
if [ -d ".github/workflows" ]; then
    print_status 0 "Directorio .github/workflows existe"
    
    workflow_files=(.github/workflows/*.yml .github/workflows/*.yaml)
    workflow_count=0
    for workflow in "${workflow_files[@]}"; do
        if [ -f "$workflow" ]; then
            ((workflow_count++))
            print_status 0 "Workflow encontrado: $(basename "$workflow")"
        fi
    done
    
    if [ $workflow_count -eq 0 ]; then
        print_status 1 "No se encontraron archivos de workflow"
    fi
else
    print_status 1 "Directorio .github/workflows no encontrado"
fi

# Resumen final
echo -e "\n${YELLOW}=============================================="
echo "📊 RESUMEN DE VERIFICACIÓN"
echo "=============================================="

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ Configuración completamente válida${NC}"
    echo "🚀 El servidor MCP-JIRA está listo para usar"
    echo ""
    echo "Próximos pasos:"
    echo "1. Copia y configura los archivos de entorno:"
    echo "   cp templates/.env.template .env"
    echo "2. Ejecuta el script de configuración:"
    echo "   ./setup-mcp-jira.sh"
    echo "3. Prueba la conexión con JIRA"
    exit 0
else
    echo -e "${RED}❌ Se encontraron $ERRORS errores${NC}"
    echo "🔧 Revisa los errores arriba y ejecuta los scripts de configuración"
    echo ""
    echo "Para resolver errores comunes:"
    echo "1. Ejecuta: ./setup-mcp-jira.sh"
    echo "2. O usa la configuración simple: ./simple-setup.sh"
    exit 1
fi
