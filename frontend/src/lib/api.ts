import axios from 'axios';

// API base URL
const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';

// Create axios instance with default config
const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
  withCredentials: true, // For CSRF token and session cookies
});

// Request interceptor to add CSRF token
api.interceptors.request.use(
  (config) => {
    // Get CSRF token from meta tag if available
    const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
    if (token) {
      config.headers['X-CSRF-TOKEN'] = token;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor for error handling
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Handle unauthorized access
      console.error('Unauthorized access');
      // Redirect to login or show login modal
    } else if (error.response?.status === 422) {
      // Handle validation errors
      console.error('Validation errors:', error.response.data.errors);
    } else if (error.response?.status >= 500) {
      // Handle server errors
      console.error('Server error:', error.response.data);
    }
    return Promise.reject(error);
  }
);

// API functions
export const apiClient = {
  // Auth endpoints
  auth: {
    login: (credentials: { email: string; password: string }) =>
      api.post('/api/auth/login', credentials),
    
    register: (userData: { name: string; email: string; password: string; password_confirmation: string }) =>
      api.post('/api/auth/register', userData),
    
    logout: () => api.post('/api/auth/logout'),
    
    user: () => api.get('/api/auth/user'),
    
    forgotPassword: (email: string) =>
      api.post('/api/auth/forgot-password', { email }),
    
    resetPassword: (data: { token: string; email: string; password: string; password_confirmation: string }) =>
      api.post('/api/auth/reset-password', data),
  },

  // User endpoints
  users: {
    index: (params?: any) => api.get('/api/users', { params }),
    show: (id: number) => api.get(`/api/users/${id}`),
    store: (data: any) => api.post('/api/users', data),
    update: (id: number, data: any) => api.put(`/api/users/${id}`, data),
    destroy: (id: number) => api.delete(`/api/users/${id}`),
  },

  // Generic CRUD operations
  crud: {
    index: (endpoint: string, params?: any) => api.get(`/api/${endpoint}`, { params }),
    show: (endpoint: string, id: number) => api.get(`/api/${endpoint}/${id}`),
    store: (endpoint: string, data: any) => api.post(`/api/${endpoint}`, data),
    update: (endpoint: string, id: number, data: any) => api.put(`/api/${endpoint}/${id}`, data),
    destroy: (endpoint: string, id: number) => api.delete(`/api/${endpoint}/${id}`),
  },

  // File upload
  upload: {
    file: (file: File, endpoint: string = 'upload') => {
      const formData = new FormData();
      formData.append('file', file);
      return api.post(`/api/${endpoint}`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });
    },
  },

  // Health check
  health: () => api.get('/api/health'),
};

// Custom hooks for API calls
export const useApi = () => {
  const get = async (url: string, params?: any) => {
    try {
      const response = await api.get(url, { params });
      return { data: response.data, error: null };
    } catch (error: any) {
      return { data: null, error: error.response?.data || error.message };
    }
  };

  const post = async (url: string, data?: any) => {
    try {
      const response = await api.post(url, data);
      return { data: response.data, error: null };
    } catch (error: any) {
      return { data: null, error: error.response?.data || error.message };
    }
  };

  const put = async (url: string, data?: any) => {
    try {
      const response = await api.put(url, data);
      return { data: response.data, error: null };
    } catch (error: any) {
      return { data: null, error: error.response?.data || error.message };
    }
  };

  const del = async (url: string) => {
    try {
      const response = await api.delete(url);
      return { data: response.data, error: null };
    } catch (error: any) {
      return { data: null, error: error.response?.data || error.message };
    }
  };

  return { get, post, put, delete: del };
};

export default api; 