import type { BookListParams, Book, CreateBookDto, UpdateBookDto } from '../../types';

export interface UseBookListOptions {
  filters?: BookListParams;
}

export interface UseBookListReturn {
  books: Book[];
  isLoading: boolean;
  error: unknown;
  refetch: () => void;
  create: (data: CreateBookDto) => Promise<Book>;
  update: (params: { id: string; data: UpdateBookDto }) => Promise<Book>;
  remove: (id: string) => Promise<void>;
  isCreating: boolean;
  isUpdating: boolean;
  isRemoving: boolean;
}
