import { authenticatedClient } from '@/core/lib/api';
import type { Shelf, MoveToShelfDto, UpdateProgressDto } from '../types';

export const shelfService = {
  async getByBook(bookId: string): Promise<Shelf> {
    const response = await authenticatedClient.get(`/shelf/book/${bookId}`);
    return response.data.data;
  },

  async moveToShelf(bookId: string, data: MoveToShelfDto): Promise<Shelf> {
    const response = await authenticatedClient.post(`/shelf/book/${bookId}`, data);
    return response.data.data;
  },

  async updateProgress(bookId: string, data: UpdateProgressDto): Promise<Shelf> {
    const response = await authenticatedClient.patch(`/shelf/book/${bookId}/progress`, data);
    return response.data.data;
  },

  async listByShelf(tipo: 'Lido' | 'Lendo' | 'Quero Ler'): Promise<Shelf[]> {
    const response = await authenticatedClient.get('/shelf', { params: { tipo_estante: tipo } });
    return response.data.data;
  },
};
