import { authenticatedClient } from '@/core/lib/api';
import type { Book, CreateBookDto, UpdateBookDto, BookListParams } from '../types';

export const bookService = {
  async list(params?: BookListParams): Promise<Book[]> {
    const response = await authenticatedClient.get('/book', { params });
    return response.data.data;
  },

  async getById(id: string): Promise<Book> {
    const response = await authenticatedClient.get(`/book/${id}`);
    return response.data.data;
  },

  async create(data: CreateBookDto): Promise<Book> {
    const formData = new FormData();
    formData.append('titulo', data.titulo);
    formData.append('autor', data.autor);
    formData.append('ano_publicacao', data.ano_publicacao.toString());
    formData.append('genero', data.genero);
    formData.append('numero_paginas', data.numero_paginas.toString());
    if (data.isbn) formData.append('isbn', data.isbn);
    if (data.sinopse) formData.append('sinopse', data.sinopse);
    if (data.capa) formData.append('capa', data.capa);

    const response = await authenticatedClient.post('/book', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return response.data.data;
  },

  async update(id: string, data: UpdateBookDto): Promise<Book> {
    const formData = new FormData();
    if (data.titulo) formData.append('titulo', data.titulo);
    if (data.autor) formData.append('autor', data.autor);
    if (data.ano_publicacao) formData.append('ano_publicacao', data.ano_publicacao.toString());
    if (data.genero) formData.append('genero', data.genero);
    if (data.numero_paginas) formData.append('numero_paginas', data.numero_paginas.toString());
    if (data.isbn) formData.append('isbn', data.isbn);
    if (data.sinopse) formData.append('sinopse', data.sinopse);
    if (data.capa) formData.append('capa', data.capa);

    const response = await authenticatedClient.put(`/book/${id}`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return response.data.data;
  },

  async delete(id: string): Promise<void> {
    await authenticatedClient.delete(`/book/${id}`);
  },
};
