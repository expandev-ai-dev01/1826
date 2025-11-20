import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { goalService } from '../../services/goalService';
import type { UseGoalOptions, UseGoalReturn } from './types';

export const useGoal = (options: UseGoalOptions): UseGoalReturn => {
  const queryClient = useQueryClient();
  const queryKey = ['goal', options.year];

  const { data, isLoading, error } = useQuery({
    queryKey,
    queryFn: () => goalService.getByYear(options.year),
  });

  const { mutateAsync: create, isPending: isCreating } = useMutation({
    mutationFn: goalService.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['goal'] });
    },
  });

  const { mutateAsync: update, isPending: isUpdating } = useMutation({
    mutationFn: (data: any) => goalService.update(options.year, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey });
    },
  });

  return {
    goal: data,
    isLoading,
    error,
    create,
    update,
    isCreating,
    isUpdating,
  };
};
