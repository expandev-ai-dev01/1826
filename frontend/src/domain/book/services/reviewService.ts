import { authenticatedClient } from '@/core/lib/api';
import type { Review, CreateReviewDto, UpdateReviewDto } from '../types';

export const reviewService = {
  async getByBook(bookId: string): Promise<Review | null> {
    try {
      const response = await authenticatedClient.get(`/review/book/${bookId}`);
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

  async create(bookId: string, data: CreateReviewDto): Promise<Review> {
    const response = await authenticatedClient.post(`/review/book/${bookId}`, data);
    return response.data.data;
  },

  async update(bookId: string, data: UpdateReviewDto): Promise<Review> {
    const response = await authenticatedClient.put(`/review/book/${bookId}`, data);
    return response.data.data;
  },

  async delete(bookId: string): Promise<void> {
    await authenticatedClient.delete(`/review/book/${bookId}`);
  },
};
