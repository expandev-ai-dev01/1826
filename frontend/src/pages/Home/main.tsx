/**
 * @page HomePage
 * @summary Welcome page for BookNest application
 * @domain core
 * @type landing-page
 * @category public
 */
export const HomePage = () => {
  return (
    <div className="flex min-h-screen items-center justify-center">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">Welcome to BookNest</h1>
        <p className="text-lg text-gray-600 mb-8">Your personal library manager and reading club</p>
        <div className="space-x-4">
          <button className="px-6 py-3 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors">
            Get Started
          </button>
          <button className="px-6 py-3 bg-gray-200 text-gray-900 rounded-md hover:bg-gray-300 transition-colors">
            Learn More
          </button>
        </div>
      </div>
    </div>
  );
};

export default HomePage;
