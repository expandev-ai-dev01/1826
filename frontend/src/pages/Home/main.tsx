import { useNavigate } from 'react-router-dom';

export const HomePage = () => {
  const navigate = useNavigate();

  return (
    <div className="flex min-h-screen items-center justify-center">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">Bem-vindo ao BookNest</h1>
        <p className="text-lg text-gray-600 mb-8">
          Sua biblioteca pessoal e clube de leitura virtual
        </p>
        <div className="space-x-4">
          <button
            onClick={() => navigate('/library')}
            className="px-6 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors"
          >
            Minha Biblioteca
          </button>
          <button
            onClick={() => navigate('/dashboard')}
            className="px-6 py-3 bg-gray-200 text-gray-900 rounded-md hover:bg-gray-300 transition-colors"
          >
            Ver Estatísticas
          </button>
        </div>
      </div>
    </div>
  );
};

export default HomePage;
