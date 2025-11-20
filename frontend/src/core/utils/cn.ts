import { clsx, type ClassValue } from 'clsx';

/**
 * @utility cn
 * @summary Utility function to merge Tailwind CSS classes
 * @category styling
 */
export function cn(...inputs: ClassValue[]) {
  return clsx(inputs);
}
