import type { Shelf, MoveToShelfDto, UpdateProgressDto } from '../../types';

export interface UseShelfOptions {
  bookId: string;
}

export interface UseShelfReturn {
  shelf?: Shelf;
  isLoading: boolean;
  error: unknown;
  moveToShelf: (data: MoveToShelfDto) => Promise<Shelf>;
  updateProgress: (data: UpdateProgressDto) => Promise<Shelf>;
  isMoving: boolean;
  isUpdatingProgress: boolean;
}
