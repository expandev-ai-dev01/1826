# BookNest - Personal Library Manager

Plataforma web para gerenciamento de biblioteca pessoal e clube de leitura virtual.

## Features

- Catalogação de livros (lidos, em leitura, lista de desejos)
- Sistema de avaliação e resenhas
- Dashboard com estatísticas de leitura
- Timeline de leituras
- Metas anuais de leitura
- Busca e filtros avançados

## Tech Stack

- React 19.2.0
- TypeScript 5.6.3
- Vite 5.4.11
- TailwindCSS 3.4.14
- React Router 7.9.3
- TanStack Query 5.90.2
- Zustand 5.0.8
- React Hook Form 7.63.0
- Zod 4.1.11

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

# Start development server
npm run dev
```

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint

## Project Structure

```
src/
├── app/              # Application configuration
├── assets/           # Static assets and styles
├── core/             # Core components and utilities
├── domain/           # Business domain modules
└── pages/            # Page components
```

## Environment Variables

```
VITE_API_URL=http://localhost:3000
VITE_API_VERSION=v1
VITE_API_TIMEOUT=30000
```

## License

Private - All rights reserved