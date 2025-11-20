import type { Statistics, StatisticsParams } from '../../types';

export interface UseStatisticsOptions {
  params: StatisticsParams;
}

export interface UseStatisticsReturn {
  statistics?: Statistics;
  isLoading: boolean;
  error: unknown;
  refetch: () => void;
}
