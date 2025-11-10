# 🌱 Sistema de Intención de Siembra

Sistema completo de gestión de intenciones de siembra agrícola con aplicación web y móvil.

## 📋 Descripción del Proyecto

Este sistema permite a productores agrícolas gestionar sus intenciones de siembra, incluyendo:
- Registro y aprobación de boletas de siembra
- Notificaciones de cosecha
- Muestreo de fruta con fotografías
- Registro de resiembras
- Dashboard con estadísticas excluyendo variedades polinizadoras

## ✨ Características Implementadas

### Aplicación Móvil

- ✅ **Alarma de Próxima Cosecha**: Notificación una semana antes de la fecha esperada de cosecha según el ciclo promedio configurado por variedad. Permite confirmar o asignar nueva fecha.

- ✅ **Muestreo de Fruta con Fotos**: Boleta de muestreo que incluye:
  - Finca, lote, válvula
  - Variedad
  - Observaciones
  - Lecturas de brix (múltiples)
  - Fotografías (múltiples)

- ✅ **Boleta de Resiembra**: Permite al productor indicar:
  - Cantidad de semillas adicionales utilizadas
  - Razón de la resiembra
  - Área afectada
  - Observaciones

### Aplicación Web

- ✅ **Aprobación de Siembra**: "Visto Bueno" con:
  - Nombre del aprobador
  - Opción de subir fotos del avance
  - Observaciones
  - Registro de fecha de aprobación

- ✅ **Rectificación de Área por Boleta**: 
  - Actualizar área plantada
  - Mantener registro del área original
  - Historial de cambios

- ✅ **Dashboard con Exclusión de Polinizadores**:
  - Las boletas con variedades marcadas como "Es Polinizador" **NO** suman en los totales de área
  - Sección separada mostrando variedades polinizadoras
  - Desglose por variedad
  - Estadísticas por estado de boletas

## 🏗️ Arquitectura del Sistema

```
intencion_siembra/
├── backend/          # API REST (Node.js/Express/MongoDB)
├── web/             # Aplicación Web (React/Vite)
├── mobile/          # Aplicación Móvil (Flutter)
└── docs/            # Documentación
```

### Stack Tecnológico

**Backend:**
- Node.js + Express
- MongoDB + Mongoose
- Multer (manejo de archivos)
- node-cron (notificaciones programadas)

**Web:**
- React 19
- Vite
- Axios
- React Router

**Mobile:**
- Flutter 3.0+
- Provider (state management)
- HTTP client
- Flutter Local Notifications
- Image Picker

## 🚀 Inicio Rápido

### Prerrequisitos

- Node.js 16+
- MongoDB 4.4+
- Flutter 3.0+ (para mobile)
- Git

### 1. Clonar el Repositorio

```bash
git clone https://github.com/adriaschad/intencion_siembra.git
cd intencion_siembra
```

### 2. Configurar y Ejecutar Backend

```bash
cd backend
npm install
cp .env.example .env
# Editar .env con tus configuraciones
npm run dev
```

El backend estará disponible en `http://localhost:5000`

Ver [backend/README.md](backend/README.md) para más detalles.

### 3. Configurar y Ejecutar Web

```bash
cd web
npm install
cp .env.example .env
# Editar .env si es necesario
npm run dev
```

La aplicación web estará disponible en `http://localhost:3000`

Ver [web/README.md](web/README.md) para más detalles.

### 4. Configurar y Ejecutar Mobile

```bash
cd mobile
flutter pub get
# Editar lib/services/api_service.dart con la URL de tu API
flutter run
```

Ver [mobile/README.md](mobile/README.md) para más detalles.

## 📚 Documentación Detallada

- [Backend API](backend/README.md) - Endpoints, modelos, y configuración
- [Web Application](web/README.md) - Interfaz web y funcionalidades
- [Mobile App](mobile/README.md) - Aplicación móvil y configuración

## 💰 Estimación de Tiempo y Costo

### Tiempo Estimado de Desarrollo

| Componente | Horas |
|-----------|-------|
| Backend API | 40-50 |
| Aplicación Web | 35-45 |
| Aplicación Móvil | 45-55 |
| Testing & QA | 20-25 |
| Documentación | 10-15 |
| **Total** | **150-190 horas** |

**Tiempo de Calendario:**
- Con 1 desarrollador full-time: 4-5 semanas
- Con 2 desarrolladores: 2-3 semanas

### Estimación de Costos

Basado en tarifa de desarrollador senior ($50-80/hora):

- **Rango Bajo**: 150 horas × $50 = **$7,500 USD**
- **Rango Alto**: 190 horas × $80 = **$15,200 USD**
- **Promedio**: **~$11,000 USD**

**Costos Adicionales Mensuales:**
- Infraestructura cloud: $50-200/mes
- Almacenamiento de fotos: $20-100/mes
- Servicio de notificaciones push: $0-50/mes
- **Total estimado**: $70-350/mes

### Desglose Detallado

**Backend (40-50 horas):**
- Modelos y esquemas de base de datos: 8-10h
- Endpoints CRUD: 12-15h
- Sistema de notificaciones: 8-10h
- Manejo de archivos/fotos: 6-8h
- Testing y depuración: 6-7h

**Web (35-45 horas):**
- Configuración y estructura: 5-7h
- Dashboard con lógica de polinizadores: 10-12h
- Aprobación de boletas con fotos: 8-10h
- Rectificación de áreas: 4-5h
- Gestión de variedades: 6-8h
- Testing y refinamiento: 2-3h

**Mobile (45-55 horas):**
- Configuración y estructura: 6-8h
- Sistema de notificaciones: 12-15h
- Formulario de muestreo con fotos: 12-14h
- Formulario de resiembra: 8-10h
- Integración con API: 5-6h
- Testing en dispositivos: 2-2h

## 🔧 Configuración de Producción

### Backend

1. Configurar variables de entorno
2. Configurar MongoDB Atlas o servidor MongoDB
3. Configurar almacenamiento de archivos (AWS S3, Google Cloud Storage)
4. Configurar dominio y SSL
5. Deploy en Heroku, DigitalOcean, AWS, etc.

### Web

1. Configurar URL de producción de la API
2. Build: `npm run build`
3. Deploy en Netlify, Vercel, AWS S3+CloudFront, etc.

### Mobile

1. Configurar URL de producción de la API
2. Configurar certificados y signing
3. Build y publicar en Google Play Store
4. Build y publicar en Apple App Store

## 📱 Capturas de Pantalla

(Por favor ver las aplicaciones en ejecución para visualización completa)

## 🤝 Contribución

Este es un proyecto privado. Para contribuir, contactar al propietario del repositorio.

## 📄 Licencia

ISC

## 👥 Contacto

Para preguntas o soporte, contactar a: adriaschad@gmail.com

## 🔄 Actualizaciones Futuras Sugeridas

1. **Modo Offline**: Sincronización cuando haya conexión
2. **Reportes**: Exportar datos a PDF/Excel
3. **Gráficas Avanzadas**: Análisis de tendencias
4. **Geolocalización**: Ubicación GPS de lotes
5. **Códigos QR**: Identificación rápida de lotes
6. **Notificaciones Push**: Desde el servidor
7. **Multi-idioma**: Soporte para más idiomas
8. **Autenticación**: Sistema de usuarios y roles
9. **Auditoría**: Registro completo de cambios
10. **Integración con IoT**: Sensores de campo