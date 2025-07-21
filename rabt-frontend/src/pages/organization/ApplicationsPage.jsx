import React, { useState, useEffect } from 'react';
import OrganizationDashboard from './OrganizationDashboard';
import {
  Box, Typography, Paper, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Button, Dialog, DialogTitle, DialogContent, DialogActions, Avatar, Chip, Stack, Divider, TextField, Snackbar, Alert
} from '@mui/material';
import { fetchApplications, updateApplicationStatus, getVolunteerById, mockJobs } from '../../api/index.js';
import { useAuth } from '../../contexts/useAuth';

const ApplicationsPageContent = () => {
  const { user } = useAuth();
  const [applications, setApplications] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedVolunteer, setSelectedVolunteer] = useState(null);
  const [profileDialogOpen, setProfileDialogOpen] = useState(false);
  // Email dialog state
  const [emailDialogOpen, setEmailDialogOpen] = useState(false);
  const [emailSubject, setEmailSubject] = useState('');
  const [emailBody, setEmailBody] = useState('');
  const [emailAction, setEmailAction] = useState(null); // 'accepted' or 'rejected'
  const [emailAppId, setEmailAppId] = useState(null);
  const [emailVolunteerEmail, setEmailVolunteerEmail] = useState('');
  const [snackbar, setSnackbar] = useState({ open: false, message: '', severity: 'success' });

  useEffect(() => {
    const load = async () => {
      setLoading(true);
      const apps = await fetchApplications(user.organizationId);
      setApplications(apps);
      setLoading(false);
    };
    load();
  }, [user]);

  const handleStatus = async (appId, status) => {
    // Find app, volunteer, job
    const app = applications.find(a => a.id === appId);
    const volunteer = getVolunteerById(app.volunteerId);
    const job = mockJobs.find(j => j.id === app.jobId);
    // Prepare default email
    let subject = '';
    let body = '';
    if (status === 'accepted') {
      subject = `Congratulations! Your Application Has Been Accepted`;
      body = `Dear ${volunteer.name},\n\nWe are pleased to inform you that your application for the position of '${job.title}' has been accepted. We look forward to working with you!\n\nBest regards,\n${user.name || 'The Organization Team'}`;
    } else {
      subject = `Update on Your Application`;
      body = `Dear ${volunteer.name},\n\nThank you for applying for the position of '${job.title}'. We regret to inform you that your application was not selected at this time. We appreciate your interest and encourage you to apply for future opportunities.\n\nBest regards,\n${user.name || 'The Organization Team'}`;
    }
    setEmailSubject(subject);
    setEmailBody(body);
    setEmailAction(status);
    setEmailAppId(appId);
    setEmailVolunteerEmail(volunteer.email);
    setEmailDialogOpen(true);
  };

  const handleSendEmail = async () => {
    // Open mail client with mailto link
    const mailto = `mailto:${encodeURIComponent(emailVolunteerEmail)}?subject=${encodeURIComponent(emailSubject)}&body=${encodeURIComponent(emailBody)}`;
    window.location.href = mailto;
    setEmailDialogOpen(false);
    setSnackbar({ open: true, message: 'Mail client opened for volunteer email!', severity: 'success' });
    // Now update application status
    await updateApplicationStatus(emailAppId, emailAction);
    setApplications(apps => apps.map(a => a.id === emailAppId ? { ...a, status: emailAction } : a));
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
        {/* Email Dialog */}
        <Dialog open={emailDialogOpen} onClose={() => setEmailDialogOpen(false)} maxWidth="sm" fullWidth>
          <DialogTitle>Email to Volunteer</DialogTitle>
          <DialogContent>
            <TextField
              label="Subject"
              value={emailSubject}
              onChange={e => setEmailSubject(e.target.value)}
              fullWidth
              margin="normal"
            />
            <TextField
              label="Body"
              value={emailBody}
              onChange={e => setEmailBody(e.target.value)}
              fullWidth
              margin="normal"
              multiline
              minRows={6}
            />
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setEmailDialogOpen(false)}>Cancel</Button>
            <Button variant="contained" onClick={handleSendEmail}>Send</Button>
          </DialogActions>
        </Dialog>
        <Snackbar
          open={snackbar.open}
          autoHideDuration={3000}
          onClose={() => setSnackbar({ ...snackbar, open: false })}
          anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
        >
          <Alert severity={snackbar.severity} sx={{ width: '100%' }}>{snackbar.message}</Alert>
        </Snackbar>
      </Paper>
    </Box>
  );
};

const ApplicationsPage = ApplicationsPageContent;
export default ApplicationsPage; 