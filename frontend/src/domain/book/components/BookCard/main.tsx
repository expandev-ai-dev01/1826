import { getBookCardClassName } from './variants';
import type { BookCardProps } from './types';

export const BookCard = ({ book, onEdit, onDelete, onViewDetails, className }: BookCardProps) => {
  return (
    <div className={getBookCardClassName({ className })}>
      {book.capa && (
        <img src={book.capa} alt={book.titulo} className="w-full h-48 object-cover rounded-t-lg" />
      )}
      <div className="p-4">
        <h3 className="text-lg font-semibold text-gray-900 mb-1 truncate">{book.titulo}</h3>
        <p className="text-sm text-gray-600 mb-2">{book.autor}</p>
        <div className="flex items-center justify-between text-xs text-gray-500 mb-3">
          <span>{book.genero}</span>
          <span>{book.ano_publicacao}</span>
        </div>
        <div className="flex gap-2">
          <button
            onClick={() => onViewDetails(book.id_livro)}
            className="flex-1 px-3 py-2 bg-blue-600 text-white text-sm rounded-md hover:bg-blue-700 transition-colors"
          >
            Ver Detalhes
          </button>
          {onEdit && (
            <button
              onClick={() => onEdit(book.id_livro)}
              className="px-3 py-2 bg-gray-200 text-gray-900 text-sm rounded-md hover:bg-gray-300 transition-colors"
            >
              Editar
            </button>
          )}
          {onDelete && (
            <button
              onClick={() => onDelete(book.id_livro)}
              className="px-3 py-2 bg-red-600 text-white text-sm rounded-md hover:bg-red-700 transition-colors"
            >
              Excluir
            </button>
          )}
        </div>
      </div>
    </div>
  );
};
