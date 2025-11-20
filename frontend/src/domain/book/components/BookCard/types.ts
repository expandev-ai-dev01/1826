import type { Book } from '../../types';

export interface BookCardProps {
  book: Book;
  onEdit?: (id: string) => void;
  onDelete?: (id: string) => void;
  onViewDetails: (id: string) => void;
  className?: string;
}
