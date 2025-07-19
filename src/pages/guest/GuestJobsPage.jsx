import React, { useEffect, useState } from 'react';
import { fetchJobs } from '../../api/index.js';
import { Box, Typography, Card, CardContent, Button, Stack } from '@mui/material';
import { useNavigate } from 'react-router-dom';

const GuestJobsPage = () => {
  const [jobs, setJobs] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    fetchJobs().then(setJobs);
  }, []);

  return (
    <Box p={4}>
      <Typography variant="h4" mb={3}>Browse Activist Jobs</Typography>
      <Stack spacing={2}>
        {jobs.map(job => (
          <Card key={job.id}>
            <CardContent>
              <Typography variant="h6">{job.title}</Typography>
              <Typography variant="body2">Category: {job.category}</Typography>
              <Typography variant="body2">Frequency: {job.frequency}</Typography>
              <Typography variant="body2">Skills: {job.skills?.join(', ')}</Typography>
              <Typography variant="body2">Time: {job.timeCommitment}</Typography>
              <Typography variant="body2">Location: {job.location}</Typography>
              <Button sx={{ mt: 2 }} variant="contained" onClick={() => navigate('/signup?role=volunteer')}>Apply</Button>
            </CardContent>
          </Card>
        ))}
      </Stack>
    </Box>
  );
};

export default GuestJobsPage; 