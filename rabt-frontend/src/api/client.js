// API Client for making HTTP requests to the backend

import { API_CONFIG, CONTENT_TYPES } from './endpoints.js';

// Base configuration
const DEFAULT_CONFIG = {
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/api/v1',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
    'ngrok-skip-browser-warning': 'true' // Required for ngrok tunnels
  }
};

// Auth token management
let authToken = null;

export const setAuthToken = (token) => {
  authToken = token;
  console.log('Auth token set:', {
    token: token ? `${token.substring(0, 20)}...` : 'none'
  });
};

export const getAuthToken = () => {
  const token = authToken || localStorage.getItem('authToken');
  console.log('Getting auth token:', {
    authToken: authToken ? `${authToken.substring(0, 20)}...` : 'none',
    localStorageToken: localStorage.getItem('authToken') ? `${localStorage.getItem('authToken').substring(0, 20)}...` : 'none',
    finalToken: token ? `${token.substring(0, 20)}...` : 'none',
    tokenLength: token ? token.length : 0
  });
  return token;
};

export const clearAuthToken = () => {
  console.log('Clearing auth token');
  authToken = null;
  localStorage.removeItem('authToken');
};

// Helper function to build headers
const buildHeaders = (endpoint, method = 'GET', customHeaders = {}) => {
  // Try to find the config by exact endpoint match first
  let config = API_CONFIG[endpoint];
  
  // If not found, try to find by path (for backward compatibility)
  if (!config) {
    config = API_CONFIG[endpoint] || {};
  }
  
  // For endpoints that can have different methods, check if the config method matches
  if (config.method && config.method !== method) {
    // If the config method doesn't match, we might need different logic
    // For now, we'll use the config as-is, but this could be enhanced
    console.log(`Method mismatch for endpoint ${endpoint}: config method is ${config.method}, request method is ${method}`);
  }
  
  const headers = { ...DEFAULT_CONFIG.headers, ...customHeaders };
  
  // Set content type if specified in config
  if (config.contentType) {
    if (config.contentType === CONTENT_TYPES.MULTIPART_FORM_DATA) {
      // Let the browser set the boundary for multipart/form-data
      delete headers['Content-Type'];
    } else {
      headers['Content-Type'] = config.contentType;
    }
  }
  
  // Add auth token if required
  console.log('Config:', config);
  
  // Special handling for /adverts endpoint based on method
  if (endpoint === '/adverts') {
    if (method === 'POST') {
      // POST to /adverts requires auth
      const token = getAuthToken();
      console.log('Adding auth token for POST /adverts:', token);
      if (token) {
        headers['Authorization'] = `Bearer ${token}`;
        console.log('Auth token added for POST /adverts:', {
          tokenPresent: !!token,
          tokenPreview: token ? `${token.substring(0, 20)}...` : 'none',
          headers: headers
        });
      } else {
        console.log('No auth token found for POST /adverts');
      }
    } else {
      // GET to /adverts doesn't require auth
      console.log('GET /adverts - no auth required');
    }
  } else if (config.requiresAuth) {
    console.log('Adding auth token for endpoint:', endpoint);
    const token = getAuthToken();
    console.log(token);
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
      
      // Debug auth headers for all authenticated endpoints
      console.log('Auth token added:', {
        endpoint,
        tokenPresent: !!token,
        tokenPreview: token ? `${token.substring(0, 20)}...` : 'none',
        headers: headers
      });
    } else {
      console.log('No auth token found for endpoint:', endpoint);
      console.log('Available tokens:', {
        authToken: authToken ? `${authToken.substring(0, 20)}...` : 'none',
        localStorageToken: localStorage.getItem('authToken') ? `${localStorage.getItem('authToken').substring(0, 20)}...` : 'none'
      });
    }
  }
  
  return headers;
};

// Helper function to build request body
const buildRequestBody = (endpoint, data) => {
  const config = API_CONFIG[endpoint] || {};
  
  if (config.contentType === CONTENT_TYPES.FORM_URLENCODED) {
    return new URLSearchParams(data).toString();
  } else if (config.contentType === CONTENT_TYPES.MULTIPART_FORM_DATA) {
    const formData = new FormData();
    Object.entries(data).forEach(([key, value]) => {
      if (value !== null && value !== undefined) {
        formData.append(key, value);
      }
    });
    return formData;
  } else {
    return JSON.stringify(data);
  }
};

// Base fetch function with error handling
const apiFetch = async (url, options = {}) => {
  try {
    // If URL is already absolute, use it as-is, otherwise it should already be constructed properly
    const fullUrl = url.startsWith('http') ? url : url;
    
    const response = await fetch(fullUrl, {
      ...options,
      headers: {
        ...options.headers
      }
    });

    // Handle different response types
    let responseData;
    const contentType = response.headers.get('content-type');
    
    if (contentType && contentType.includes('application/json')) {
      responseData = await response.json();
    } else {
      responseData = await response.text();
    }

    if (!response.ok) {
      throw new APIError(response.status, responseData, response.statusText);
    }

    return responseData;
  } catch (error) {
    if (error instanceof APIError) {
      throw error;
    }
    throw new APIError(0, { message: error.message }, 'Network Error');
  }
};

// Custom API Error class
export class APIError extends Error {
  constructor(status, data, statusText) {
    super(data?.message || statusText || 'API Error');
    this.status = status;
    this.data = data;
    this.statusText = statusText;
  }
}

