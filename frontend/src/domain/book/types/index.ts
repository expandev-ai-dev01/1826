export interface Book {
  id_livro: string;
  titulo: string;
  autor: string;
  ano_publicacao: number;
  genero: string;
  capa?: string;
  isbn?: string;
  numero_paginas: number;
  sinopse?: string;
  data_cadastro: string;
  id_usuario: string;
}

export interface CreateBookDto {
  titulo: string;
  autor: string;
  ano_publicacao: number;
  genero: string;
  capa?: File;
  isbn?: string;
  numero_paginas: number;
  sinopse?: string;
}

export interface UpdateBookDto extends Partial<CreateBookDto> {}

export interface BookListParams {
  search?: string;
  genero?: string;
  autor?: string;
  page?: number;
  limit?: number;
}

export interface Shelf {
  id_estante: string;
  tipo_estante: 'Lido' | 'Lendo' | 'Quero Ler';
  id_livro: string;
  id_usuario: string;
  data_adicao: string;
  data_inicio_leitura?: string;
  data_conclusao?: string;
  pagina_atual?: number;
  ultima_atualizacao: string;
}

export interface MoveToShelfDto {
  tipo_estante: 'Lido' | 'Lendo' | 'Quero Ler';
  data_inicio_leitura?: string;
  data_conclusao?: string;
  pagina_atual?: number;
}

export interface UpdateProgressDto {
  pagina_atual: number;
}

export interface Review {
  id_avaliacao: string;
  id_livro: string;
  id_usuario: string;
  nota: number;
  resenha?: string;
  data_avaliacao: string;
  data_atualizacao?: string;
  visibilidade: 'Pública' | 'Privada';
}

export interface CreateReviewDto {
  nota: number;
  resenha?: string;
  visibilidade?: 'Pública' | 'Privada';
}

export interface UpdateReviewDto extends Partial<CreateReviewDto> {}

export interface Goal {
  id_meta: string;
  id_usuario: string;
  ano: number;
  quantidade_livros: number;
  quantidade_paginas?: number;
  data_criacao: string;
  data_atualizacao?: string;
  progresso_livros: number;
  progresso_paginas?: number;
  percentual_concluido: number;
  status: 'Ativa' | 'Concluída' | 'Arquivada';
}

export interface CreateGoalDto {
  ano: number;
  quantidade_livros: number;
  quantidade_paginas?: number;
}

export interface UpdateGoalDto extends Partial<CreateGoalDto> {}

export interface Statistics {
  id_usuario: string;
  periodo: 'Mensal' | 'Anual' | 'Todo o Tempo';
  ano_referencia?: number;
  mes_referencia?: number;
  total_livros_lidos: number;
  total_paginas_lidas: number;
  media_livros_por_mes: number;
  media_paginas_por_dia: number;
  generos_mais_lidos: Array<{ genero: string; quantidade: number; percentual: number }>;
  autores_mais_lidos: Array<{ autor: string; quantidade: number; percentual: number }>;
  media_avaliacao: number;
  distribuicao_leitura_meses: Array<{
    mes: number;
    quantidade_livros: number;
    quantidade_paginas: number;
  }>;
  tempo_medio_leitura: number;
  historico_paginas_por_ano: Array<{ ano: number; total_paginas: number }>;
}

export interface StatisticsParams {
  periodo: 'Mensal' | 'Anual' | 'Todo o Tempo';
  ano_referencia?: number;
  mes_referencia?: number;
}

export const GENEROS_LITERARIOS = [
  'Ficção',
  'Não-Ficção',
  'Romance',
  'Fantasia',
  'Ficção Científica',
  'Mistério',
  'Thriller',
  'Terror',
  'Biografia',
  'História',
  'Autoajuda',
  'Negócios',
  'Poesia',
  'Drama',
  'Aventura',
  'Infantil',
  'Jovem Adulto',
  'Clássico',
  'Outro',
] as const;

export type GeneroLiterario = (typeof GENEROS_LITERARIOS)[number];
