import React, { useState } from 'react';
import { Box, Typography, Paper, Stack, Card, CardContent, Button, TextField, MenuItem, FormControl, InputLabel, Select, Divider, Drawer, List, ListItemButton, ListItemIcon, ListItemText } from '@mui/material';
import { mockJobs, fetchApplications } from '../../api/index.js';
import { useAuth } from '../../contexts/useAuth';
import { useNavigate, useLocation } from 'react-router-dom';
import VolunteerSideMenu from './VolunteerSideMenu';

const categories = [
  'All',
  'Protest/Rally',
  'Digital Campaign',
  'Community Outreach',
  'Educational Workshop',
  'Fundraising',
  'Media/Communications',
  'Legal Support',
  'Logistics/Operations',
  'Other',
];
const frequencies = ['All', 'One-off', 'Recurring'];

const VolunteerMyJobsPage = () => {
  const { user } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const [search, setSearch] = useState('');
  const [category, setCategory] = useState('All');
  const [frequency, setFrequency] = useState('All');
  const [applications, setApplications] = useState([]);

  React.useEffect(() => {
    if (user) {
      fetchApplications().then(apps => {
        setApplications(apps.filter(a => a.volunteerId === user.id));
      });
    }
  }, [user]);

  const jobsWithStatus = applications.map(app => {
    const job = mockJobs.find(j => j.id === app.jobId);
    return job ? { ...job, status: app.status } : null;
  }).filter(Boolean);

  const filteredJobs = jobsWithStatus.filter(job => {
    const matchesSearch = job.title.toLowerCase().includes(search.toLowerCase()) || job.description.toLowerCase().includes(search.toLowerCase());
    const matchesCategory = category === 'All' || job.category === category;
    const matchesFrequency = frequency === 'All' || job.frequency === frequency;
    return matchesSearch && matchesCategory && matchesFrequency;
  });

  const activeJobs = filteredJobs.filter(j => j.status === 'pending' || j.status === 'accepted');
  const completedJobs = filteredJobs.filter(j => j.status === 'completed' || j.status === 'rejected');

  return (
    <Box display="flex">
      <VolunteerSideMenu selectedPath={location.pathname} />
      <Box component="main" flex={1} p={4} ml={2}>
        <Box maxWidth={950} mx="auto" mt={4}>
          <Paper elevation={3} sx={{ borderRadius: 4, p: 4, background: '#fafbfc' }}>
            <Typography variant="h4" mb={3}>My Jobs</Typography>
            <Stack direction={{ xs: 'column', md: 'row' }} spacing={2} mb={3}>
              <TextField
                label="Search jobs"
                value={search}
                onChange={e => setSearch(e.target.value)}
                sx={{ minWidth: 200 }}
              />
              <FormControl sx={{ minWidth: 180 }}>
                <InputLabel>Category</InputLabel>
                <Select value={category} label="Category" onChange={e => setCategory(e.target.value)}>
                  {categories.map(cat => (
                    <MenuItem key={cat} value={cat}>{cat}</MenuItem>
                  ))}
                </Select>
              </FormControl>
              <FormControl sx={{ minWidth: 180 }}>
                <InputLabel>Frequency</InputLabel>
                <Select value={frequency} label="Frequency" onChange={e => setFrequency(e.target.value)}>
                  {frequencies.map(freq => (
                    <MenuItem key={freq} value={freq}>{freq}</MenuItem>
                  ))}
                </Select>
              </FormControl>
            </Stack>
            <Typography variant="h6" mt={2} mb={1}>Active Jobs</Typography>
            <Divider sx={{ mb: 2 }} />
            <Stack spacing={2} mb={4}>
              {activeJobs.length === 0 && <Typography color="text.secondary">No active jobs.</Typography>}
              {activeJobs.map(job => (
                <Card key={job.id} sx={{ cursor: 'pointer' }} onClick={() => navigate(`/volunteer/jobs/${job.id}`)}>
                  <CardContent>
                    <Typography variant="h6">{job.title}</Typography>
                    <Typography variant="body2">Category: {job.category}</Typography>
                    <Typography variant="body2">Frequency: {job.frequency}</Typography>
                    <Typography variant="body2">Status: {job.status}</Typography>
                    <Typography variant="body2">Time: {job.timeCommitment}</Typography>
                    <Typography variant="body2">Location: {job.location}</Typography>
                    <Button sx={{ mt: 2 }} variant="contained" onClick={e => { e.stopPropagation(); navigate(`/volunteer/jobs/${job.id}`); }}>View Details</Button>
                  </CardContent>
                </Card>
              ))}
            </Stack>
            <Typography variant="h6" mt={2} mb={1}>Completed/Rejected Jobs</Typography>
            <Divider sx={{ mb: 2 }} />
            <Stack spacing={2}>
              {completedJobs.length === 0 && <Typography color="text.secondary">No completed or rejected jobs.</Typography>}
              {completedJobs.map(job => (
                <Card key={job.id} sx={{ cursor: 'pointer' }} onClick={() => navigate(`/volunteer/jobs/${job.id}`)}>
                  <CardContent>
                    <Typography variant="h6">{job.title}</Typography>
                    <Typography variant="body2">Category: {job.category}</Typography>
                    <Typography variant="body2">Frequency: {job.frequency}</Typography>
                    <Typography variant="body2">Status: {job.status}</Typography>
                    <Typography variant="body2">Time: {job.timeCommitment}</Typography>
                    <Typography variant="body2">Location: {job.location}</Typography>
                    <Button sx={{ mt: 2 }} variant="contained" onClick={e => { e.stopPropagation(); navigate(`/volunteer/jobs/${job.id}`); }}>View Details</Button>
                  </CardContent>
                </Card>
              ))}
            </Stack>
          </Paper>
        </Box>
      </Box>
    </Box>
  );
};

export default VolunteerMyJobsPage; 