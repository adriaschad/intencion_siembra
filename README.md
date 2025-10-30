# intencion_siembra

Sistema de Intención de Siembra - Plataforma integral para gestionar y visualizar datos relacionados con las intenciones de siembra de productores agrícolas.

## Documentación

- **[Manual de Usuario v3](docs/Manual_Usuario_Intencion_Siembra_v3.md)** - Guía completa de usuario en español
- **[Manual de Usuario v3 (DOCX)](docs/Manual_Usuario_Intencion_Siembra_v3.docx)** - Versión Microsoft Word (generada automáticamente)
- **[Manual de Usuario v2 (DOCX)](Manual_Usuario_Intencion_Siembra_v2.docx)** - Versión anterior

## Características principales

- Dashboard interactivo con múltiples visualizaciones
- Filtros avanzados (fecha, región, cultivo, productor)
- Indicadores KPI en tiempo real
- Exportación de datos (Excel, CSV, PDF, JSON)
- Aplicación móvil Android (APK)
- Gráficos interactivos (barras, circular, líneas, mapa de calor)

## Desarrollo

### Generación automática de DOCX

El archivo `docs/Manual_Usuario_Intencion_Siembra_v3.docx` se genera automáticamente desde el Markdown mediante GitHub Actions cuando:
- Se modifica el archivo Markdown del manual
- Se actualizan las imágenes en `docs/images/`
- Se ejecuta manualmente el workflow

Para extraer imágenes del DOCX v2:
```bash
./scripts/extract-docx-images.sh
```