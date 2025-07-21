// API Types and Schemas from OpenAPI Specification

// Enums
export const FrequencyType = {
  ONE_OFF: 'one-off',
  RECURRING: 'recurring'
};

export const LocationType = {
  REMOTE: 'remote',
  HYBRID: 'hybrid',
  ON_SITE: 'on-site'
};

export const ApplicationStatus = {
  PENDING: 'pending',
  ACCEPTED: 'accepted',
  REJECTED: 'rejected',
  WITHDRAWN: 'withdrawn'
};

export const TimeCommitment = {
  ONE_TO_TWO_HOURS: '1-2h',
  THREE_TO_FIVE_HOURS: '3-5h',
  SIX_TO_TEN_HOURS: '6-10h',
  TEN_PLUS_HOURS: '10+h'
};

export const DayPeriod = {
  AM: 'am',
  PM: 'pm',
  AFTER_5PM: 'after5pm'
};

export const RecurrenceType = {
  WEEKLY: 'weekly',
  BI_WEEKLY: 'bi-weekly',
  MONTHLY: 'monthly'
};

export const DurationType = {
  ONE_MONTH: '1month',
  THREE_MONTHS: '3months',
  SIX_MONTHS: '6months',
  ONGOING: 'ongoing'
};

// Request Schemas
export const LoginRequest = {
  username: '', // string, required
  password: '', // string, required
  grant_type: null, // string, optional (pattern: "^password$")
  scope: '', // string, default: ""
  client_id: null, // string, optional
  client_secret: null // string, optional
};

export const VolunteerCreateRequest = {
  name: '', // string, required
  email: '', // string, required
  password: '', // string, required
  phone_number: null, // string, optional
  city: null, // string, optional
  country: null, // string, optional
  skill_ids: [] // array of integers, optional, default: []
};

export const VolunteerUpdateRequest = {
  name: '', // string, required
  phone_number: null, // string, optional
  city: null, // string, optional
  country: null, // string, optional
  skill_ids: null // array of integers, optional
};

export const OrganizerCreateRequest = {
  name: '', // string, required
  email: '', // string, required
  password: '', // string, required
  logo_url: null, // string, optional
  website: null, // string, optional
  description: null // string, optional
};

export const OrganizerUpdateRequest = {
  name: '', // string, required
  logo_url: null, // string, optional
  website: null, // string, optional
  description: null // string, optional
};

export const SkillCreateRequest = {
  name: '', // string, required
  category: null // string, optional
};

export const ApplicationCreateRequest = {
  advert_id: 0, // integer, required
  cover_message: null // string, optional
};

export const ApplicationUpdateRequest = {
  status: ApplicationStatus.PENDING, // ApplicationStatus, required
  organizer_message: null // string, optional
};

export const AdvertCreateRequest = {
  title: '', // string, required
  description: '', // string, required
  category: '', // string, required
  frequency: FrequencyType.ONE_OFF, // FrequencyType, required
  number_of_volunteers: 1, // integer, default: 1
  location_type: LocationType.REMOTE, // LocationType, required
  address_text: null, // string, optional
  postcode: null, // string, optional
  latitude: null, // number, optional
  longitude: null, // number, optional
  required_skills: [], // array of skill IDs
  oneoff_details: null, // OneOffAdvertDetails, optional
  recurring_details: null // RecurringAdvertDetails, optional
};

export const OneOffAdvertDetails = {
  event_datetime: '', // string (date-time), required
  time_commitment: TimeCommitment.ONE_TO_TWO_HOURS, // TimeCommitment, required
  application_deadline: '' // string (date-time), required
};

export const RecurringAdvertDetails = {
  recurrence: RecurrenceType.WEEKLY, // RecurrenceType, required
  time_commitment_per_session: TimeCommitment.ONE_TO_TWO_HOURS, // TimeCommitment, required
  duration: DurationType.ONE_MONTH, // DurationType, required
  specific_days: [] // array of RecurringDays, required
};

export const RecurringDays = {
  day: '', // string, required
  periods: [] // array of DayPeriod, required
};

// Response Schemas
export const TokenResponse = {
  access_token: '', // string, required
  token_type: '' // string, required
};

export const VolunteerResponse = {
  id: 0, // integer, required
  name: '', // string, required
  phone_number: null, // string, optional
  city: null, // string, optional
  country: null, // string, optional
  onboarding_completed: false, // boolean, required
  skills: [] // array of SkillResponse, default: []
};

export const OrganizerResponse = {
  id: 0, // integer, required
  name: '', // string, required
  logo_url: null, // string, optional
  website: null, // string, optional
  description: null // string, optional
};

export const SkillResponse = {
  id: 0, // integer, required
  name: '', // string, required
  category: null, // string, optional
  is_predefined: false // boolean, required
};

export const AdvertResponse = {
  id: 0, // integer, required
  title: '', // string, required
  description: '', // string, required
  category: '', // string, required
  frequency: FrequencyType.ONE_OFF, // FrequencyType, required
  number_of_volunteers: 1, // integer, default: 1
  location_type: LocationType.REMOTE, // LocationType, required
  address_text: null, // string, optional
  postcode: null, // string, optional
  latitude: null, // number, optional
  longitude: null, // number, optional
  advert_image_url: null, // string, optional
  is_active: true, // boolean, required
  organizer: null, // OrganizerResponse, required
  required_skills: [], // array of SkillResponse, default: []
  oneoff_details: null, // OneOffAdvertDetails, optional
  recurring_details: null, // RecurringAdvertDetails, optional
  created_at: '' // string (date-time), required
};

export const ApplicationResponse = {
  id: 0, // integer, required
  advert_id: 0, // integer, required
  cover_message: null, // string, optional
  status: ApplicationStatus.PENDING, // ApplicationStatus, required
  applied_at: '', // string (date-time), required
  advert: null, // AdvertResponse, required
  volunteer: null // VolunteerResponse, optional
};

export const ValidationError = {
  loc: [], // array of string/integer, required
  msg: '', // string, required
  type: '' // string, required
};

export const HTTPValidationError = {
  detail: [] // array of ValidationError, optional
};

// Helper functions for creating request objects
export const createLoginRequest = (username, password) => ({
  grant_type: 'password',
  username,
  password,
  scope: '',
  client_id: 'string',
  client_secret: '********'
});

export const createVolunteerCreateRequest = (name, email, password, options = {}) => ({
  name,
  email,
  password,
  phone_number: options.phone_number || null,
  city: options.city || null,
  country: options.country || null,
  skill_ids: options.skill_ids || []
});

export const createOrganizerCreateRequest = (name, email, password, options = {}) => ({
  name,
  email,
  password,
  logo_url: options.logo_url || null,
  website: options.website || null,
  description: options.description || null
});

export const createApplicationCreateRequest = (advert_id, cover_message = null) => ({
  advert_id,
  cover_message
});

export const createAdvertCreateRequest = (title, description, category, frequency, location_type, options = {}) => ({
  title,
  description,
  category,
  frequency,
  location_type,
  number_of_volunteers: options.number_of_volunteers || 1,
  address_text: options.address_text || null,
  postcode: options.postcode || null,
  latitude: options.latitude || null,
  longitude: options.longitude || null,
  required_skills: options.required_skills || [],
  oneoff_details: options.oneoff_details || null,
  recurring_details: options.recurring_details || null
}); 