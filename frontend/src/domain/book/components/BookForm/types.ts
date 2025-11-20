export interface BookFormData {
  titulo: string;
  autor: string;
  ano_publicacao: number;
  genero: string;
  numero_paginas: number;
  isbn?: string;
  sinopse?: string;
  capa?: FileList;
}

export interface BookFormProps {
  initialData?: Partial<BookFormData>;
  onSubmit: (data: BookFormData) => void;
  onCancel: () => void;
  isSubmitting?: boolean;
}
