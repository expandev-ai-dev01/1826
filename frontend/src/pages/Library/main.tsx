import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useBookList } from '@/domain/book';
import { BookCard } from '@/domain/book';
import { LoadingSpinner } from '@/core/components/LoadingSpinner';

export const LibraryPage = () => {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedGenre, setSelectedGenre] = useState('');

  const { books, isLoading, error } = useBookList({
    filters: {
      search: searchTerm || undefined,
      genero: selectedGenre || undefined,
    },
  });

  if (error) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">Erro ao carregar biblioteca</h2>
          <button
            onClick={() => window.location.reload()}
            className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
          >
            Tentar novamente
          </button>
        </div>
      </div>
    );
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Minha Biblioteca</h1>
        <button
          onClick={() => navigate('/library/new')}
          className="px-6 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors"
        >
          Adicionar Livro
        </button>
      </div>

      <div className="mb-6 flex gap-4">
        <input
          type="text"
          placeholder="Buscar por título ou autor..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="flex-1 px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
        <select
          value={selectedGenre}
          onChange={(e) => setSelectedGenre(e.target.value)}
          className="px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          <option value="">Todos os gêneros</option>
          <option value="Ficção">Ficção</option>
          <option value="Não-Ficção">Não-Ficção</option>
          <option value="Romance">Romance</option>
          <option value="Fantasia">Fantasia</option>
        </select>
      </div>

      {books.length === 0 ? (
        <div className="text-center py-12">
          <p className="text-gray-600 mb-4">Nenhum livro encontrado</p>
          <button
            onClick={() => navigate('/library/new')}
            className="px-6 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors"
          >
            Adicionar seu primeiro livro
          </button>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {books.map((book) => (
            <BookCard
              key={book.id_livro}
              book={book}
              onViewDetails={(id) => navigate(`/library/${id}`)}
              onEdit={(id) => navigate(`/library/${id}/edit`)}
            />
          ))}
        </div>
      )}
    </div>
  );
};

export default LibraryPage;
