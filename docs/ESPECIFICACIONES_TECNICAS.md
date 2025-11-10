# 📘 Especificaciones Técnicas del Sistema

## Sistema de Intención de Siembra

---

## 🏗️ Arquitectura General

```
┌─────────────────┐         ┌─────────────────┐
│                 │         │                 │
│  Mobile App     │────────▶│   Backend API   │
│  (Flutter)      │  HTTPS  │   (Node.js)     │
│                 │         │                 │
└─────────────────┘         └────────┬────────┘
                                     │
┌─────────────────┐                  │
│                 │                  │
│  Web App        │──────────────────┘
│  (React)        │  HTTPS
│                 │
└─────────────────┘         ┌─────────────────┐
                            │                 │
                            │    MongoDB      │
                            │   (Database)    │
                            │                 │
                            └─────────────────┘
```

---

## 🔧 Backend API

### Stack Tecnológico

- **Runtime:** Node.js 16+
- **Framework:** Express.js 5.1
- **Base de Datos:** MongoDB 4.4+
- **ODM:** Mongoose 8.19
- **Autenticación:** JWT (para implementación futura)
- **Upload de Archivos:** Multer 2.0
- **Tareas Programadas:** node-cron 4.2
- **CORS:** cors 2.8

### Estructura de Directorios

```
backend/
├── src/
│   ├── config/
│   │   └── database.js          # Configuración de MongoDB
│   ├── models/
│   │   ├── Variety.js           # Modelo de Variedad
│   │   ├── PlantingForm.js      # Modelo de Boleta de Siembra
│   │   ├── SamplingForm.js      # Modelo de Muestreo
│   │   └── ReplantingForm.js    # Modelo de Resiembra
│   ├── controllers/
│   │   ├── varietyController.js
│   │   ├── plantingFormController.js
│   │   ├── samplingFormController.js
│   │   └── replantingFormController.js
│   ├── routes/
│   │   ├── varietyRoutes.js
│   │   ├── plantingFormRoutes.js
│   │   ├── samplingFormRoutes.js
│   │   └── replantingFormRoutes.js
│   ├── middleware/
│   │   └── upload.js            # Configuración de Multer
│   ├── services/
│   │   └── notificationService.js # Servicio de notificaciones
│   └── server.js                 # Punto de entrada
├── uploads/                      # Directorio de archivos subidos
├── .env.example                  # Template de variables de entorno
├── package.json
└── README.md
```

### Modelos de Datos

#### Variety (Variedad)
```javascript
{
  name: String (unique),
  averageCycleDays: Number,
  isPollinizer: Boolean,
  description: String,
  active: Boolean,
  timestamps: true
}
```

#### PlantingForm (Boleta de Siembra)
```javascript
{
  farmName: String,
  lotNumber: String,
  valveNumber: String,
  variety: ObjectId (ref: Variety),
  area: Number,
  originalArea: Number,
  plantingDate: Date,
  expectedHarvestDate: Date (auto-calculado),
  confirmedHarvestDate: Date,
  status: Enum [pending, approved, rejected, harvested],
  approvedBy: String,
  approvalDate: Date,
  approvalPhotos: [String],
  observations: String,
  producerId: String,
  notificationSent: Boolean,
  notificationDate: Date,
  timestamps: true
}
```

#### SamplingForm (Muestreo)
```javascript
{
  plantingForm: ObjectId (ref: PlantingForm),
  farmName: String,
  lotNumber: String,
  valveNumber: String,
  variety: ObjectId (ref: Variety),
  samplingDate: Date,
  brixReadings: [{
    value: Number,
    location: String
  }],
  averageBrix: Number (auto-calculado),
  observations: String,
  photos: [String],
  producerId: String,
  timestamps: true
}
```

#### ReplantingForm (Resiembra)
```javascript
{
  plantingForm: ObjectId (ref: PlantingForm),
  farmName: String,
  lotNumber: String,
  variety: ObjectId (ref: Variety),
  replantingDate: Date,
  additionalSeedsUsed: Number,
  reason: String,
  affectedArea: Number,
  observations: String,
  producerId: String,
  timestamps: true
}
```

### API Endpoints

#### Varieties
- `GET /api/varieties` - Listar todas las variedades activas
- `GET /api/varieties/:id` - Obtener variedad por ID
- `POST /api/varieties` - Crear nueva variedad
- `PUT /api/varieties/:id` - Actualizar variedad
- `DELETE /api/varieties/:id` - Eliminar variedad (soft delete)

