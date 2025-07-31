'use client';

import { useState, useEffect } from 'react';
import { UserIcon, CogIcon, ChartBarIcon } from '@heroicons/react/24/outline';

interface ApiResponse {
  message: string;
  timestamp: string;
}

export default function HomePage() {
  const [apiData, setApiData] = useState<ApiResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchApiData = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await fetch('/api/hello');
      if (!response.ok) {
        throw new Error('API request failed');
      }
      const data = await response.json();
      setApiData(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchApiData();
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-50 to-secondary-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center">
              <h1 className="text-xl font-semibold text-gray-900">
                Laravel + Next.js App
              </h1>
            </div>
            <nav className="flex space-x-4">
              <a href="#" className="text-gray-500 hover:text-gray-700 px-3 py-2 rounded-md text-sm font-medium">
                Home
              </a>
              <a href="#" className="text-gray-500 hover:text-gray-700 px-3 py-2 rounded-md text-sm font-medium">
                About
              </a>
              <a href="#" className="text-gray-500 hover:text-gray-700 px-3 py-2 rounded-md text-sm font-medium">
                Contact
              </a>
            </nav>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:px-8">
        {/* Hero Section */}
        <div className="text-center mb-12">
          <h2 className="text-4xl font-bold text-gray-900 mb-4">
            Welcome to Your Full-Stack Application
          </h2>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            This is a modern full-stack application built with Laravel backend and Next.js frontend.
            Experience the power of both worlds combined.
          </p>
        </div>

        {/* Features Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
          <div className="card text-center">
            <div className="flex justify-center mb-4">
              <UserIcon className="h-12 w-12 text-primary-600" />
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">
              User Management
            </h3>
            <p className="text-gray-600">
              Complete user authentication and authorization system powered by Laravel.
            </p>
          </div>

          <div className="card text-center">
            <div className="flex justify-center mb-4">
              <CogIcon className="h-12 w-12 text-primary-600" />
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">
              API Integration
            </h3>
            <p className="text-gray-600">
              Seamless API communication between Next.js frontend and Laravel backend.
            </p>
          </div>

          <div className="card text-center">
            <div className="flex justify-center mb-4">
              <ChartBarIcon className="h-12 w-12 text-primary-600" />
            </div>
            <h3 className="text-lg font-semibold text-gray-900 mb-2">
              Real-time Data
            </h3>
            <p className="text-gray-600">
              Dynamic data fetching and real-time updates with modern React hooks.
            </p>
          </div>
        </div>

        {/* API Test Section */}
        <div className="card">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">
            API Connection Test
          </h3>
          <div className="space-y-4">
            <button
              onClick={fetchApiData}
              disabled={loading}
              className="btn-primary disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? 'Loading...' : 'Test API Connection'}
            </button>

            {error && (
              <div className="bg-red-50 border border-red-200 rounded-md p-4">
                <p className="text-red-800">Error: {error}</p>
              </div>
            )}

            {apiData && (
              <div className="bg-green-50 border border-green-200 rounded-md p-4">
                <h4 className="font-medium text-green-800 mb-2">API Response:</h4>
                <pre className="text-sm text-green-700 bg-green-100 p-3 rounded">
                  {JSON.stringify(apiData, null, 2)}
                </pre>
              </div>
            )}
          </div>
        </div>

        {/* Technology Stack */}
        <div className="mt-12">
          <h3 className="text-2xl font-bold text-gray-900 mb-6 text-center">
            Technology Stack
          </h3>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {[
              { name: 'Laravel', color: 'bg-red-100 text-red-800' },
              { name: 'Next.js', color: 'bg-black text-white' },
              { name: 'React', color: 'bg-blue-100 text-blue-800' },
              { name: 'TypeScript', color: 'bg-blue-600 text-white' },
              { name: 'Tailwind CSS', color: 'bg-cyan-100 text-cyan-800' },
              { name: 'MySQL', color: 'bg-blue-500 text-white' },
              { name: 'Docker', color: 'bg-blue-700 text-white' },
              { name: 'AWS EC2', color: 'bg-orange-100 text-orange-800' },
            ].map((tech) => (
              <div
                key={tech.name}
                className={`${tech.color} px-4 py-2 rounded-lg text-center font-medium`}
              >
                {tech.name}
              </div>
            ))}
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-white border-t border-gray-200 mt-16">
        <div className="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
          <div className="text-center text-gray-500">
            <p>&copy; 2024 Laravel + Next.js App. All rights reserved.</p>
          </div>
        </div>
      </footer>
    </div>
  );
} 