# Documentación del Sistema de Intención de Siembra

Este directorio contiene la documentación del usuario para el sistema de Intención de Siembra.

## Archivos

### Manual de Usuario v3

- **`Manual_Usuario_Intencion_Siembra_v3.md`** - Manual en formato Markdown (fuente)
- **`Manual_Usuario_Intencion_Siembra_v3.docx`** - Manual en formato DOCX (generado automáticamente)

### Imágenes

El directorio `images/` contiene todas las capturas de pantalla utilizadas en el manual:

- `image1.jpeg` - Pantalla de inicio de sesión
- `image2.jpeg` - Dashboard sin datos
- `image3.jpeg` - Dashboard con datos
- `image4.jpeg` - Menú lateral
- `image5.jpeg` - Formulario de creación de boleta
- `image6.jpeg` - Validación de área
- `image7.jpeg` - Selector de fecha
- `image8.jpeg` - Listado de boletas
- `image9.jpeg` - Pantalla de edición

## Actualización del Manual

### Editar el manual

1. Edite el archivo `Manual_Usuario_Intencion_Siembra_v3.md`
2. Haga commit y push de los cambios
3. El archivo DOCX se generará automáticamente mediante GitHub Actions

### Agregar o actualizar imágenes

1. Coloque las nuevas imágenes en el directorio `images/`
2. Referencie las imágenes en el Markdown usando:
   ```markdown
   ![Descripción](images/nombre-imagen.jpeg){ width=300px }
   ```
3. Haga commit y push de los cambios
4. El DOCX se regenerará automáticamente con las nuevas imágenes

### Generar DOCX manualmente

Si desea generar el DOCX localmente:

```bash
cd docs
pandoc Manual_Usuario_Intencion_Siembra_v3.md \
  -o Manual_Usuario_Intencion_Siembra_v3.docx \
  --resource-path=.:images \
  --standalone
```

**Requisito:** pandoc instalado (`sudo apt-get install pandoc` en Ubuntu/Debian)

## Extracción de Imágenes

Las imágenes fueron extraídas del archivo `Manual_Usuario_Intencion_Siembra_v2.docx` usando el script:

```bash
../scripts/extract-docx-images.sh
```

Este script puede ejecutarse nuevamente si necesita re-extraer las imágenes.

## CI/CD

El workflow de GitHub Actions (`.github/workflows/manual-docx.yml`) automatiza:

1. Instalación de pandoc
2. Conversión de Markdown a DOCX
3. Commit automático del DOCX generado

**Triggers:**
- Cambios en `docs/Manual_Usuario_Intencion_Siembra_v3.md`
- Cambios en `docs/images/**`
- Cambios en `.github/workflows/manual-docx.yml`
- Ejecución manual (workflow_dispatch)

## Soporte

Para preguntas o problemas relacionados con la documentación, contacte al administrador del repositorio.
