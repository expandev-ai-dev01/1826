import { authenticatedClient } from '@/core/lib/api';
import type { Goal, CreateGoalDto, UpdateGoalDto } from '../types';

export const goalService = {
  async getByYear(year: number): Promise<Goal | null> {
    try {
      const response = await authenticatedClient.get(`/goal/${year}`);
      return response.data.data;
    } catch (error: unknown) {
      if (typeof error === 'object' && error !== null && 'response' in error) {
        const axiosError = error as { response: { status: number } };
        if (axiosError.response?.status === 404) {
          return null;
        }
      }
      throw error;
    }
  },

  async create(data: CreateGoalDto): Promise<Goal> {
    const response = await authenticatedClient.post('/goal', data);
    return response.data.data;
  },

  async update(year: number, data: UpdateGoalDto): Promise<Goal> {
    const response = await authenticatedClient.put(`/goal/${year}`, data);
    return response.data.data;
  },

  async list(): Promise<Goal[]> {
    const response = await authenticatedClient.get('/goal');
    return response.data.data;
  },
};
