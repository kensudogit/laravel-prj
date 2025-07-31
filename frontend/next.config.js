/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: process.env.NODE_ENV === 'development' 
          ? 'http://localhost:8000/api/:path*' 
          : 'http://laravel-app:8000/api/:path*',
      },
    ];
  },
  images: {
    domains: ['localhost', 'laravel-app'],
  },
  env: {
    NEXT_PUBLIC_API_URL: process.env.NODE_ENV === 'development' 
      ? 'http://localhost:8000' 
      : 'http://laravel-app:8000',
  },
};

module.exports = nextConfig; 