import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { bookService } from '../../services/bookService';
import type { UseBookListOptions, UseBookListReturn } from './types';

export const useBookList = (options: UseBookListOptions = {}): UseBookListReturn => {
  const queryClient = useQueryClient();
  const queryKey = ['books', options.filters];

  const { data, isLoading, error, refetch } = useQuery({
    queryKey,
    queryFn: () => bookService.list(options.filters),
  });

  const { mutateAsync: create, isPending: isCreating } = useMutation({
    mutationFn: bookService.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['books'] });
    },
  });

  const { mutateAsync: update, isPending: isUpdating } = useMutation({
    mutationFn: ({ id, data }: { id: string; data: any }) => bookService.update(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['books'] });
    },
  });

  const { mutateAsync: remove, isPending: isRemoving } = useMutation({
    mutationFn: bookService.delete,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['books'] });
    },
  });

  return {
    books: data || [],
    isLoading,
    error,
    refetch,
    create,
    update,
    remove,
    isCreating,
    isUpdating,
    isRemoving,
  };
};
