# Web Application - Intención de Siembra

Web application for managing agricultural planting intentions.

## Features

### Implemented Requirements

- ✅ **Planting Approval (Visto Bueno)**: Approve planting forms with photo uploads
- ✅ **Area Rectification**: Update planted area per form with tracking of original values
- ✅ **Dashboard**: Statistics excluding pollinator varieties from area totals
- ✅ **Variety Management**: Configure varieties with pollinator flag and cycle days

## Tech Stack

- **React 19** - UI library
- **React Router** - Navigation
- **Vite** - Build tool
- **Axios** - HTTP client

## Installation

### Prerequisites

- Node.js (v16 or higher)
- Backend API running on port 5000

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
VITE_API_URL=http://localhost:5000/api
```

4. Start the development server:
```bash
npm run dev
```

The application will start on `http://localhost:3000`

## Available Scripts

- `npm run dev` - Start development server with hot reload
- `npm run build` - Build for production
- `npm run preview` - Preview production build

## Application Features

### Dashboard

- View total planting forms
- See forms by status (pending, approved, rejected)
- View total planted area (excluding pollinators)
- Breakdown by variety with pollinator identification
- Separate section showing pollinator varieties and their areas

### Planting Forms Management

- View all planting forms in a table
- **Approve forms** with "Visto Bueno":
  - Enter approver name
  - Add observations
  - Upload multiple photos of progress
- **Rectify planted area**:
  - Update area values
  - Track original vs. current area
  - View history of changes
- Filter by status and producer
- View planting and expected harvest dates

### Variety Management

- Create, edit, and delete varieties
- Configure average cycle days for harvest calculations
- Mark varieties as pollinators (excluded from area totals)
- Add descriptions

## User Interface

The web application features:

- Clean, responsive design
- Color-coded status badges
- Modal dialogs for approvals and rectifications
- Photo upload support
- Table views with sorting
- Dashboard with statistics cards

### Color Scheme

- Primary: Green (#2c5f2d) - Agricultural theme
- Secondary: Light green (#97bc62)
- Status colors:
  - Pending: Yellow
  - Approved: Green
  - Rejected: Red

## Project Structure

```
web/
├── public/              # Static files
├── src/
│   ├── components/      # Reusable components (future)
│   ├── pages/
│   │   ├── Dashboard.jsx        # Dashboard with statistics
│   │   ├── PlantingForms.jsx    # Form management and approval
│   │   └── Varieties.jsx        # Variety CRUD
│   ├── services/
│   │   ├── api.js              # Axios configuration
│   │   └── index.js            # API service methods
│   ├── utils/                  # Utility functions (future)
│   ├── App.jsx                 # Main app component
│   ├── App.css                 # Global styles
│   └── main.jsx                # Entry point
├── .env.example         # Environment variables template
├── .gitignore
├── index.html
├── package.json
├── vite.config.js
└── README.md
```

## API Integration

The application communicates with the backend API through the following services:

- `varietyService` - Variety CRUD operations
- `plantingFormService` - Planting form management, approvals, rectifications, dashboard
- `samplingFormService` - Fruit sampling (mobile feature)
- `replantingFormService` - Replanting tracking (mobile feature)

## Development

### Adding New Pages

1. Create component in `src/pages/`
2. Add route in `src/App.jsx`
3. Add navigation link in the nav bar

### Styling

- Global styles in `src/App.css`
- Component-specific styles can be added inline or in separate CSS files

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Production Build

Build the application for production:

```bash
npm run build
```

This creates an optimized build in the `dist/` directory.

Preview the production build:

```bash
npm run preview
```

## Deployment

The built application can be deployed to:

- **Netlify**: Drag and drop the `dist/` folder
- **Vercel**: Connect your repository
- **AWS S3 + CloudFront**: Upload static files
- **Traditional web server**: Serve the `dist/` folder with nginx/apache

### Environment Variables for Production

Make sure to set `VITE_API_URL` to your production backend URL.

## License

ISC
