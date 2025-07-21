import { Job } from '../models/Job';
import { Volunteer } from '../models/Volunteer';
import { Application } from '../models/Application';
// Centralized API logic for switching between local mock and remote API
const API_MODE = import.meta.env.VITE_API_MODE || 'local';
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:4000/api';

// Export mockJobs as a named export
export let mockJobs = [
  Job.fromObject({
    id: 1,
    organizationId: 101,
    title: 'Community Outreach Volunteer',
    description: 'Help organize and run a local community event focused on environmental awareness.',
    category: 'Community Outreach',
    frequency: 'One-off',
    skills: ['Public Speaking', 'Event Planning'],
    timeCommitment: '3–5 hours',
    location: 'Downtown',
    locationType: 'venue',
    volunteersNeeded: 5,
    startDate: '15/07/2024',
    startTime: '10:00',
    deadline: '10/07/2024',
    screeningQuestions: ['Why do you want to volunteer with us?'],
    archived: false,
  }),
  Job.fromObject({
    id: 2,
    organizationId: 102,
    title: 'Digital Campaign Designer',
    description: 'Design graphics and manage social media for our digital campaign.',
    category: 'Digital Campaign',
    frequency: 'Recurring',
    skills: ['Graphic Design', 'Social Media'],
    timeCommitment: '6–10 hours/week',
    location: 'Remote',
    locationType: 'online',
    volunteersNeeded: 2,
    startDate: '01/08/2024',
    startTime: '09:00',
    deadline: '25/07/2024',
    screeningQuestions: ['What specific skills/experience do you bring?'],
    archived: false,
  }),
  Job.fromObject({
    id: 3,
    organizationId: 101,
    title: 'Legal Support Assistant',
    description: 'Assist our legal team in preparing documents and research for upcoming cases.',
    category: 'Legal Support',
    frequency: 'Recurring',
    skills: ['Research', 'Writing'],
    timeCommitment: '1–5 hours/week',
    location: 'City Centre',
    locationType: 'venue',
    volunteersNeeded: 1,
    startDate: '20/07/2024',
    startTime: '14:00',
    deadline: '18/07/2024',
    screeningQuestions: ['Have you volunteered with similar organisations? Please specify which ones and roles.'],
    archived: false,
  }),
  Job.fromObject({
    id: 4,
    organizationId: 103,
    title: 'Fundraising Event Helper',
    description: 'Support our fundraising event by helping with logistics and guest management.',
    category: 'Fundraising',
    frequency: 'One-off',
    skills: ['Logistics/Operations', 'No Skills Required'],
    timeCommitment: '6–10 hours',
    location: 'To Be Announced',
    locationType: 'tba',
    volunteersNeeded: 8,
    startDate: '05/09/2024',
    startTime: '16:00',
    deadline: '01/09/2024',
    screeningQuestions: ['Are you available for training sessions?'],
    archived: false,
  }),
  Job.fromObject({
    id: 5,
    organizationId: 104,
    title: 'Workshop Translator',
    description: 'Translate workshop materials and assist non-English speaking participants.',
    category: 'Educational Workshop',
    frequency: 'One-off',
    skills: ['Translation'],
    timeCommitment: '1–2 hours',
    location: 'Community Hall',
    locationType: 'venue',
    volunteersNeeded: 3,
    startDate: '12/08/2024',
    startTime: '11:30',
    deadline: '05/08/2024',
    screeningQuestions: ['Can you commit to our confidentiality policies?', 'Add your own question: What languages do you speak?'],
    archived: false,
  }),
];

// Mock volunteers
export const mockVolunteers = [
  Volunteer.fromObject({
    id: 201,
    name: 'Alice Smith',
    email: 'alice@example.com',
    skills: ['Graphic Design', 'Writing'],
    description: 'Passionate about activism and design.',
    nickname: 'Bold Tiger',
    rating: 4.8,
  }),
  Volunteer.fromObject({
    id: 202,
    name: 'Bob Lee',
    email: 'bob@example.com',
    skills: ['Translation', 'Research'],
    description: 'Experienced translator and researcher.',
    nickname: 'Brave Leaf',
    rating: 4.5,
  }),
];

// Mock applications
let mockApplications = [
  Application.fromObject({
    id: 301,
    jobId: 1,
    volunteerId: 201,
    answers: [
      { question: 'Why do you want to volunteer with us?', answer: 'I care about the environment.' },
    ],
    status: 'pending',
  }),
  Application.fromObject({
    id: 302,
    jobId: 3,
    volunteerId: 202,
    answers: [
      { question: 'Have you volunteered with similar organisations? Please specify which ones and roles.', answer: 'Yes, with GreenPeace as a translator.' },
    ],
    status: 'pending',
  }),
];

export const fetchApplications = async (orgId) => {
  if (orgId) {
    // Return applications for jobs belonging to this org
    const orgJobIds = mockJobs.filter(j => j.organizationId === orgId).map(j => j.id);
    return mockApplications.filter(app => orgJobIds.includes(app.jobId)).map(Application.fromObject);
  } else {
    // Return all applications
    return mockApplications.map(Application.fromObject);
  }
};

export const updateApplicationStatus = async (appId, status) => {
  mockApplications = mockApplications.map(app =>
    app.id === appId ? Application.fromObject({ ...app, status }) : app
  );
  return mockApplications.find(app => app.id === appId);
};

export const getVolunteerById = (id) => mockVolunteers.find(v => v.id === id);

export const fetchJobs = async () => {
  if (API_MODE === 'local') {
    return mockJobs.map(Job.fromObject);
  } else {
    const res = await fetch(`${API_BASE_URL}/jobs`);
    if (!res.ok) throw new Error('Failed to fetch jobs');
    return res.json();
  }
};

export const updateJob = async (jobId, updatedFields) => {
  if (API_MODE === 'local') {
    mockJobs = mockJobs.map(job => job.id === jobId ? Job.fromObject({ ...job, ...updatedFields }) : job);
    return mockJobs.find(job => job.id === jobId);
  } else {
    throw new Error('Remote update not implemented');
  }
};

export const deleteJob = async (jobId) => {
  if (API_MODE === 'local') {
    mockJobs = mockJobs.map(job => job.id === jobId ? Job.fromObject({ ...job, archived: true }) : job);
    return true;
  } else {
    throw new Error('Remote delete not implemented');
  }
};

export const duplicateJob = async (jobId) => {
  if (API_MODE === 'local') {
    const job = mockJobs.find(j => j.id === jobId);
    if (!job) throw new Error('Job not found');
    const newId = Math.max(...mockJobs.map(j => j.id)) + 1;
    const newJob = Job.fromObject({ ...job, id: newId, title: job.title + ' (Copy)', archived: false });
    mockJobs = [newJob, ...mockJobs];
    return newJob;
  } else {
    throw new Error('Remote duplicate not implemented');
  }
};

export const login = async ({ email, password, role }) => {
  // Mock users
  const users = [
    { email: 'volunteer@example.com', password: 'vol123', role: 'volunteer' },
    { email: 'org@example.com', password: 'org123', role: 'organization' },
  ];
  const user = users.find(
    (u) => u.email === email && u.password === password && u.role === role
  );
  if (user) {
    return { success: true, user: { email: user.email, role: user.role } };
  } else {
    return { success: false, error: 'Invalid credentials' };
  }
};

// Add more API functions (auth, profiles, applications) here 