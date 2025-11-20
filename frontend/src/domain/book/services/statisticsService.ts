import { authenticatedClient } from '@/core/lib/api';
import type { Statistics, StatisticsParams } from '../types';

export const statisticsService = {
  async get(params: StatisticsParams): Promise<Statistics> {
    const response = await authenticatedClient.get('/statistics', { params });
    return response.data.data;
  },
};
