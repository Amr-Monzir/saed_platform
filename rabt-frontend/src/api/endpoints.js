// API Endpoints from OpenAPI Specification

// Authentication Endpoints
export const AUTH_ENDPOINTS = {
  LOGIN: '/auth/login' // POST
};

// Utility Endpoints
export const UTILITY_ENDPOINTS = {
  HEALTH: '/health', // GET
  STATS: '/stats' // GET
};

// Skills Endpoints
export const SKILLS_ENDPOINTS = {
  GET_SKILLS: '/skills', // GET
  CREATE_SKILL: '/skills', // POST
  GET_SKILL_CATEGORIES: '/skills/categories' // GET
};

// Volunteer Endpoints
export const VOLUNTEER_ENDPOINTS = {
  REGISTER: '/volunteers/register', // POST
  GET_PROFILE: '/volunteers/profile', // GET
  UPDATE_PROFILE: '/volunteers/profile', // PUT
  COMPLETE_ONBOARDING: '/volunteers/complete-onboarding' // POST
};

// Organizer Endpoints
export const ORGANIZER_ENDPOINTS = {
  REGISTER: '/organizers/register', // POST
  GET_PROFILE: '/organizers/profile', // GET
  UPDATE_PROFILE: '/organizers/profile', // PUT
  UPLOAD_LOGO: '/organizers/upload-logo', // POST
  GET_PUBLIC_INFO: (organizerId) => `/organizers/${organizerId}/public` // GET
};

// Advert Endpoints
export const ADVERT_ENDPOINTS = {
  CREATE_ADVERT: '/adverts', // POST
  LIST_ADVERTS: '/adverts', // GET
  GET_ADVERT: (advertId) => `/adverts/${advertId}`, // GET
  UPDATE_ADVERT: (advertId) => `/adverts/${advertId}`, // PUT
  DELETE_ADVERT: (advertId) => `/adverts/${advertId}`, // DELETE
};

// Application Endpoints
export const APPLICATION_ENDPOINTS = {
  APPLY_FOR_ADVERT: '/applications', // POST
  GET_APPLICATION: (applicationId) => `/applications/${applicationId}`, // GET
  WITHDRAW_APPLICATION: (applicationId) => `/applications/${applicationId}`, // DELETE
  UPDATE_APPLICATION_STATUS: (applicationId) => `/applications/${applicationId}/status` // PUT
};

// Query Parameters for List Adverts
export const LIST_ADVERTS_PARAMS = {
  SEARCH: 'search', // string, optional
  CATEGORY: 'category', // string, optional
  LOCATION_TYPE: 'location_type', // string, optional
  SKILLS: 'skills', // string, optional
  LIMIT: 'limit', // integer, default: 20
  OFFSET: 'offset' // integer, default: 0
};

// HTTP Methods
export const HTTP_METHODS = {
  GET: 'GET',
  POST: 'POST',
  PUT: 'PUT',
  DELETE: 'DELETE'
};

// Content Types
export const CONTENT_TYPES = {
  JSON: 'application/json',
  FORM_URLENCODED: 'application/x-www-form-urlencoded',
  MULTIPART_FORM_DATA: 'multipart/form-data'
};

// Helper function to build query string
export const buildQueryString = (params) => {
  const filteredParams = Object.entries(params)
    .filter(([, value]) => value !== null && value !== undefined && value !== '')
    .map(([key, value]) => `${encodeURIComponent(key)}=${encodeURIComponent(value)}`)
    .join('&');
  
  return filteredParams ? `?${filteredParams}` : '';
};

// Helper function to build list adverts URL with query parameters
export const buildListAdvertsUrl = (params = {}) => {
  const queryString = buildQueryString({
    [LIST_ADVERTS_PARAMS.SEARCH]: params.search,
    [LIST_ADVERTS_PARAMS.CATEGORY]: params.category,
    [LIST_ADVERTS_PARAMS.LOCATION_TYPE]: params.location_type,
    [LIST_ADVERTS_PARAMS.SKILLS]: params.skills,
    [LIST_ADVERTS_PARAMS.LIMIT]: params.limit,
    [LIST_ADVERTS_PARAMS.OFFSET]: params.offset
  });
  
  return `${ADVERT_ENDPOINTS.LIST_ADVERTS}${queryString}`;
};

// API endpoint configurations with methods and content types
export const API_CONFIG = {
  // Authentication
  [AUTH_ENDPOINTS.LOGIN]: {
    method: HTTP_METHODS.POST,
    contentType: CONTENT_TYPES.FORM_URLENCODED,
    requiresAuth: false
  },

  // Utilities
  [UTILITY_ENDPOINTS.HEALTH]: {
    method: HTTP_METHODS.GET,
    requiresAuth: false
  },
  [UTILITY_ENDPOINTS.STATS]: {
    method: HTTP_METHODS.GET,
    requiresAuth: false
  },

  // Skills
  [SKILLS_ENDPOINTS.GET_SKILLS]: {
    method: HTTP_METHODS.GET,
    requiresAuth: false
  },
  [SKILLS_ENDPOINTS.CREATE_SKILL]: {
    method: HTTP_METHODS.POST,
    contentType: CONTENT_TYPES.JSON,
    requiresAuth: true
  },
  [SKILLS_ENDPOINTS.GET_SKILL_CATEGORIES]: {
    method: HTTP_METHODS.GET,
    requiresAuth: false
  },

  // Volunteers
  [VOLUNTEER_ENDPOINTS.REGISTER]: {
    method: HTTP_METHODS.POST,
    contentType: CONTENT_TYPES.JSON,
    requiresAuth: false
  },
  [VOLUNTEER_ENDPOINTS.GET_PROFILE]: {
    method: HTTP_METHODS.GET,
    requiresAuth: true
  },
  [VOLUNTEER_ENDPOINTS.UPDATE_PROFILE]: {
    method: HTTP_METHODS.PUT,
    contentType: CONTENT_TYPES.JSON,
    requiresAuth: true
  },
  [VOLUNTEER_ENDPOINTS.COMPLETE_ONBOARDING]: {
    method: HTTP_METHODS.POST,
    requiresAuth: true
  },

  // Organizers
  [ORGANIZER_ENDPOINTS.REGISTER]: {
    method: HTTP_METHODS.POST,
    contentType: CONTENT_TYPES.JSON,
    requiresAuth: false
  },
  [ORGANIZER_ENDPOINTS.GET_PROFILE]: {
    method: HTTP_METHODS.GET,
    requiresAuth: true
  },
  [ORGANIZER_ENDPOINTS.UPDATE_PROFILE]: {
    method: HTTP_METHODS.PUT,
    contentType: CONTENT_TYPES.JSON,
    requiresAuth: true
  },
  [ORGANIZER_ENDPOINTS.UPLOAD_LOGO]: {
    method: HTTP_METHODS.POST,
    contentType: CONTENT_TYPES.MULTIPART_FORM_DATA,
    requiresAuth: true
  },

  // Adverts - POST (Create)
  '/adverts': {
    method: HTTP_METHODS.POST,
    contentType: CONTENT_TYPES.MULTIPART_FORM_DATA,
    requiresAuth: true
  },

  // Applications
  [APPLICATION_ENDPOINTS.APPLY_FOR_ADVERT]: {
    method: HTTP_METHODS.POST,
    contentType: CONTENT_TYPES.JSON,
    requiresAuth: true
  }
}; 