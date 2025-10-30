#!/bin/bash
# Script to extract images from Manual_Usuario_Intencion_Siembra_v2.docx
# Images are extracted from the DOCX (which is a ZIP archive) and copied to docs/images/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DOCX_FILE="$REPO_ROOT/Manual_Usuario_Intencion_Siembra_v2.docx"
OUTPUT_DIR="$REPO_ROOT/docs/images"

echo "Extracting images from v2 DOCX..."

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Create temporary directory for extraction
tmp=$(mktemp -d)
trap "rm -rf $tmp" EXIT

# Unzip the DOCX file
echo "Unzipping DOCX to temporary directory..."
unzip -q "$DOCX_FILE" -d "$tmp"

# Check if word/media directory exists
if [ -d "$tmp/word/media" ]; then
    echo "Copying images from word/media/ to docs/images/..."
    # Copy all files from word/media to docs/images (don't overwrite existing)
    cp -n "$tmp"/word/media/* "$OUTPUT_DIR/" 2>/dev/null || true
    echo "Images extracted to docs/images/"
    ls -lh "$OUTPUT_DIR"
else
    echo "Warning: No word/media directory found in DOCX file"
fi

echo "Done!"
