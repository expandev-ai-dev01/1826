import type { Goal, CreateGoalDto, UpdateGoalDto } from '../../types';

export interface UseGoalOptions {
  year: number;
}

export interface UseGoalReturn {
  goal?: Goal | null;
  isLoading: boolean;
  error: unknown;
  create: (data: CreateGoalDto) => Promise<Goal>;
  update: (data: UpdateGoalDto) => Promise<Goal>;
  isCreating: boolean;
  isUpdating: boolean;
}
