import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { reviewService } from '../../services/reviewService';
import type { UseReviewOptions, UseReviewReturn } from './types';

export const useReview = (options: UseReviewOptions): UseReviewReturn => {
  const queryClient = useQueryClient();
  const queryKey = ['review', options.bookId];

  const { data, isLoading, error } = useQuery({
    queryKey,
    queryFn: () => reviewService.getByBook(options.bookId),
    enabled: !!options.bookId,
  });

  const { mutateAsync: create, isPending: isCreating } = useMutation({
    mutationFn: (data: any) => reviewService.create(options.bookId, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey });
      queryClient.invalidateQueries({ queryKey: ['statistics'] });
    },
  });

  const { mutateAsync: update, isPending: isUpdating } = useMutation({
    mutationFn: (data: any) => reviewService.update(options.bookId, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey });
      queryClient.invalidateQueries({ queryKey: ['statistics'] });
    },
  });

  const { mutateAsync: remove, isPending: isRemoving } = useMutation({
    mutationFn: () => reviewService.delete(options.bookId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey });
      queryClient.invalidateQueries({ queryKey: ['statistics'] });
    },
  });

  return {
    review: data,
    isLoading,
    error,
    create,
    update,
    remove,
    isCreating,
    isUpdating,
    isRemoving,
  };
};