#### Planting Forms
- `GET /api/planting-forms` - Listar boletas (con filtros)
- `GET /api/planting-forms/dashboard` - Estadísticas del dashboard
- `GET /api/planting-forms/:id` - Obtener boleta por ID
- `POST /api/planting-forms` - Crear boleta
- `PUT /api/planting-forms/:id` - Actualizar boleta
- `PUT /api/planting-forms/:id/approve` - Aprobar boleta (con fotos)
- `PUT /api/planting-forms/:id/rectify-area` - Rectificar área
- `PUT /api/planting-forms/:id/confirm-harvest` - Confirmar fecha de cosecha

#### Sampling Forms
- `GET /api/sampling-forms` - Listar muestreos
- `GET /api/sampling-forms/:id` - Obtener muestreo por ID
- `POST /api/sampling-forms` - Crear muestreo (con fotos)
- `PUT /api/sampling-forms/:id` - Actualizar muestreo
- `DELETE /api/sampling-forms/:id` - Eliminar muestreo

#### Replanting Forms
- `GET /api/replanting-forms` - Listar resiembras
- `GET /api/replanting-forms/:id` - Obtener resiembra por ID
- `POST /api/replanting-forms` - Crear resiembra
- `PUT /api/replanting-forms/:id` - Actualizar resiembra
- `DELETE /api/replanting-forms/:id` - Eliminar resiembra

#### Notifications
- `POST /api/notifications/check-harvests` - Trigger manual de verificación

### Sistema de Notificaciones

**Cron Job:** Ejecuta diariamente a las 8:00 AM

**Lógica:**
1. Busca boletas con `expectedHarvestDate` entre hoy y 7 días adelante
2. Filtra boletas no notificadas (`notificationSent: false`)
3. Calcula días restantes hasta cosecha
4. Envía notificación a través de handlers registrados
5. Marca boleta como notificada

### Seguridad

- **Validación de entrada:** En todos los endpoints
- **Límites de tamaño:** 5MB por archivo
- **Tipos de archivo:** Solo imágenes (JPEG, PNG, GIF)
- **CORS:** Configurado para orígenes permitidos
- **Variables de entorno:** Para información sensible
- **Future:** Autenticación JWT, rate limiting, HTTPS obligatorio

---

## 🌐 Aplicación Web

### Stack Tecnológico

- **Framework:** React 19.2
- **Build Tool:** Vite 7.2
- **Routing:** React Router DOM 7.9
- **HTTP Client:** Axios 1.13
- **Estilos:** CSS puro (sin framework adicional)

### Estructura de Directorios

```
web/
├── src/
│   ├── components/        # Componentes reutilizables (futuro)
│   ├── pages/
│   │   ├── Dashboard.jsx       # Dashboard con estadísticas
│   │   ├── PlantingForms.jsx   # Gestión de boletas
│   │   └── Varieties.jsx       # CRUD de variedades
│   ├── services/
│   │   ├── api.js             # Configuración de Axios
│   │   └── index.js           # Servicios de API
│   ├── utils/            # Utilidades (futuro)
│   ├── App.jsx           # Componente principal
│   ├── App.css           # Estilos globales
│   └── main.jsx          # Punto de entrada
├── public/               # Archivos estáticos
├── index.html
├── vite.config.js
├── .env.example
└── package.json
```

### Características Principales

#### Dashboard
- **Estadísticas generales:**
  - Total de boletas
  - Boletas por estado (pendiente, aprobado, rechazado)
  - Área total (excluyendo polinizadores)
  - Área total con polinizadores
  
- **Desglose por variedad:**
  - Área plantada por variedad
  - Cantidad de boletas
  - Identificación de polinizadores
  
- **Exclusión de polinizadores:**
  - Variedades con `isPollinizer: true` NO se suman en total
  - Sección separada mostrando polinizadores

#### Gestión de Boletas
- **Listado:** Todas las boletas con filtros
- **Aprobación:**
  - Modal con formulario
  - Nombre del aprobador
  - Observaciones
  - Upload de múltiples fotos
  - Actualización de estado a "approved"
  
- **Rectificación de área:**
  - Modal para actualizar área
  - Mantiene área original
  - Historial visible

#### Gestión de Variedades
- **CRUD completo:**
  - Crear, leer, actualizar, eliminar
  - Nombre de variedad
  - Ciclo promedio en días
  - Checkbox "Es Polinizador"
  - Descripción opcional

### Diseño UI/UX

