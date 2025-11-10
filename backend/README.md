# Backend API - Intención de Siembra

Backend API for the Agricultural Planting Intention Management System.

## Features

### Implemented Requirements

#### Mobile App Features
- ✅ **Harvest Alarm**: Automatic notifications one week before expected harvest date
- ✅ **Fruit Sampling Form**: Complete sampling form with photos, brix readings, and observations
- ✅ **Replanting Form**: Track additional seeds used for replanting

#### Web Application Features
- ✅ **Planting Approval**: Approve planting forms with "Visto Bueno" and photo uploads
- ✅ **Area Rectification**: Update planted area per form
- ✅ **Dashboard Statistics**: Area totals that exclude pollinator varieties

## Tech Stack

- **Node.js** - Runtime environment
- **Express** - Web framework
- **MongoDB** - Database
- **Mongoose** - ODM
- **Multer** - File upload handling
- **node-cron** - Task scheduling for notifications

## Installation

### Prerequisites

- Node.js (v14 or higher)
- MongoDB (v4.4 or higher)

### Setup

1. Install dependencies:
```bash
npm install
```

2. Create `.env` file from template:
```bash
cp .env.example .env
```

3. Configure environment variables in `.env`:
```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/intencion_siembra
JWT_SECRET=your_jwt_secret_key_change_in_production
NODE_ENV=development
UPLOAD_DIR=./uploads
```

4. Start MongoDB:
```bash
# Using MongoDB service
sudo service mongodb start

# Or using Docker
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

5. Start the server:
```bash
# Development mode with auto-reload
npm run dev

# Production mode
npm start
```

The server will start on `http://localhost:5000`

## API Endpoints

### Varieties

- `GET /api/varieties` - Get all active varieties
- `GET /api/varieties/:id` - Get variety by ID
- `POST /api/varieties` - Create new variety
- `PUT /api/varieties/:id` - Update variety
- `DELETE /api/varieties/:id` - Soft delete variety

**Example Variety:**
```json
{
  "name": "Hass",
  "averageCycleDays": 180,
  "isPollinizer": false,
  "description": "Aguacate Hass"
}
```

### Planting Forms

- `GET /api/planting-forms` - Get all planting forms (with optional filters)
  - Query params: `producerId`, `status`
- `GET /api/planting-forms/dashboard` - Get dashboard statistics
- `GET /api/planting-forms/:id` - Get planting form by ID
- `POST /api/planting-forms` - Create new planting form
- `PUT /api/planting-forms/:id` - Update planting form
- `PUT /api/planting-forms/:id/approve` - Approve planting form (with photos)
- `PUT /api/planting-forms/:id/rectify-area` - Rectify area
- `PUT /api/planting-forms/:id/confirm-harvest` - Confirm harvest date

**Example Planting Form:**
```json
{
  "farmName": "Finca El Paraíso",
  "lotNumber": "L-001",
  "valveNumber": "V-12",
  "variety": "507f1f77bcf86cd799439011",
  "area": 2.5,
  "plantingDate": "2025-01-15",
  "producerId": "producer123"
}
```

**Approve Form Example:**
```json
{
  "approvedBy": "Supervisor Juan Pérez",
  "approvalPhotos": ["photo1.jpg", "photo2.jpg"],
  "observations": "Siembra en buenas condiciones"
}
```

### Sampling Forms

- `GET /api/sampling-forms` - Get all sampling forms
  - Query params: `producerId`, `plantingFormId`
- `GET /api/sampling-forms/:id` - Get sampling form by ID
- `POST /api/sampling-forms` - Create new sampling form (with photos)
- `PUT /api/sampling-forms/:id` - Update sampling form
- `DELETE /api/sampling-forms/:id` - Delete sampling form

**Example Sampling Form:**
```json
{
  "plantingForm": "507f1f77bcf86cd799439011",
  "farmName": "Finca El Paraíso",
  "lotNumber": "L-001",
  "valveNumber": "V-12",
  "variety": "507f1f77bcf86cd799439012",
  "samplingDate": "2025-06-15",
  "brixReadings": [
    { "value": 14.5, "location": "Norte" },
    { "value": 15.2, "location": "Sur" },
    { "value": 14.8, "location": "Centro" }
  ],
  "observations": "Fruta en buen estado",
  "photos": ["sample1.jpg", "sample2.jpg"],
  "producerId": "producer123"
}
```

### Replanting Forms

- `GET /api/replanting-forms` - Get all replanting forms
  - Query params: `producerId`, `plantingFormId`
