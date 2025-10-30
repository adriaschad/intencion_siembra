#!/bin/bash
# Script to extract images from Manual_Usuario_Intencion_Siembra_v2.docx to docs/images/

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

DOCX_FILE="Manual_Usuario_Intencion_Siembra_v2.docx"
TEMP_DIR="/tmp/docx-extract-$$"
TARGET_DIR="docs/images"

echo -e "${YELLOW}Extrayendo imágenes del DOCX v2...${NC}"

# Verify DOCX exists
if [ ! -f "$DOCX_FILE" ]; then
    echo "Error: $DOCX_FILE no encontrado"
    exit 1
fi

# Create target directory
mkdir -p "$TARGET_DIR"

# Create temporary directory
mkdir -p "$TEMP_DIR"

# Extract DOCX (it's a ZIP file)
echo "Descomprimiendo $DOCX_FILE..."
unzip -q "$DOCX_FILE" -d "$TEMP_DIR"

# Copy images from word/media to docs/images
if [ -d "$TEMP_DIR/word/media" ]; then
    echo "Copiando imágenes a $TARGET_DIR/..."
    cp -n "$TEMP_DIR/word/media/"* "$TARGET_DIR/" 2>/dev/null || true
    IMAGE_COUNT=$(ls -1 "$TARGET_DIR" | wc -l)
    echo -e "${GREEN}✓ $IMAGE_COUNT imágenes copiadas a $TARGET_DIR/${NC}"
else
    echo -e "${YELLOW}Advertencia: No se encontró el directorio word/media en el DOCX${NC}"
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo -e "${GREEN}✓ Extracción completada${NC}"
echo "Las imágenes están disponibles en: $TARGET_DIR/"
ls -1 "$TARGET_DIR/"
