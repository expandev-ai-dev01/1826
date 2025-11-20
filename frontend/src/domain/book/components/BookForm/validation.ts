import { z } from 'zod';

const currentYear = new Date().getFullYear();

export const bookFormSchema = z.object({
  titulo: z
    .string()
    .min(1, 'O título do livro é obrigatório')
    .max(200, 'O título deve ter no máximo 200 caracteres'),
  autor: z
    .string()
    .min(2, 'O autor deve ter no mínimo 2 caracteres')
    .max(100, 'O autor deve ter no máximo 100 caracteres'),
  ano_publicacao: z
    .number()
    .min(1000, 'O ano de publicação deve ser maior que 1000')
    .max(currentYear, `O ano de publicação não pode ser maior que ${currentYear}`),
  genero: z.string().min(1, 'Selecione um gênero literário'),
  numero_paginas: z
    .number()
    .min(1, 'O número de páginas deve ser maior que zero')
    .max(10000, 'O número de páginas deve ser menor que 10000'),
  isbn: z.string().optional(),
  sinopse: z.string().max(2000, 'A sinopse deve ter no máximo 2000 caracteres').optional(),
  capa: z.any().optional(),
});
