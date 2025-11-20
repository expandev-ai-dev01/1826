import { useState } from 'react';
import { useStatistics, useGoal } from '@/domain/book';
import { LoadingSpinner } from '@/core/components/LoadingSpinner';

export const DashboardPage = () => {
  const currentYear = new Date().getFullYear();
  const [selectedYear, setSelectedYear] = useState(currentYear);
  const [selectedPeriod, setSelectedPeriod] = useState<'Mensal' | 'Anual' | 'Todo o Tempo'>(
    'Anual'
  );

  const { statistics, isLoading: statsLoading } = useStatistics({
    params: {
      periodo: selectedPeriod,
      ano_referencia: selectedPeriod !== 'Todo o Tempo' ? selectedYear : undefined,
    },
  });

  const { goal, isLoading: goalLoading } = useGoal({ year: currentYear });

  if (statsLoading || goalLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <LoadingSpinner size="lg" />
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold text-gray-900 mb-8">Dashboard de Leitura</h1>

      <div className="mb-6 flex gap-4">
        <select
          value={selectedPeriod}
          onChange={(e) => setSelectedPeriod(e.target.value as any)}
          className="px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          <option value="Mensal">Mensal</option>
          <option value="Anual">Anual</option>
          <option value="Todo o Tempo">Todo o Tempo</option>
        </select>
        {selectedPeriod !== 'Todo o Tempo' && (
          <select
            value={selectedYear}
            onChange={(e) => setSelectedYear(Number(e.target.value))}
            className="px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            {Array.from({ length: 5 }, (_, i) => currentYear - i).map((year) => (
              <option key={year} value={year}>
                {year}
              </option>
            ))}
          </select>
        )}
      </div>

      {goal && selectedYear === currentYear && (
        <div className="bg-white rounded-lg shadow-md p-6 mb-6">
          <h2 className="text-xl font-semibold text-gray-900 mb-4">
            Meta de Leitura {currentYear}
          </h2>
          <div className="mb-4">
            <div className="flex justify-between text-sm text-gray-600 mb-2">
              <span>
                {goal.progresso_livros} de {goal.quantidade_livros} livros
              </span>
              <span>{goal.percentual_concluido.toFixed(1)}%</span>
            </div>
            <div className="w-full bg-gray-200 rounded-full h-4">
              <div
                className="bg-blue-600 h-4 rounded-full transition-all"
                style={{ width: `${Math.min(goal.percentual_concluido, 100)}%` }}
              />
            </div>
          </div>
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <div className="bg-white rounded-lg shadow-md p-6">
          <h3 className="text-sm font-medium text-gray-600 mb-2">Livros Lidos</h3>
          <p className="text-3xl font-bold text-gray-900">{statistics?.total_livros_lidos || 0}</p>
        </div>
        <div className="bg-white rounded-lg shadow-md p-6">
          <h3 className="text-sm font-medium text-gray-600 mb-2">Páginas Lidas</h3>
          <p className="text-3xl font-bold text-gray-900">{statistics?.total_paginas_lidas || 0}</p>
        </div>
        <div className="bg-white rounded-lg shadow-md p-6">
          <h3 className="text-sm font-medium text-gray-600 mb-2">Média por Mês</h3>
          <p className="text-3xl font-bold text-gray-900">
            {statistics?.media_livros_por_mes.toFixed(1) || 0}
          </p>
        </div>
        <div className="bg-white rounded-lg shadow-md p-6">
          <h3 className="text-sm font-medium text-gray-600 mb-2">Avaliação Média</h3>
          <p className="text-3xl font-bold text-gray-900">
            {statistics?.media_avaliacao.toFixed(1) || 0} ⭐
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-xl font-semibold text-gray-900 mb-4">Gêneros Mais Lidos</h2>
          {statistics?.generos_mais_lidos.length ? (
            <div className="space-y-3">
              {statistics.generos_mais_lidos.map((item) => (
                <div key={item.genero}>
                  <div className="flex justify-between text-sm mb-1">
                    <span className="text-gray-700">{item.genero}</span>
                    <span className="text-gray-600">
                      {item.quantidade} ({item.percentual.toFixed(1)}%)
                    </span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div
                      className="bg-blue-600 h-2 rounded-full"
                      style={{ width: `${item.percentual}%` }}
                    />
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <p className="text-gray-600">Nenhum dado disponível</p>
          )}
        </div>

        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-xl font-semibold text-gray-900 mb-4">Autores Mais Lidos</h2>
          {statistics?.autores_mais_lidos.length ? (
            <div className="space-y-3">
              {statistics.autores_mais_lidos.map((item) => (
                <div key={item.autor}>
                  <div className="flex justify-between text-sm mb-1">
                    <span className="text-gray-700">{item.autor}</span>
                    <span className="text-gray-600">
                      {item.quantidade} ({item.percentual.toFixed(1)}%)
                    </span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div
                      className="bg-green-600 h-2 rounded-full"
                      style={{ width: `${item.percentual}%` }}
                    />
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <p className="text-gray-600">Nenhum dado disponível</p>
          )}
        </div>
      </div>
    </div>
  );
};

export default DashboardPage;
