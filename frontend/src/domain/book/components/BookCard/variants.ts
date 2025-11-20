import { clsx } from 'clsx';

export interface BookCardVariantProps {
  className?: string;
}

export function getBookCardClassName(props: BookCardVariantProps): string {
  const { className } = props;

  return clsx(
    'bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow',
    className
  );
}
