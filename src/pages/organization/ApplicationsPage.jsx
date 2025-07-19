import React, { useState, useEffect } from 'react';
import OrganizationDashboard from './OrganizationDashboard';
import {
  Box, Typography, Paper, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Button, Dialog, DialogTitle, DialogContent, DialogActions, Avatar, Chip, Stack, Divider
} from '@mui/material';
import { fetchApplications, updateApplicationStatus, getVolunteerById, mockJobs } from '../../api/index.js';
import { useAuth } from '../../contexts/useAuth';

const ApplicationsPageContent = () => {
  const { user } = useAuth();
  const [applications, setApplications] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedVolunteer, setSelectedVolunteer] = useState(null);
  const [profileDialogOpen, setProfileDialogOpen] = useState(false);

  useEffect(() => {
    const load = async () => {
      setLoading(true);
      console.log('Fetching applications for orgId:', user.organizationId);
      const apps = await fetchApplications(user.organizationId);
      console.log('Fetched applications:', apps);
      setApplications(apps);
      setLoading(false);
    };
    load();
  }, [user]);

  const handleStatus = async (appId, status) => {
    await updateApplicationStatus(appId, status);
    setApplications(apps => apps.map(a => a.id === appId ? { ...a, status } : a));
  };

  const handleVolunteerClick = (volunteerId) => {
    setSelectedVolunteer(getVolunteerById(volunteerId));
    setProfileDialogOpen(true);
  };

  const getVolunteerJobsWithOrg = (volId) => {
    // Find jobs this volunteer has done with this org (accepted applications)
    const jobIds = applications.filter(a => a.volunteerId === volId && a.status === 'accepted').map(a => a.jobId);
    return mockJobs.filter(j => jobIds.includes(j.id));
  };

  return (
    <Box maxWidth={950} mx="auto" mt={2}>
      <Paper elevation={3} sx={{ borderRadius: 4, p: 4, background: '#fafbfc' }}>
        <Typography variant="h4" fontWeight="bold" color="primary.main" mb={2} letterSpacing={1}>
          Applications
        </Typography>
        <Divider sx={{ mb: 2 }} />
        {loading ? (
          <Typography>Loading...</Typography>
        ) : (Array.isArray(applications) && applications.length === 0) ? (
          <Typography color="text.secondary">No applications yet.</Typography>
        ) : (Array.isArray(applications) ? (
          <TableContainer component={Paper} elevation={0} sx={{ borderRadius: 3, boxShadow: 'none' }}>
            <Table>
              <TableHead>
                <TableRow sx={{ background: '#f3f6fa' }}>
                  <TableCell sx={{ fontWeight: 700 }}>Volunteer</TableCell>
                  <TableCell sx={{ fontWeight: 700 }}>Job</TableCell>
                  <TableCell sx={{ fontWeight: 700 }}>Screening Q&A</TableCell>
                  <TableCell sx={{ fontWeight: 700 }}>Status</TableCell>
                  <TableCell sx={{ fontWeight: 700 }}>Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {applications.map(app => {
                  const volunteer = getVolunteerById(app.volunteerId);
                  const job = mockJobs.find(j => j.id === app.jobId);
                  return (
                    <TableRow key={app.id}>
                      <TableCell>
                        <Button variant="text" onClick={() => handleVolunteerClick(volunteer.id)}>
                          <Stack direction="row" alignItems="center" spacing={1}>
                            <Avatar>{volunteer.nickname?.[0] || volunteer.name[0]}</Avatar>
                            <span>{volunteer.name}</span>
                          </Stack>
                        </Button>
                      </TableCell>
                      <TableCell>{job?.title}</TableCell>
                      <TableCell>
                        <Stack spacing={1}>
                          {app.answers.map((qa, i) => (
                            <Box key={i}>
                              <Typography variant="body2" fontWeight={600}>{qa.question}</Typography>
                              <Typography variant="body2" color="text.secondary">{qa.answer}</Typography>
                            </Box>
                          ))}
                        </Stack>
                      </TableCell>
                      <TableCell>
                        <Chip
                          label={app.status.charAt(0).toUpperCase() + app.status.slice(1)}
                          color={app.status === 'accepted' ? 'success' : app.status === 'rejected' ? 'error' : 'default'}
                        />
                      </TableCell>
                      <TableCell>
                        <Button
                          variant="contained"
                          color="success"
                          size="small"
                          sx={{ mr: 1 }}
                          disabled={app.status !== 'pending'}
                          onClick={() => handleStatus(app.id, 'accepted')}
                        >
                          Accept
                        </Button>
                        <Button
                          variant="contained"
                          color="error"
                          size="small"
                          disabled={app.status !== 'pending'}
                          onClick={() => handleStatus(app.id, 'rejected')}
                        >
                          Reject
                        </Button>
                      </TableCell>
                    </TableRow>
                  );
                })}
              </TableBody>
            </Table>
          </TableContainer>
        ) : (
          <Typography color="error">Error: Applications data is not an array.</Typography>
        ))}
        {/* Volunteer Profile Dialog */}
        <Dialog open={profileDialogOpen} onClose={() => setProfileDialogOpen(false)} maxWidth="sm" fullWidth>
          <DialogTitle>Volunteer Profile</DialogTitle>
          <DialogContent>
            {selectedVolunteer && (
              <Box>
                <Stack direction="row" alignItems="center" spacing={2} mb={2}>
                  <Avatar sx={{ width: 56, height: 56 }}>{selectedVolunteer.nickname?.[0] || selectedVolunteer.name[0]}</Avatar>
                  <Box>
                    <Typography variant="h6">{selectedVolunteer.nickname}</Typography>
                    <Typography color="text.secondary">{selectedVolunteer.name}</Typography>
                    <Typography color="text.secondary" fontSize={14}>{selectedVolunteer.email}</Typography>
                  </Box>
                </Stack>
                <Typography variant="subtitle1" fontWeight={600}>Description</Typography>
                <Typography mb={2}>{selectedVolunteer.description}</Typography>
                <Typography variant="subtitle1" fontWeight={600}>Skills</Typography>
                <Stack direction="row" spacing={1} mb={2}>
                  {selectedVolunteer.skills.map(skill => (
                    <Chip key={skill} label={skill} />
                  ))}
                </Stack>
                <Typography variant="subtitle1" fontWeight={600}>Previous Jobs with Your Organization</Typography>
                <Stack spacing={1} mb={2}>
                  {getVolunteerJobsWithOrg(selectedVolunteer.id).length === 0 ? (
                    <Typography color="text.secondary">No previous jobs with your organization.</Typography>
                  ) : (
                    getVolunteerJobsWithOrg(selectedVolunteer.id).map(job => (
                      <Typography key={job.id} variant="body2">{job.title}</Typography>
                    ))
                  )}
                </Stack>
                <Typography variant="subtitle1" fontWeight={600}>Rating</Typography>
                <Typography>{selectedVolunteer.rating} / 5</Typography>
              </Box>
            )}
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setProfileDialogOpen(false)}>Close</Button>
          </DialogActions>
        </Dialog>
      </Paper>
    </Box>
  );
};

const ApplicationsPage = ApplicationsPageContent;
export default ApplicationsPage; 