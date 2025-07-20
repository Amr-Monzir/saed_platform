import React, { useEffect, useState } from 'react';
import { fetchJobs, updateJob, deleteJob, duplicateJob } from '../../api/index.js';
import { useAuth } from '../../contexts/useAuth';
import {
  Box, 
  Typography, 
  Button, 
  CircularProgress, 
  Dialog, 
  DialogTitle, 
  DialogContent, 
  DialogActions, 
  TextField, 
  MenuItem, 
  Select, 
  InputLabel, 
  FormControl, 
  Snackbar, 
  Alert, 
  DialogContentText,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Chip,
  IconButton,
  Menu,
  Stack,
  Collapse,
  Slider,
  Drawer
} from '@mui/material';
import {
  Search,
  FilterList,
  Sort,
  MoreVert,
  Edit,
  Delete,
  FileCopy,
  ExpandMore,
  ExpandLess,
  Close
} from '@mui/icons-material';

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

const skillsOptions = [
  'Graphic Design',
  'Social Media',
  'Translation',
  'Public Speaking',
  'Event Planning',
  'Photography',
  'Writing',
  'Research',
  'Other',
  'No Skills Required',
];

const daysOfWeekOptions = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
];

const timeCommitmentOptions = [
  '1–2 hours', '3–5 hours', '6–10 hours', '10+ hours'
];



const statusOptions = [
  'Draft', 'Published', 'Archived', 'Paused'
];

