import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { shelfService } from '../../services/shelfService';
import type { UseShelfOptions, UseShelfReturn } from './types';

export const useShelf = (options: UseShelfOptions): UseShelfReturn => {
  const queryClient = useQueryClient();
  const queryKey = ['shelf', options.bookId];

  const { data, isLoading, error } = useQuery({
    queryKey,
    queryFn: () => shelfService.getByBook(options.bookId),
    enabled: !!options.bookId,
  });

  const { mutateAsync: moveToShelf, isPending: isMoving } = useMutation({
    mutationFn: (data: any) => shelfService.moveToShelf(options.bookId, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['shelf'] });
      queryClient.invalidateQueries({ queryKey: ['books'] });
      queryClient.invalidateQueries({ queryKey: ['statistics'] });
    },
  });

  const { mutateAsync: updateProgress, isPending: isUpdatingProgress } = useMutation({
    mutationFn: (data: any) => shelfService.updateProgress(options.bookId, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey });
      queryClient.invalidateQueries({ queryKey: ['statistics'] });
    },
  });

  return {
    shelf: data,
    isLoading,
    error,
    moveToShelf,
    updateProgress,
    isMoving,
    isUpdatingProgress,
  };
};
