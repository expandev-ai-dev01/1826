import { useQuery } from '@tanstack/react-query';
import { statisticsService } from '../../services/statisticsService';
import type { UseStatisticsOptions, UseStatisticsReturn } from './types';

export const useStatistics = (options: UseStatisticsOptions): UseStatisticsReturn => {
  const queryKey = ['statistics', options.params];

  const { data, isLoading, error, refetch } = useQuery({
    queryKey,
    queryFn: () => statisticsService.get(options.params),
  });

  return {
    statistics: data,
    isLoading,
    error,
    refetch,
  };
};