// Filter Chip Component
const FilterChip = ({ label, selected, onClick }) => (
  <Chip
    label={label}
    onClick={onClick}
    variant={selected ? 'filled' : 'outlined'}
    color={selected ? 'primary' : 'default'}
    size="small"
    sx={{ 
      mr: 1, 
      mb: 1,
      backgroundColor: selected ? '#1976d2' : 'transparent',
      color: selected ? 'white' : 'text.primary',
      '&:hover': {
        backgroundColor: selected ? '#1565c0' : '#f5f5f5'
      }
    }}
  />
);

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
  const [anchorEl, setAnchorEl] = useState(null);
  const [selectedJob, setSelectedJob] = useState(null);
  
  // Filter and search states
  const [search, setSearch] = useState('');
  const [sortBy, setSortBy] = useState('Recent');
  const [filtersOpen, setFiltersOpen] = useState(false);
  const [locationFilter, setLocationFilter] = useState('');
  const [searchRadius, setSearchRadius] = useState([1]);
  const [dateFilter, setDateFilter] = useState('');
  const [frequencyFilter, setFrequencyFilter] = useState([]);
  const [skillsFilter, setSkillsFilter] = useState([]);
  const [categoryFilter, setCategoryFilter] = useState([]);
  const [daysFilter, setDaysFilter] = useState([]);
  const [timeCommitmentFilter, setTimeCommitmentFilter] = useState([]);

  const [statusFilter, setStatusFilter] = useState([]);
  
  // Expandable filter sections
  const [categoryExpanded, setCategoryExpanded] = useState(false);
  const [daysExpanded, setDaysExpanded] = useState(false);
  const [timeCommitmentExpanded, setTimeCommitmentExpanded] = useState(false);

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

  const handleMenuClick = (event, job) => {
    setAnchorEl(event.currentTarget);
    setSelectedJob(job);
  };

  const handleMenuClose = () => {
    setAnchorEl(null);
    setSelectedJob(null);
  };

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
    handleMenuClose();
  };

  const handleEditFieldChange = (e) => {
    setEditFields({ ...editFields, [e.target.name]: e.target.value });
  };

  const handleEditSave = async () => {
    try {
      await updateJob(editJob.id, editFields);
      setSnackbar({ open: true, message: 'Job updated successfully!', severity: 'success' });
      setEditDialogOpen(false);
      loadJobs();
    } catch {
      setSnackbar({ open: true, message: 'Failed to update job', severity: 'error' });
    }
  };

  const handleDeleteClick = (job) => {
    setJobToDelete(job);
    setDeleteDialogOpen(true);
    handleMenuClose();
  };

  const handleDeleteConfirm = async () => {
    try {
      await deleteJob(jobToDelete.id);
      setSnackbar({ open: true, message: 'Job deleted successfully!', severity: 'success' });
      setDeleteDialogOpen(false);
      loadJobs();
    } catch {
      setSnackbar({ open: true, message: 'Failed to delete job', severity: 'error' });
    }
  };

  const handleDuplicateClick = async (job) => {
    try {
      await duplicateJob(job.id);
      setSnackbar({ open: true, message: 'Job duplicated successfully!', severity: 'success' });
      loadJobs();
    } catch {
      setSnackbar({ open: true, message: 'Failed to duplicate job', severity: 'error' });
    }
    handleMenuClose();
  };

  const clearAllFilters = () => {
    setSearch('');
    setLocationFilter('');
    setSearchRadius([1]);
    setDateFilter('');
    setFrequencyFilter([]);
    setSkillsFilter([]);
    setCategoryFilter([]);
    setDaysFilter([]);
    setTimeCommitmentFilter([]);
    setStatusFilter([]);
  };

  const filteredJobs = jobs.filter(job => {
    const matchesSearch = job.title.toLowerCase().includes(search.toLowerCase()) ||
                         job.description.toLowerCase().includes(search.toLowerCase());
    const matchesLocation = !locationFilter || (job.location && job.location.toLowerCase().includes(locationFilter.toLowerCase()));
    const matchesFrequency = frequencyFilter.length === 0 || frequencyFilter.includes(job.frequency);
    const matchesSkills = skillsFilter.length === 0 || (job.skills && job.skills.some(skill => skillsFilter.includes(skill)));
    const matchesCategory = categoryFilter.length === 0 || categoryFilter.includes(job.category);
    const matchesDays = daysFilter.length === 0 || (job.daysOfWeek && job.daysOfWeek.some(day => daysFilter.includes(day)));
    const matchesTimeCommitment = timeCommitmentFilter.length === 0 || timeCommitmentFilter.includes(job.timeCommitment);

    const matchesStatus = statusFilter.length === 0 || statusFilter.includes(job.status || 'Published');
    
    return matchesSearch && matchesLocation && matchesFrequency && matchesSkills && 
           matchesCategory && matchesDays && matchesTimeCommitment && matchesStatus;
  });

  const getStatusChip = (job) => {
    // Mock status logic - consistent based on job ID to prevent random changes
    const isDraft = job.status === 'Draft' || (job.id % 3 === 0); // Consistent based on job ID
    return isDraft ? (
      <Chip 
        label="Draft" 
        size="small" 
        sx={{ 
          backgroundColor: '#f3f4f6', 
          color: '#6b7280',
          fontWeight: 500
        }} 
      />
    ) : (
      <Chip 
        label="Published" 
        size="small" 
        sx={{ 
          backgroundColor: '#dcfce7', 
          color: '#16a34a',
          fontWeight: 500
        }} 
      />
    );
  };

  const formatDate = () => {
    // Mock date formatting - would use actual job dates
    return "18 July";
  };

  if (loading) return <CircularProgress />;
  if (error) return <Typography color="error">{error}</Typography>;

  return (
    <Box sx={{ p: 4 }}>
      {/* Header */}
      <Typography variant="h4" fontWeight="bold" mb={4}>
        Roles and events
      </Typography>

      {/* Search and Filter Bar */}
      <Stack direction="row" spacing={2} mb={3}>
        <TextField
          placeholder="Search for a role/event"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          sx={{ 
            flexGrow: 1,
            backgroundColor: 'white',
            '& .MuiOutlinedInput-root': {
              borderRadius: 2
            }
          }}
          InputProps={{
            startAdornment: <Search sx={{ color: '#9ca3af', mr: 1 }} />
          }}
        />
        
        <Button
          variant="outlined"
          startIcon={<Sort />}
          onClick={() => setSortBy(sortBy === 'Recent' ? 'Alphabetical' : 'Recent')}
          sx={{ 
            borderColor: '#e5e7eb',
            color: '#6b7280',
            backgroundColor: 'white',
            minWidth: 120
          }}
        >
          Sort by {sortBy}
        </Button>
        
        <Button
          variant="outlined"
          startIcon={<FilterList />}
          onClick={() => setFiltersOpen(true)}
          sx={{ 
            borderColor: '#e5e7eb',
            color: '#6b7280',
            backgroundColor: 'white',
            minWidth: 100
          }}
        >
          Filters
        </Button>
      </Stack>

      {/* Jobs Table */}
      <TableContainer component={Paper} sx={{ borderRadius: 2, boxShadow: '0 1px 3px 0 rgb(0 0 0 / 0.1)' }}>
        <Table>
          <TableHead>
            <TableRow sx={{ backgroundColor: '#f9fafb' }}>
              <TableCell sx={{ fontWeight: 600, color: '#374151', py: 2 }}>Event</TableCell>
              <TableCell sx={{ fontWeight: 600, color: '#374151', py: 2 }}>Status</TableCell>
              <TableCell sx={{ width: 60 }}></TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {filteredJobs.map((job) => (
              <TableRow 
                key={job.id}
                sx={{ 
                  '&:hover': { backgroundColor: '#f9fafb' },
                  borderBottom: '1px solid #f3f4f6'
                }}
              >
                <TableCell sx={{ py: 3 }}>
                  <Stack direction="row" spacing={2} alignItems="center">
                    {/* Date */}
                    <Box sx={{ minWidth: 60, textAlign: 'center' }}>
                      <Typography variant="body2" color="text.secondary" sx={{ fontSize: '14px' }}>
                        July
                      </Typography>
                      <Typography variant="h6" fontWeight="bold" sx={{ fontSize: '18px' }}>
                        20
                      </Typography>
                    </Box>
                    
                    {/* Job Image/Icon */}
                    <Box
                      sx={{
                        width: 48,
                        height: 48,
                        borderRadius: 1,
                        backgroundColor: job.category === 'Digital Campaign' ? '#3b82f6' : 
                                       job.category === 'Media/Communications' ? '#ef4444' : '#8b5cf6',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        color: 'white',
                        fontSize: '20px'
                      }}
                    >
                      {job.category === 'Digital Campaign' ? '📱' : 
                       job.category === 'Media/Communications' ? '📸' : '📚'}
                    </Box>
                    
                    {/* Job Details */}
                    <Box>
                      <Typography variant="body1" fontWeight="600" sx={{ mb: 0.5 }}>
                        {job.title}
                      </Typography>
                      <Typography variant="body2" color="text.secondary" sx={{ fontSize: '14px' }}>
                        {job.description}
                      </Typography>
                    </Box>
                  </Stack>
                </TableCell>
                
                <TableCell sx={{ py: 3 }}>
                  <Box>
                    {getStatusChip(job)}
                    <Typography variant="body2" color="text.secondary" sx={{ mt: 1, fontSize: '12px' }}>
                      Started {formatDate(job.createdAt)}
                    </Typography>
                  </Box>
                </TableCell>
                
                <TableCell sx={{ py: 3 }}>
                  <IconButton
                    onClick={(e) => handleMenuClick(e, job)}
                    sx={{ color: '#6b7280' }}
                  >
                    <MoreVert />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      {/* Filters Drawer */}
      <Drawer
        anchor="right"
        open={filtersOpen}
        onClose={() => setFiltersOpen(false)}
        sx={{
          '& .MuiDrawer-paper': {
            width: 350,
            p: 3
          }
        }}
      >
        {/* Filters Header */}
        <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
          <Typography variant="h6" fontWeight="bold">Filters</Typography>
          <IconButton onClick={() => setFiltersOpen(false)}>
            <Close />
          </IconButton>
        </Box>

        {/* Location */}
        <Box mb={3}>
          <Typography variant="subtitle2" fontWeight={600} mb={2}>Location</Typography>
          <TextField
            size="small"
            fullWidth
            placeholder="Enter location"
            value={locationFilter}
            onChange={(e) => setLocationFilter(e.target.value)}
          />
        </Box>

        {/* Search radius */}
        <Box mb={3}>
          <Typography variant="subtitle2" fontWeight={600} mb={2}>Search radius</Typography>
          <Slider
            value={searchRadius}
            onChange={(e, newValue) => setSearchRadius(newValue)}
            min={1}
            max={200}
            marks={[
              { value: 1, label: '1 mile' },
              { value: 200, label: '200 miles' }
            ]}
            sx={{ color: '#1976d2' }}
          />
        </Box>

        {/* Date */}
        <Box mb={3}>
          <Typography variant="subtitle2" fontWeight={600} mb={2}>Date</Typography>
          <TextField
            size="small"
            fullWidth
            type="date"
            value={dateFilter}
            onChange={(e) => setDateFilter(e.target.value)}
            InputLabelProps={{ shrink: true }}
          />
        </Box>

        {/* Frequency */}
        <Box mb={3}>
          <Typography variant="subtitle2" fontWeight={600} mb={2}>Frequency</Typography>
          <Stack direction="row" spacing={1} flexWrap="wrap">
            <FilterChip 
              label="One-off" 
              selected={frequencyFilter.includes('One-off')}
              onClick={() => {
                if (frequencyFilter.includes('One-off')) {
                  setFrequencyFilter(prev => prev.filter(f => f !== 'One-off'));
                } else {
                  setFrequencyFilter(prev => [...prev, 'One-off']);
                }
              }}
            />
            <FilterChip 
              label="Recurring" 
              selected={frequencyFilter.includes('Recurring')}
              onClick={() => {
                if (frequencyFilter.includes('Recurring')) {
                  setFrequencyFilter(prev => prev.filter(f => f !== 'Recurring'));
                } else {
                  setFrequencyFilter(prev => [...prev, 'Recurring']);
                }
              }}
            />
          </Stack>
        </Box>

        {/* Skills required */}
        <Box mb={3}>
          <Typography variant="subtitle2" fontWeight={600} mb={2}>Skills required</Typography>
          <Box>
            {skillsOptions.slice(0, 6).map(skill => (
              <FilterChip 
                key={skill}
                label={skill}
                selected={skillsFilter.includes(skill)}
                onClick={() => {
                  if (skillsFilter.includes(skill)) {
                    setSkillsFilter(prev => prev.filter(s => s !== skill));
                  } else {
                    setSkillsFilter(prev => [...prev, skill]);
                  }
                }}
              />
            ))}
          </Box>
        </Box>

        {/* Status */}
        <Box mb={3}>
          <Typography variant="subtitle2" fontWeight={600} mb={2}>Status</Typography>
          <Box>
            {statusOptions.map(status => (
              <FilterChip 
                key={status}
                label={status}
                selected={statusFilter.includes(status)}
                onClick={() => {
                  if (statusFilter.includes(status)) {
                    setStatusFilter(prev => prev.filter(s => s !== status));
                  } else {
                    setStatusFilter(prev => [...prev, status]);
                  }
                }}
              />
            ))}
          </Box>
        </Box>

        {/* Category */}
        <Box mb={2}>
          <Button
            fullWidth
            sx={{ 
              justifyContent: 'space-between', 
              textTransform: 'none',
              color: 'text.primary',
              fontWeight: 600,
              p: 1
            }}
            onClick={() => setCategoryExpanded(!categoryExpanded)}
            endIcon={categoryExpanded ? <ExpandLess /> : <ExpandMore />}
          >
            Category
          </Button>
          <Collapse in={categoryExpanded}>
            <Box sx={{ pl: 1, pt: 1 }}>
              {categories.map(category => (
                <FilterChip 
                  key={category}
                  label={category}
                  selected={categoryFilter.includes(category)}
                  onClick={() => {
                    if (categoryFilter.includes(category)) {
                      setCategoryFilter(prev => prev.filter(c => c !== category));
                    } else {
                      setCategoryFilter(prev => [...prev, category]);
                    }
                  }}
                />
              ))}
            </Box>
          </Collapse>
        </Box>

        {/* Days of the week */}
        <Box mb={2}>
          <Button
            fullWidth
            sx={{ 
              justifyContent: 'space-between', 
              textTransform: 'none',
              color: 'text.primary',
              fontWeight: 600,
              p: 1
            }}
            onClick={() => setDaysExpanded(!daysExpanded)}
            endIcon={daysExpanded ? <ExpandLess /> : <ExpandMore />}
          >
            Days of the week
          </Button>
          <Collapse in={daysExpanded}>
            <Box sx={{ pl: 1, pt: 1 }}>
              {daysOfWeekOptions.map(day => (
                <FilterChip 
                  key={day}
                  label={day}
                  selected={daysFilter.includes(day)}
                  onClick={() => {
                    if (daysFilter.includes(day)) {
                      setDaysFilter(prev => prev.filter(d => d !== day));
                    } else {
                      setDaysFilter(prev => [...prev, day]);
                    }
                  }}
                />
              ))}
            </Box>
          </Collapse>
        </Box>

        {/* Time commitment */}
        <Box mb={2}>
          <Button
            fullWidth
            sx={{ 
              justifyContent: 'space-between', 
              textTransform: 'none',
              color: 'text.primary',
              fontWeight: 600,
              p: 1
            }}
            onClick={() => setTimeCommitmentExpanded(!timeCommitmentExpanded)}
            endIcon={timeCommitmentExpanded ? <ExpandLess /> : <ExpandMore />}
          >
            Time commitment
          </Button>
          <Collapse in={timeCommitmentExpanded}>
            <Box sx={{ pl: 1, pt: 1 }}>
              {timeCommitmentOptions.map(time => (
                <FilterChip 
                  key={time}
                  label={time}
                  selected={timeCommitmentFilter.includes(time)}
                  onClick={() => {
                    if (timeCommitmentFilter.includes(time)) {
                      setTimeCommitmentFilter(prev => prev.filter(t => t !== time));
                    } else {
                      setTimeCommitmentFilter(prev => [...prev, time]);
                    }
                  }}
                />
              ))}
            </Box>
          </Collapse>
        </Box>

        {/* Clear All Filters */}
        <Box mt={4}>
          <Button
            fullWidth
            variant="outlined"
            onClick={clearAllFilters}
            sx={{ 
              borderColor: '#e5e7eb',
              color: '#6b7280',
              textTransform: 'none'
            }}
          >
            Clear all filters
          </Button>
        </Box>
      </Drawer>

      {/* Context Menu */}
      <Menu
        anchorEl={anchorEl}
        open={Boolean(anchorEl)}
        onClose={handleMenuClose}
        PaperProps={{
          sx: { minWidth: 150 }
        }}
      >
        <MenuItem onClick={() => handleEditClick(selectedJob)}>
          <Edit sx={{ mr: 2, fontSize: 18 }} />
          Edit
        </MenuItem>
        <MenuItem onClick={() => handleDuplicateClick(selectedJob)}>
          <FileCopy sx={{ mr: 2, fontSize: 18 }} />
          Duplicate
        </MenuItem>
        <MenuItem onClick={() => handleDeleteClick(selectedJob)} sx={{ color: '#ef4444' }}>
          <Delete sx={{ mr: 2, fontSize: 18 }} />
          Delete
        </MenuItem>
      </Menu>

      {/* Edit Dialog */}
      <Dialog open={editDialogOpen} onClose={() => setEditDialogOpen(false)} maxWidth="sm" fullWidth>
        <DialogTitle>Edit Job</DialogTitle>
        <DialogContent>
          <TextField
            name="title"
            label="Title"
            value={editFields.title || ''}
            onChange={handleEditFieldChange}
            fullWidth
            margin="normal"
          />
          <TextField
            name="description"
            label="Description"
            value={editFields.description || ''}
            onChange={handleEditFieldChange}
            fullWidth
            multiline
            rows={3}
            margin="normal"
          />
          <FormControl fullWidth margin="normal">
            <InputLabel>Category</InputLabel>
            <Select
              name="category"
              value={editFields.category || ''}
              onChange={handleEditFieldChange}
              label="Category"
            >
              {categories.map(cat => (
                <MenuItem key={cat} value={cat}>{cat}</MenuItem>
              ))}
            </Select>
          </FormControl>
          <FormControl fullWidth margin="normal">
            <InputLabel>Frequency</InputLabel>
            <Select
              name="frequency"
              value={editFields.frequency || ''}
              onChange={handleEditFieldChange}
              label="Frequency"
            >
              <MenuItem value="One-off">One-off</MenuItem>
              <MenuItem value="Recurring">Recurring</MenuItem>
            </Select>
          </FormControl>
          <TextField
            name="volunteersNeeded"
            label="Volunteers Needed"
            type="number"
            value={editFields.volunteersNeeded || ''}
            onChange={handleEditFieldChange}
            fullWidth
            margin="normal"
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setEditDialogOpen(false)}>Cancel</Button>
          <Button onClick={handleEditSave} variant="contained">Save</Button>
        </DialogActions>
      </Dialog>

      {/* Delete Dialog */}
      <Dialog open={deleteDialogOpen} onClose={() => setDeleteDialogOpen(false)}>
        <DialogTitle>Delete Job</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Are you sure you want to delete "{jobToDelete?.title}"? This action cannot be undone.
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setDeleteDialogOpen(false)}>Cancel</Button>
          <Button onClick={handleDeleteConfirm} color="error" variant="contained">Delete</Button>
        </DialogActions>
      </Dialog>

      {/* Snackbar */}
      <Snackbar
        open={snackbar.open}
        autoHideDuration={6000}
        onClose={() => setSnackbar({ ...snackbar, open: false })}
      >
        <Alert severity={snackbar.severity} onClose={() => setSnackbar({ ...snackbar, open: false })}>
          {snackbar.message}
        </Alert>
      </Snackbar>
    </Box>
  );
};

// Since this component is used within OrganizationDashboard, we just export the content
const MyJobsPage = () => {
  return <MyJobsPageContent />;
};

export default MyJobsPage; 