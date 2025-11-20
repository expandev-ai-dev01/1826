# BookNest Backend API

Backend API for BookNest - Personal library management and virtual book club platform.

## Features

- RESTful API architecture
- TypeScript for type safety
- Express.js framework
- Modular and scalable structure
- Comprehensive error handling
- Request validation with Zod
- API versioning support

## Getting Started

### Prerequisites

- Node.js 18+ 
- npm or yarn

### Installation

```bash
# Install dependencies
npm install

# Copy environment variables
cp .env.example .env

# Configure your .env file with appropriate values
```

### Development

```bash
# Run in development mode with hot reload
npm run dev
```

### Build

```bash
# Build for production
npm run build

# Start production server
npm start
```

### Testing

```bash
# Run tests
npm test

# Run tests in watch mode
npm run test:watch
```

### Linting

```bash
# Run linter
npm run lint

# Fix linting issues
npm run lint:fix
```

## Project Structure

```
backend/
├── src/
│   ├── api/                    # API controllers
│   │   └── v1/                 # API version 1
│   │       ├── external/       # Public endpoints
│   │       └── internal/       # Authenticated endpoints
│   ├── routes/                 # Route definitions
│   │   └── v1/                 # Version 1 routes
│   ├── middleware/             # Express middleware
│   ├── services/               # Business logic
│   ├── utils/                  # Utility functions
│   ├── config/                 # Configuration
│   └── server.ts               # Application entry point
├── dist/                       # Compiled output
├── package.json
├── tsconfig.json
└── README.md
```

## API Endpoints

The API is versioned and accessible at:

```
Development:  http://localhost:3000/api/v1
Production:   https://api.yourdomain.com/api/v1
```

### Health Check

```
GET /health
```

Returns server health status.

## Environment Variables

See `.env.example` for required environment variables.

## Contributing

Features will be implemented following the established architecture patterns.

## License

ISC