// HTTP Methods
export const apiClient = {
  get: async (endpoint, params = {}, customHeaders = {}) => {
    // Construct URL properly - don't let endpoint override baseURL path
    const baseUrl = DEFAULT_CONFIG.baseURL.endsWith('/') ? DEFAULT_CONFIG.baseURL.slice(0, -1) : DEFAULT_CONFIG.baseURL;
    const cleanEndpoint = endpoint.startsWith('/') ? endpoint.slice(1) : endpoint;
    const fullUrl = `${baseUrl}/${cleanEndpoint}`;
    
    const url = new URL(fullUrl);
    Object.entries(params).forEach(([key, value]) => {
      if (value !== null && value !== undefined && value !== '') {
        url.searchParams.append(key, value);
      }
    });

    const finalUrl = url.toString();
    const headers = buildHeaders(endpoint, 'GET', customHeaders);
    
    // Debug organizer profile requests
    if (endpoint.includes('organizers/profile')) {
      console.log('GET request details:', {
        endpoint,
        baseURL: DEFAULT_CONFIG.baseURL,
        baseUrl,
        cleanEndpoint,
        fullUrl,
        finalUrl,
        headers
      });
    }

    return apiFetch(fullUrl, {
      method: 'GET',
      headers
    });
  },

  post: async (endpoint, data = {}, customHeaders = {}) => {
    // Construct URL properly
    const baseUrl = DEFAULT_CONFIG.baseURL.endsWith('/') ? DEFAULT_CONFIG.baseURL.slice(0, -1) : DEFAULT_CONFIG.baseURL;
    const cleanEndpoint = endpoint.startsWith('/') ? endpoint.slice(1) : endpoint;
    const fullUrl = `${baseUrl}/${cleanEndpoint}`;
    
    const headers = buildHeaders(endpoint, 'POST', customHeaders);
    const body = buildRequestBody(endpoint, data);
    
    // Debug login requests
    if (endpoint === '/auth/login') {
      console.log('POST request details:', {
        endpoint,
        baseUrl,
        cleanEndpoint,
        fullUrl,
        headers,
        body,
        bodyType: typeof body
      });
    }
    
    return apiFetch(fullUrl, {
      method: 'POST',
      headers,
      body
    });
  },

  put: async (endpoint, data = {}, customHeaders = {}) => {
    // Construct URL properly
    const baseUrl = DEFAULT_CONFIG.baseURL.endsWith('/') ? DEFAULT_CONFIG.baseURL.slice(0, -1) : DEFAULT_CONFIG.baseURL;
    const cleanEndpoint = endpoint.startsWith('/') ? endpoint.slice(1) : endpoint;
    const fullUrl = `${baseUrl}/${cleanEndpoint}`;
    
    return apiFetch(fullUrl, {
      method: 'PUT',
      headers: buildHeaders(endpoint, 'PUT', customHeaders),
      body: buildRequestBody(endpoint, data)
    });
  },

  delete: async (endpoint, customHeaders = {}) => {
    // Construct URL properly
    const baseUrl = DEFAULT_CONFIG.baseURL.endsWith('/') ? DEFAULT_CONFIG.baseURL.slice(0, -1) : DEFAULT_CONFIG.baseURL;
    const cleanEndpoint = endpoint.startsWith('/') ? endpoint.slice(1) : endpoint;
    const fullUrl = `${baseUrl}/${cleanEndpoint}`;
    
    return apiFetch(fullUrl, {
      method: 'DELETE',
      headers: buildHeaders(endpoint, 'DELETE', customHeaders)
    });
  },

  // Special method for file uploads
  upload: async (endpoint, formData, customHeaders = {}) => {
    // Construct URL properly
    const baseUrl = DEFAULT_CONFIG.baseURL.endsWith('/') ? DEFAULT_CONFIG.baseURL.slice(0, -1) : DEFAULT_CONFIG.baseURL;
    const cleanEndpoint = endpoint.startsWith('/') ? endpoint.slice(1) : endpoint;
    const fullUrl = `${baseUrl}/${cleanEndpoint}`;
    
    const headers = buildHeaders(endpoint, 'POST', customHeaders);
    
    // Debug upload requests for advert creation
    if (endpoint === '/adverts') {
      console.log('Advert creation upload request:', {
        endpoint,
        baseUrl,
        cleanEndpoint,
        fullUrl,
        headers,
        formDataEntries: Array.from(formData.entries())
      });
    }
    
    return apiFetch(fullUrl, {
      method: 'POST',
      headers,
      body: formData
    });
  }
};

// Response interceptor for handling common scenarios
export const handleAPIResponse = async (apiCall) => {
  try {
    const response = await apiCall();
    return { success: true, data: response, error: null };
  } catch (error) {
    console.error('API Error:', error);
    
    // Handle specific error scenarios
    if (error.status === 401) {
      // Unauthorized - clear token and redirect to login
      clearAuthToken();
      window.location.href = '/login';
    }
    
    return { 
      success: false, 
      data: null, 
      error: {
        status: error.status,
        message: error.message,
        details: error.data
      }
    };
  }
};

// Helper function for paginated requests
export const fetchPaginated = async (endpoint, params = {}, allItems = []) => {
  const response = await apiClient.get(endpoint, params);
  const items = Array.isArray(response) ? response : response.items || [];
  const totalItems = [...allItems, ...items];
  
  // If we received fewer items than the limit, we've reached the end
  const limit = params.limit || 20;
  if (items.length < limit) {
    return totalItems;
  }
  
  // Fetch next page
  const nextParams = {
    ...params,
    offset: (params.offset || 0) + limit
  };
  
  return fetchPaginated(endpoint, nextParams, totalItems);
};

export default apiClient; 