- `GET /api/replanting-forms/:id` - Get replanting form by ID
- `POST /api/replanting-forms` - Create new replanting form
- `PUT /api/replanting-forms/:id` - Update replanting form
- `DELETE /api/replanting-forms/:id` - Delete replanting form

**Example Replanting Form:**
```json
{
  "plantingForm": "507f1f77bcf86cd799439011",
  "farmName": "Finca El Paraíso",
  "lotNumber": "L-001",
  "variety": "507f1f77bcf86cd799439012",
  "replantingDate": "2025-03-10",
  "additionalSeedsUsed": 150,
  "reason": "Baja germinación en zona norte",
  "affectedArea": 0.5,
  "observations": "Replantado en zona afectada",
  "producerId": "producer123"
}
```

### Notifications

- `POST /api/notifications/check-harvests` - Manually trigger harvest notification check (for testing)

### Health Check

- `GET /api/health` - Health check endpoint

## File Uploads

Photo uploads are handled via `multipart/form-data`:

- Maximum file size: 5MB per file
- Allowed formats: JPEG, JPG, PNG, GIF
- Uploaded files are stored in the `uploads/` directory
- Files are accessible via: `http://localhost:5000/uploads/{filename}`

## Notification System

The system automatically checks for upcoming harvests daily at 8:00 AM and sends notifications one week before the expected harvest date.

### Notification Flow:

1. Cron job runs daily at 8:00 AM
2. Finds planting forms with expected harvest date within 7 days
3. Sends notification to producer
4. Marks form as notified to avoid duplicates
5. Producer can confirm or update the harvest date

### Testing Notifications:

Trigger manual notification check:
```bash
curl -X POST http://localhost:5000/api/notifications/check-harvests
```

## Dashboard Statistics

The dashboard endpoint (`GET /api/planting-forms/dashboard`) provides:

- Total number of forms
- Forms by status (pending, approved, rejected)
- Total planted area (excluding pollinizers)
- Total area including pollinizers
- Breakdown by variety
- List of pollinator varieties and their areas

**Example Dashboard Response:**
```json
{
  "totalForms": 45,
  "pendingForms": 12,
  "approvedForms": 30,
  "rejectedForms": 3,
  "totalArea": 125.5,
  "totalAreaWithPollinizers": 135.8,
  "varietyBreakdown": {
    "Hass": {
      "area": 80.5,
      "count": 25,
      "isPollinizer": false
    },
    "Fuerte": {
      "area": 45.0,
      "count": 15,
      "isPollinizer": false
    },
    "Zutano": {
      "area": 10.3,
      "count": 5,
      "isPollinizer": true
    }
  },
  "pollinizers": [
    {
      "variety": "Zutano",
      "area": 10.3
    }
  ]
}
```

## Project Structure

```
backend/
├── src/
│   ├── config/
│   │   └── database.js          # MongoDB connection
│   ├── controllers/
│   │   ├── varietyController.js
│   │   ├── plantingFormController.js
│   │   ├── samplingFormController.js
│   │   └── replantingFormController.js
│   ├── models/
│   │   ├── Variety.js
│   │   ├── PlantingForm.js
│   │   ├── SamplingForm.js
│   │   └── ReplantingForm.js
│   ├── routes/
│   │   ├── varietyRoutes.js
│   │   ├── plantingFormRoutes.js
│   │   ├── samplingFormRoutes.js
│   │   └── replantingFormRoutes.js
│   ├── middleware/
│   │   └── upload.js            # File upload configuration
│   ├── services/
│   │   └── notificationService.js # Notification and cron jobs
│   └── server.js                # Main application file
├── uploads/                      # Uploaded files directory
├── .env.example                 # Environment variables template
├── .gitignore
├── package.json
└── README.md
```

## Development

### Adding New Features

1. Create model in `src/models/`
2. Create controller in `src/controllers/`
3. Create routes in `src/routes/`
4. Register routes in `src/server.js`

### Testing

You can test the API using:

- **Postman**: Import the endpoints and test
- **cURL**: Command-line testing
- **REST Client VS Code Extension**: Create `.http` files

Example cURL commands:

```bash
# Create a variety
curl -X POST http://localhost:5000/api/varieties \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Hass",
    "averageCycleDays": 180,
    "isPollinizer": false
  }'

# Get all varieties
curl http://localhost:5000/api/varieties

# Create planting form
curl -X POST http://localhost:5000/api/planting-forms \
  -H "Content-Type: application/json" \
  -d '{
    "farmName": "Finca Test",
    "lotNumber": "L-001",
    "variety": "VARIETY_ID_HERE",
    "area": 2.5,
    "plantingDate": "2025-01-15",
    "producerId": "producer123"
  }'
```

## License

ISC
