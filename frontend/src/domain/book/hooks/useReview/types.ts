import type { Review, CreateReviewDto, UpdateReviewDto } from '../../types';

export interface UseReviewOptions {
  bookId: string;
}

export interface UseReviewReturn {
  review?: Review | null;
  isLoading: boolean;
  error: unknown;
  create: (data: CreateReviewDto) => Promise<Review>;
  update: (data: UpdateReviewDto) => Promise<Review>;
  remove: () => Promise<void>;
  isCreating: boolean;
  isUpdating: boolean;
  isRemoving: boolean;
}
