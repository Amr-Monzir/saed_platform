import React from 'react';
import { useParams, useNavigate, useLocation } from 'react-router-dom';
import { Box, Typography, Paper, Stack, Divider, Link, Button, Drawer, List, ListItemButton, ListItemIcon, ListItemText } from '@mui/material';
import { mockJobs } from '../../api/index.js';
import VolunteerSideMenu from './VolunteerSideMenu';

// Mock organizer info (in real app, fetch from API)
const mockOrgs = {
  101: {
    name: 'Green Earth Org',
    description: 'A non-profit focused on environmental awareness and community outreach.',
    website: 'https://greenearth.org',
    facebook: 'https://facebook.com/greenearth',
    twitter: 'https://twitter.com/greenearth',
  },
  102: {
    name: 'Digital Campaigners',
    description: 'Driving change through digital activism and creative campaigns.',
    website: 'https://digitalcampaigners.org',
    facebook: 'https://facebook.com/digitalcampaigners',
    twitter: 'https://twitter.com/digicampaigners',
  },
  103: {
    name: 'Fundraising Friends',
    description: 'Supporting causes through effective fundraising events.',
    website: 'https://fundraisingfriends.org',
    facebook: 'https://facebook.com/fundraisingfriends',
    twitter: 'https://twitter.com/fundfriends',
  },
  104: {
    name: 'Workshop Wizards',
    description: 'Empowering communities with educational workshops.',
    website: 'https://workshopwizards.org',
    facebook: 'https://facebook.com/workshopwizards',
    twitter: 'https://twitter.com/workshopwizards',
  },
};

const VolunteerJobDetailsPage = () => {
  const { jobId } = useParams();
  const navigate = useNavigate();
  const location = useLocation();
  const job = mockJobs.find(j => String(j.id) === String(jobId));
  const org = job ? mockOrgs[job.organizationId] : null;

  if (!job) {
    return <Typography color="error">Job not found.</Typography>;
  }

  return (
    <Box display="flex">
      <VolunteerSideMenu selectedPath={location.pathname} />
      <Box component="main" flex={1} p={4} ml={2}>
        <Box maxWidth={1000} mx="auto" mt={4}>
          <Paper elevation={3} sx={{ p: 4 }}>
            <Button variant="outlined" sx={{ mb: 2 }} onClick={() => navigate(-1)}>
              Back
            </Button>
            <Stack direction={{ xs: 'column', md: 'row' }} spacing={4}>
              {/* Job Details */}
              <Box flex={2}>
                <Typography variant="h5" fontWeight="bold" mb={2}>{job.title}</Typography>
                <Divider sx={{ mb: 2 }} />
                <Typography variant="body1" mb={2}>{job.description}</Typography>
                <Typography variant="subtitle1" fontWeight={600}>Category:</Typography>
                <Typography mb={1}>{job.category}</Typography>
                <Typography variant="subtitle1" fontWeight={600}>Frequency:</Typography>
                <Typography mb={1}>{job.frequency}</Typography>
                <Typography variant="subtitle1" fontWeight={600}>Skills Required:</Typography>
                <Typography mb={1}>{job.skills?.join(', ')}</Typography>
                <Typography variant="subtitle1" fontWeight={600}>Time Commitment:</Typography>
                <Typography mb={1}>{job.timeCommitment}</Typography>
                <Typography variant="subtitle1" fontWeight={600}>Location:</Typography>
                <Typography mb={1}>{job.location}</Typography>
                <Typography variant="subtitle1" fontWeight={600}>Start Date:</Typography>
                <Typography mb={1}>{job.startDate} {job.startTime}</Typography>
                <Typography variant="subtitle1" fontWeight={600}>Application Deadline:</Typography>
                <Typography mb={1}>{job.deadline}</Typography>
                <Typography variant="subtitle1" fontWeight={600}>Screening Questions:</Typography>
                <Typography mb={1}>{job.screeningQuestions?.join(' | ')}</Typography>
              </Box>
              {/* Organizer Details */}
              <Box flex={1} bgcolor="#f7f7f7" p={3} borderRadius={2}>
                <Typography variant="h6" fontWeight="bold" mb={1}>Organizer</Typography>
                {org ? (
                  <>
                    <Typography variant="subtitle1" fontWeight={600}>{org.name}</Typography>
                    <Typography mb={2}>{org.description}</Typography>
                    <Typography variant="subtitle2">Website:</Typography>
                    <Link href={org.website} target="_blank" rel="noopener">{org.website}</Link>
                    <Typography variant="subtitle2" mt={2}>Social Media:</Typography>
                    <Stack direction="row" spacing={2} mt={1}>
                      <Link href={org.facebook} target="_blank" rel="noopener">Facebook</Link>
                      <Link href={org.twitter} target="_blank" rel="noopener">Twitter</Link>
                    </Stack>
                  </>
                ) : (
                  <Typography color="text.secondary">Organizer info not available.</Typography>
                )}
              </Box>
            </Stack>
          </Paper>
        </Box>
      </Box>
    </Box>
  );
};

export default VolunteerJobDetailsPage; 