**Tema:**
- Color primario: Verde oscuro (#2C5F2D)
- Color secundario: Verde claro (#97BC62)
- Tema agrícola

**Componentes:**
- Cards para información
- Tablas responsivas
- Modales para acciones
- Badges de estado con colores
- Formularios validados
- Botones con estados (loading, disabled)

---

## 📱 Aplicación Móvil

### Stack Tecnológico

- **Framework:** Flutter 3.0+
- **Lenguaje:** Dart
- **State Management:** Provider 6.1
- **HTTP Client:** http 1.1
- **Local Storage:** shared_preferences 2.2
- **Imágenes:** image_picker 1.0
- **Notificaciones:** flutter_local_notifications 17.0
- **Fechas:** intl 0.19

### Estructura de Directorios

```
mobile/
├── lib/
│   ├── models/
│   │   ├── variety.dart
│   │   ├── planting_form.dart
│   │   ├── sampling_form.dart
│   │   └── replanting_form.dart
│   ├── screens/
│   │   ├── home_screen.dart          # Pantalla principal
│   │   ├── sampling_form_screen.dart # Formulario de muestreo
│   │   ├── replanting_form_screen.dart # Formulario de resiembra
│   │   └── notifications_screen.dart  # Historial de notificaciones
│   ├── services/
│   │   ├── api_service.dart          # Cliente HTTP
│   │   └── notification_service.dart # Notificaciones locales
│   ├── widgets/          # Widgets reutilizables (futuro)
│   ├── utils/            # Utilidades (futuro)
│   └── main.dart         # Punto de entrada
├── android/              # Configuración Android
├── ios/                  # Configuración iOS
├── pubspec.yaml
└── README.md
```

### Pantallas Principales

#### Home Screen
- **Listado de boletas:**
  - Cards con información resumida
  - Badges de estado
  - Fecha de siembra y cosecha esperada
  - Días restantes hasta cosecha

- **Alertas de cosecha:**
  - Destacado especial para boletas con cosecha < 7 días
  - Botón para confirmar fecha
  - Selector de fecha modal
  - Actualización en tiempo real

- **Floating Action Buttons:**
  - Botón para muestreo (verde claro)
  - Botón para resiembra (verde oscuro)

#### Sampling Form Screen
- **Selector de boleta:** Dropdown con boletas del productor
- **Lecturas de brix:**
  - Lista dinámica
  - Valor numérico + ubicación
  - Agregar/eliminar lecturas
  - Cálculo automático de promedio

- **Fotos:**
  - Botón para tomar/seleccionar fotos
  - Preview de fotos seleccionadas
  - Eliminar fotos individuales
  - Upload múltiple

- **Observaciones:** Campo de texto libre

#### Replanting Form Screen
- **Selector de boleta:** Dropdown
- **Campos:**
  - Cantidad de semillas (número, requerido)
  - Razón de resiembra (texto)
  - Área afectada (número decimal, opcional)
  - Observaciones (texto)

#### Notifications Screen
- **Listado de notificaciones:**
  - Cards cronológicas
  - Título y mensaje
  - Timestamp
  - Icono de notificación
  - Botón para limpiar historial

### Sistema de Notificaciones

**Flutter Local Notifications:**
- Canal: "harvest_notifications"
- Prioridad: Alta
- Icono: Logo de la app
- Sound: Sonido predeterminado
- Badge: Actualizado automáticamente

**Almacenamiento:**
- SharedPreferences para historial
- Límite de 50 notificaciones
- JSON serialization

**Permisos:**
- Android: POST_NOTIFICATIONS
- iOS: Alert, Badge, Sound

### API Integration

**Configuración:**
```dart
// Android Emulator
static const String baseUrl = 'http://10.0.2.2:5000/api';

// iOS Simulator
static const String baseUrl = 'http://localhost:5000/api';

// Dispositivo Real
static const String baseUrl = 'http://192.168.1.X:5000/api';
```

**Endpoints utilizados:**
- GET /api/varieties
- GET /api/planting-forms (con filtro producerId)
- PUT /api/planting-forms/:id/confirm-harvest
- POST /api/sampling-forms (multipart/form-data)
- POST /api/replanting-forms

---

## 🔐 Seguridad

### Backend
- ✅ Validación de datos de entrada
- ✅ Límites de tamaño de archivo
- ✅ Validación de tipo de archivo
- ✅ CORS configurado
- ⏳ Autenticación JWT (futuro)
- ⏳ Rate limiting (futuro)
- ⏳ HTTPS obligatorio en producción

### Web
- ✅ Validación de formularios
- ✅ Sanitización de entradas
- ✅ HTTPS en producción
- ⏳ Autenticación de usuarios
- ⏳ Roles y permisos

### Mobile
- ✅ Validación de formularios
- ✅ Permisos de cámara/galería
- ✅ Almacenamiento local seguro
- ⏳ Autenticación biométrica
- ⏳ Certificado pinning

---

## 📊 Rendimiento

### Backend
- **Respuesta promedio:** < 200ms
- **Carga de archivos:** Hasta 5MB por foto
- **Concurrencia:** 100+ usuarios simultáneos
- **Base de datos:** Índices en campos de búsqueda frecuente

### Web
- **First Contentful Paint:** < 1.5s
- **Time to Interactive:** < 3s
- **Bundle size:** ~500KB gzipped
- **Lazy loading:** Para imágenes y rutas

### Mobile
- **Tamaño de APK:** ~20MB
- **Tamaño de IPA:** ~25MB
- **Inicio en frío:** < 3s
- **Consumo de batería:** Optimizado para notificaciones

---

## 🔄 Escalabilidad

### Horizontal
- Backend stateless, puede escalar horizontalmente
- Load balancer para distribuir tráfico
- Múltiples instancias de API

### Vertical
- Incremento de recursos del servidor
- Optimización de queries de base de datos
- Caching con Redis

### Base de Datos
- Sharding por producerId
- Réplicas de lectura
- Índices compuestos para queries frecuentes

---

## 🧪 Testing

### Backend
- **Unit tests:** Para lógica de negocio
- **Integration tests:** Para endpoints
- **Testing framework:** Jest o Mocha
- **Coverage objetivo:** > 70%

### Web
- **Unit tests:** Para componentes
- **Integration tests:** Para flujos
- **E2E tests:** Con Playwright/Cypress
- **Testing framework:** Vitest

### Mobile
- **Unit tests:** Para modelos y servicios
- **Widget tests:** Para UI
- **Integration tests:** Para flujos
- **Testing framework:** Flutter Test

---

## 📝 Logs y Monitoreo

### Backend
- **Winston:** Para logs estructurados
- **Morgan:** Para logs de HTTP
- **Sentry:** Para error tracking (producción)
- **New Relic/DataDog:** Para APM

### Web
- **Console logs:** En desarrollo
- **Sentry:** Para error tracking
- **Google Analytics:** Para analytics

### Mobile
- **Firebase Crashlytics:** Para crashes
- **Firebase Analytics:** Para analytics
- **Custom logging:** Para debugging

---

## 🚀 Deployment

### Backend
**Opciones:**
- Heroku (fácil)
- DigitalOcean App Platform
- AWS Elastic Beanstalk
- Docker + VPS

**Proceso:**
1. Build de producción
2. Variables de entorno
3. Configuración de DB
4. SSL/TLS
5. Deploy

### Web
**Opciones:**
- Netlify (recomendado)
- Vercel
- AWS S3 + CloudFront
- GitHub Pages (sin backend)

**Proceso:**
1. `npm run build`
2. Upload de dist/
3. Configuración de dominio
4. Variables de entorno

### Mobile
**Android:**
- Google Play Console
- Release signing
- Bundle (.aab)
- Review process

**iOS:**
- App Store Connect
- Certificados de Apple
- Archive (.ipa)
- TestFlight
- Review process

---

## 📚 Dependencias Principales

### Backend
```json
{
  "express": "^5.1.0",
  "mongoose": "^8.19.3",
  "multer": "^2.0.2",
  "node-cron": "^4.2.1",
  "cors": "^2.8.5",
  "dotenv": "^17.2.3"
}
```

### Web
```json
{
  "react": "^19.2.0",
  "react-router-dom": "^7.9.5",
  "axios": "^1.13.2",
  "vite": "^7.2.2"
}
```

### Mobile
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  http: ^1.1.2
  image_picker: ^1.0.7
  flutter_local_notifications: ^17.0.0
  shared_preferences: ^2.2.2
  intl: ^0.19.0
```

---

## 🔮 Mejoras Futuras

1. **Autenticación y Autorización**
   - Sistema de usuarios
   - Roles (productor, supervisor, admin)
   - OAuth2 / JWT

2. **Modo Offline**
   - Sincronización automática
   - IndexedDB (web) / SQLite (mobile)
   - Queue de operaciones

3. **Notificaciones Push**
   - Firebase Cloud Messaging
   - Notificaciones del servidor
   - Personalización

4. **Reportes Avanzados**
   - Export a PDF/Excel
   - Gráficas interactivas
   - Análisis predictivo

5. **Geolocalización**
   - GPS para ubicación de lotes
   - Mapas interactivos
   - Rutas de trabajo

6. **IoT Integration**
   - Sensores de humedad/temperatura
   - Estaciones meteorológicas
   - Automatización

---

**Documento creado:** Noviembre 2025  
**Versión:** 1.0  
**Autor:** Sistema de Intención de Siembra
