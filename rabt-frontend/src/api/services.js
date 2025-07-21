// API Service functions for specific endpoints

import { apiClient, handleAPIResponse } from './client.js';
import {
  AUTH_ENDPOINTS,
  VOLUNTEER_ENDPOINTS,
  ORGANIZER_ENDPOINTS,
  SKILLS_ENDPOINTS,
  ADVERT_ENDPOINTS,
  APPLICATION_ENDPOINTS,
  UTILITY_ENDPOINTS,
  buildListAdvertsUrl
} from './endpoints.js';
import {
  createLoginRequest,
  createVolunteerCreateRequest,
  createOrganizerCreateRequest,
  createApplicationCreateRequest
} from './types.js';

// Authentication Services
export const authService = {
  login: async (username, password) => {
    const requestData = createLoginRequest(username, password);
    console.log('Login request data:', requestData);
    console.log('Login endpoint:', AUTH_ENDPOINTS.LOGIN);
    return handleAPIResponse(() => 
      apiClient.post(AUTH_ENDPOINTS.LOGIN, requestData)
    );
  },

  logout: () => {
    // Clear token from storage/memory
    localStorage.removeItem('authToken');
    return { success: true };
  }
};

// Volunteer Services
export const volunteerService = {
  register: async (name, email, password, options = {}) => {
    const requestData = createVolunteerCreateRequest(name, email, password, options);
    return handleAPIResponse(() => 
      apiClient.post(VOLUNTEER_ENDPOINTS.REGISTER, requestData)
    );
  },

  getProfile: async () => {
    return handleAPIResponse(() => 
      apiClient.get(VOLUNTEER_ENDPOINTS.GET_PROFILE)
    );
  },

  updateProfile: async (profileData) => {
    return handleAPIResponse(() => 
      apiClient.put(VOLUNTEER_ENDPOINTS.UPDATE_PROFILE, profileData)
    );
  },

  completeOnboarding: async () => {
    return handleAPIResponse(() => 
      apiClient.post(VOLUNTEER_ENDPOINTS.COMPLETE_ONBOARDING)
    );
  }
};

// Organizer Services
export const organizerService = {
  register: async (name, email, password, options = {}) => {
    const requestData = createOrganizerCreateRequest(name, email, password, options);
    return handleAPIResponse(() => 
      apiClient.post(ORGANIZER_ENDPOINTS.REGISTER, requestData)
    );
  },

  getProfile: async () => {
    console.log('Getting organizer profile from endpoint:', ORGANIZER_ENDPOINTS.GET_PROFILE);
    return handleAPIResponse(() => 
      apiClient.get(ORGANIZER_ENDPOINTS.GET_PROFILE)
    );
  },

  updateProfile: async (profileData) => {
    return handleAPIResponse(() => 
      apiClient.put(ORGANIZER_ENDPOINTS.UPDATE_PROFILE, profileData)
    );
  },

  uploadLogo: async (file) => {
    const formData = new FormData();
    formData.append('file', file);
    return handleAPIResponse(() => 
      apiClient.upload(ORGANIZER_ENDPOINTS.UPLOAD_LOGO, formData)
    );
  },

  getPublicInfo: async (organizerId) => {
    return handleAPIResponse(() => 
      apiClient.get(ORGANIZER_ENDPOINTS.GET_PUBLIC_INFO(organizerId))
    );
  }
};

// Skills Services
export const skillsService = {
  getSkills: async () => {
    return handleAPIResponse(() => 
      apiClient.get(SKILLS_ENDPOINTS.GET_SKILLS)
    );
  },

  createSkill: async (name, category = null) => {
    return handleAPIResponse(() => 
      apiClient.post(SKILLS_ENDPOINTS.CREATE_SKILL, { name, category })
    );
  },

  getCategories: async () => {
    return handleAPIResponse(() => 
      apiClient.get(SKILLS_ENDPOINTS.GET_SKILL_CATEGORIES)
    );
  }
};

// Advert Services
export const advertService = {
  createAdvert: async (advertData, imageFile = null) => {
    const formData = new FormData();
    formData.append('advert_data_json', JSON.stringify(advertData));
    if (imageFile) {
      formData.append('image_file', imageFile);
    }
    return handleAPIResponse(() => 
      apiClient.upload(ADVERT_ENDPOINTS.CREATE_ADVERT, formData)
    );
  },

  listAdverts: async (params = {}) => {
    const url = buildListAdvertsUrl(params);
    return handleAPIResponse(() => 
      apiClient.get(url)
    );
  },

  // Get adverts for the authenticated organization
  getMyAdverts: async (params = { limit: 20, offset: 0 }) => {
    const url = buildListAdvertsUrl(params);
    console.log('Fetching my adverts from URL:', url);
    return handleAPIResponse(() => 
      apiClient.get(url)
    );
  },

  getAdvert: async (advertId) => {
    return handleAPIResponse(() => 
      apiClient.get(ADVERT_ENDPOINTS.GET_ADVERT(advertId))
    );
  },

  updateAdvert: async (advertId, advertData, imageFile = null) => {
    const formData = new FormData();
    formData.append('advert_data_json', JSON.stringify(advertData));
    if (imageFile) {
      formData.append('image_file', imageFile);
    }
    return handleAPIResponse(() => 
      apiClient.upload(ADVERT_ENDPOINTS.UPDATE_ADVERT(advertId), formData)
    );
  },

  deleteAdvert: async (advertId) => {
    return handleAPIResponse(() => 
      apiClient.delete(ADVERT_ENDPOINTS.DELETE_ADVERT(advertId))
    );
  }
};

// Application Services
export const applicationService = {
  applyForAdvert: async (advertId, coverMessage = null) => {
    const requestData = createApplicationCreateRequest(advertId, coverMessage);
    return handleAPIResponse(() => 
      apiClient.post(APPLICATION_ENDPOINTS.APPLY_FOR_ADVERT, requestData)
    );
  },

  getApplication: async (applicationId) => {
    return handleAPIResponse(() => 
      apiClient.get(APPLICATION_ENDPOINTS.GET_APPLICATION(applicationId))
    );
  },

  withdrawApplication: async (applicationId) => {
    return handleAPIResponse(() => 
      apiClient.delete(APPLICATION_ENDPOINTS.WITHDRAW_APPLICATION(applicationId))
    );
  },

  updateApplicationStatus: async (applicationId, status, organizerMessage = null) => {
    const requestData = { status, organizer_message: organizerMessage };
    return handleAPIResponse(() => 
      apiClient.put(APPLICATION_ENDPOINTS.UPDATE_APPLICATION_STATUS(applicationId), requestData)
    );
  }
};

// Utility Services
export const utilityService = {
  healthCheck: async () => {
    return handleAPIResponse(() => 
      apiClient.get(UTILITY_ENDPOINTS.HEALTH)
    );
  },

  getStats: async () => {
    return handleAPIResponse(() => 
      apiClient.get(UTILITY_ENDPOINTS.STATS)
    );
  }
};

// Combined service object for easy importing
export const apiServices = {
  auth: authService,
  volunteer: volunteerService,
  organizer: organizerService,
  skills: skillsService,
  advert: advertService,
  application: applicationService,
  utility: utilityService
};

export default apiServices; 