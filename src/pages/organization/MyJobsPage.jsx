import React, { useEffect, useState } from 'react';
import { fetchJobs, updateJob, deleteJob, duplicateJob } from '../../api/index.js';
import { useAuth } from '../../contexts/useAuth';
import {
  Box, Typography, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Paper, Button, CircularProgress, Dialog, DialogTitle, DialogContent, DialogActions, TextField, MenuItem, Select, InputLabel, FormControl, Snackbar, Alert, DialogContentText, Tabs, Tab, Divider
} from '@mui/material';
import OrganizationDashboard from './OrganizationDashboard';

const categories = [
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

const MyJobsPageContent = () => {
  const { user } = useAuth();
  const [jobs, setJobs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [editJob, setEditJob] = useState(null);
  const [editFields, setEditFields] = useState({});
  const [editDialogOpen, setEditDialogOpen] = useState(false);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [jobToDelete, setJobToDelete] = useState(null);
  const [snackbar, setSnackbar] = useState({ open: false, message: '', severity: 'success' });
  const [tab, setTab] = useState(0); // 0: Active, 1: Archived

  const loadJobs = async () => {
    setLoading(true);
    try {
      const allJobs = await fetchJobs();
      const orgJobs = allJobs.filter(job => job.organizationId === user?.organizationId);
      setJobs(orgJobs);
    } catch {
      setError('Failed to load jobs');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadJobs();
    // eslint-disable-next-line
  }, [user]);

  const handleEditClick = (job) => {
    setEditJob(job);
    setEditFields({
      title: job.title,
      description: job.description,
      category: job.category,
      frequency: job.frequency,
      volunteersNeeded: job.volunteersNeeded,
    });
    setEditDialogOpen(true);
  };

  const handleEditFieldChange = (e) => {
    setEditFields({ ...editFields, [e.target.name]: e.target.value });
  };

  const handleEditSave = async () => {
    await updateJob(editJob.id, editFields);
    setEditDialogOpen(false);
    setSnackbar({ open: true, message: 'Job updated!', severity: 'success' });
    loadJobs();
  };

  const handleDeleteClick = (job) => {
    setJobToDelete(job);
    setDeleteDialogOpen(true);
  };

  const handleDeleteConfirm = async () => {
    await deleteJob(jobToDelete.id);
    setDeleteDialogOpen(false);
    setSnackbar({ open: true, message: 'Job archived!', severity: 'info' });
    setJobToDelete(null);
    loadJobs();
  };

  const handleDuplicate = async (job) => {
    await duplicateJob(job.id);
    setSnackbar({ open: true, message: 'Job duplicated!', severity: 'success' });
    loadJobs();
  };

  const handleTabChange = (_, newValue) => setTab(newValue);

  const activeJobs = jobs.filter(j => !j.archived);
  const archivedJobs = jobs.filter(j => j.archived);

  if (loading) return <Box display="flex" justifyContent="center" mt={4}><CircularProgress /></Box>;
  if (error) return <Typography color="error">{error}</Typography>;

  return (
    <Box maxWidth={950} mx="auto" mt={2}>
      <Paper elevation={3} sx={{ borderRadius: 4, p: 4, background: '#fafbfc' }}>
        <Typography variant="h4" fontWeight="bold" color="primary.main" mb={2} letterSpacing={1}>
          My Jobs
        </Typography>
        <Divider sx={{ mb: 2 }} />
        <Tabs
          value={tab}
          onChange={handleTabChange}
          sx={{ mb: 3, '.MuiTabs-indicator': { height: 4, borderRadius: 2 } }}
          textColor="primary"
          indicatorColor="primary"
        >
          <Tab label="Active Jobs" sx={{ fontWeight: 600, fontSize: 16 }} />
          <Tab label="Archived Jobs" sx={{ fontWeight: 600, fontSize: 16 }} />
        </Tabs>
        {tab === 0 ? (
          activeJobs.length === 0 ? (
            <Typography color="text.secondary">No active jobs found. Create a job to get started!</Typography>
          ) : (
            <TableContainer component={Paper} elevation={0} sx={{ borderRadius: 3, boxShadow: 'none' }}>
              <Table>
                <TableHead>
                  <TableRow sx={{ background: '#f3f6fa' }}>
                    <TableCell sx={{ fontWeight: 700 }}>Title</TableCell>
                    <TableCell sx={{ fontWeight: 700 }}>Category</TableCell>
                    <TableCell sx={{ fontWeight: 700 }}>Frequency</TableCell>
                    <TableCell sx={{ fontWeight: 700 }}>Volunteers Needed</TableCell>
                    <TableCell sx={{ fontWeight: 700 }}>Start Date</TableCell>
                    <TableCell sx={{ fontWeight: 700 }}>Actions</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {activeJobs.map(job => (
                    <TableRow
                      key={job.id}
                      sx={{
                        transition: 'background 0.2s',
                        '&:hover': { background: '#f5f7fa' },
                      }}
                    >
                      <TableCell>{job.title}</TableCell>
                      <TableCell>{job.category}</TableCell>
                      <TableCell>{job.frequency}</TableCell>
                      <TableCell>{job.volunteersNeeded}</TableCell>
                      <TableCell>{job.startDate}</TableCell>
                      <TableCell>
                        <Button variant="outlined" size="small" onClick={() => handleEditClick(job)} sx={{ mr: 1 }}>Edit</Button>
                        <Button variant="outlined" color="error" size="small" onClick={() => handleDeleteClick(job)} sx={{ mr: 1 }}>Archive</Button>
                        <Button variant="outlined" color="secondary" size="small" onClick={() => handleDuplicate(job)}>Duplicate</Button>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          )
        ) : (
          archivedJobs.length === 0 ? (
            <Typography color="text.secondary">No archived jobs.</Typography>
          ) : (
            <TableContainer component={Paper} elevation={0} sx={{ borderRadius: 3, boxShadow: 'none' }}>
              <Table>
                <TableHead>
                  <TableRow sx={{ background: '#f3f6fa' }}>
                    <TableCell sx={{ fontWeight: 700 }}>Title</TableCell>
                    <TableCell sx={{ fontWeight: 700 }}>Category</TableCell>
                    <TableCell sx={{ fontWeight: 700 }}>Frequency</TableCell>
                    <TableCell sx={{ fontWeight: 700 }}>Volunteers Needed</TableCell>
                    <TableCell sx={{ fontWeight: 700 }}>Start Date</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {archivedJobs.map(job => (
                    <TableRow
                      key={job.id}
                      sx={{
                        transition: 'background 0.2s',
                        '&:hover': { background: '#f8f8f8' },
                      }}
                    >
                      <TableCell>{job.title}</TableCell>
                      <TableCell>{job.category}</TableCell>
                      <TableCell>{job.frequency}</TableCell>
                      <TableCell>{job.volunteersNeeded}</TableCell>
                      <TableCell>{job.startDate}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          )
        )}
        {/* Edit Dialog */}
        <Dialog open={editDialogOpen} onClose={() => setEditDialogOpen(false)}>
          <DialogTitle>Edit Job</DialogTitle>
          <DialogContent>
            <TextField
              margin="dense"
              label="Title"
              name="title"
              value={editFields.title || ''}
              onChange={handleEditFieldChange}
              fullWidth
            />
            <TextField
              margin="dense"
              label="Description"
              name="description"
              value={editFields.description || ''}
              onChange={handleEditFieldChange}
              fullWidth
              multiline
              minRows={2}
            />
            <FormControl fullWidth margin="dense">
              <InputLabel>Category</InputLabel>
              <Select
                name="category"
                value={editFields.category || ''}
                label="Category"
                onChange={handleEditFieldChange}
              >
                {categories.map(cat => (
                  <MenuItem key={cat} value={cat}>{cat}</MenuItem>
                ))}
              </Select>
            </FormControl>
            <FormControl fullWidth margin="dense">
              <InputLabel>Frequency</InputLabel>
              <Select
                name="frequency"
                value={editFields.frequency || ''}
                label="Frequency"
                onChange={handleEditFieldChange}
              >
                <MenuItem value="One-off">One-off</MenuItem>
                <MenuItem value="Recurring">Recurring</MenuItem>
              </Select>
            </FormControl>
            <TextField
              margin="dense"
              label="Volunteers Needed"
              name="volunteersNeeded"
              type="number"
              value={editFields.volunteersNeeded || ''}
              onChange={handleEditFieldChange}
              fullWidth
              inputProps={{ min: 1 }}
            />
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setEditDialogOpen(false)}>Cancel</Button>
            <Button onClick={handleEditSave} variant="contained">Save</Button>
          </DialogActions>
        </Dialog>
        {/* Delete Confirmation Dialog */}
        <Dialog open={deleteDialogOpen} onClose={() => setDeleteDialogOpen(false)}>
          <DialogTitle>Archive Job</DialogTitle>
          <DialogContent>
            <DialogContentText>
              Are you sure you want to archive the job "{jobToDelete?.title}"? This action can be undone by restoring from the database (future feature).
            </DialogContentText>
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setDeleteDialogOpen(false)}>Cancel</Button>
            <Button onClick={handleDeleteConfirm} color="error" variant="contained">Archive</Button>
          </DialogActions>
        </Dialog>
        {/* Snackbar for feedback */}
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

const MyJobsPage = MyJobsPageContent;
export default MyJobsPage; 