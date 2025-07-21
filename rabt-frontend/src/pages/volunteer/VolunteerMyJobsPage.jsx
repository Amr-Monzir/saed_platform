import React, { useState } from 'react';
import {
  Box,
  Typography,
  Stack,
  Card,
  CardContent,
  Button,
  TextField,
  MenuItem,
  FormControl,
  InputLabel,
  Select,
  Chip,
  IconButton,
  Slider,
  FormControlLabel,
  Checkbox,
  OutlinedInput,
  Avatar,
  Divider,
  Drawer,
  AppBar,
  Toolbar,
  ListItemText,
  Collapse
} from '@mui/material';
import {
  Search,
  LocationOn,
  Schedule,
  Favorite,
  FavoriteBorder,
  Share,
  ExpandMore,
  ExpandLess,
  Menu as MenuIcon,
  FilterList,
  Close
} from '@mui/icons-material';
import { mockJobs, fetchApplications } from '../../api/index.js';
import { useAuth } from '../../contexts/useAuth';
import { useNavigate, useLocation } from 'react-router-dom';
import VolunteerSideMenu from './VolunteerSideMenu';

const skillsOptions = [
  'Social Media Management',
  'Content Creation', 
  'Graphic Design',
  'Copywriting',
  'Instagram/Twitter',
  'Canva/Photoshop',
  'Translation',
  'Event Planning',
  'Research',
  'Admin',
  'Other',
  'No skills required'
];

const categoryOptions = [
  'Digital Campaign',
  'Protest/Rally',
  'Educational Workshop',
  'Fundraising',
  'Community Outreach',
  'Media/Communications',
  'Legal Support',
  'Logistics/Operations',
  'Other'
];

const daysOfWeekOptions = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
];

const timeCommitmentOptions = [
  '1-2 hours', '3-5 hours', '6-10 hours', '11-20 hours', '20+ hours'
];

const durationOptions = [
  '1 day', '1 week', '2-4 weeks', '1-3 months', '3-6 months', '6+ months'
];

const recurrenceOptions = [
  'Daily', 'Weekly', 'Bi-weekly', 'Monthly', 'Quarterly', 'As needed'
];

const timeOfDayOptions = [
  'Morning (6AM-12PM)', 'Afternoon (12PM-6PM)', 'Evening (6PM-12AM)', 'Night (12AM-6AM)', 'Flexible'
];

const VolunteerMyJobsPage = () => {
  const { user } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  
  // UI State
  const [sideMenuOpen, setSideMenuOpen] = useState(false);
  const [filtersOpen, setFiltersOpen] = useState(false);
  const [sortBy, setSortBy] = useState('Recent');
  
  // Filter states
  const [search, setSearch] = useState('');
  const [locationFilter, setLocationFilter] = useState('');
  const [searchRadius, setSearchRadius] = useState([1]);
  const [dateFilter, setDateFilter] = useState('');
  const [frequencyFilter, setFrequencyFilter] = useState([]);
  const [skillsFilter, setSkillsFilter] = useState([]);
  const [categoryFilter, setCategoryFilter] = useState([]);
  const [daysFilter, setDaysFilter] = useState([]);
  const [timeCommitmentFilter, setTimeCommitmentFilter] = useState([]);
  const [durationFilter, setDurationFilter] = useState([]);
  const [recurrenceFilter, setRecurrenceFilter] = useState([]);
  const [timeOfDayFilter, setTimeOfDayFilter] = useState([]);
  
  // Expandable filter sections
  const [categoryExpanded, setCategoryExpanded] = useState(false);
  const [daysExpanded, setDaysExpanded] = useState(false);
  const [timeCommitmentExpanded, setTimeCommitmentExpanded] = useState(false);
  const [durationExpanded, setDurationExpanded] = useState(false);
  const [recurrenceExpanded, setRecurrenceExpanded] = useState(false);
  const [timeOfDayExpanded, setTimeOfDayExpanded] = useState(false);
  
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
    const matchesSearch = job.title.toLowerCase().includes(search.toLowerCase()) || 
                         job.description.toLowerCase().includes(search.toLowerCase()) ||
                         (job.organizationName && job.organizationName.toLowerCase().includes(search.toLowerCase()));
    const matchesLocation = !locationFilter || job.location.toLowerCase().includes(locationFilter.toLowerCase());
    const matchesFrequency = frequencyFilter.length === 0 || frequencyFilter.includes(job.frequency);
    const matchesSkills = skillsFilter.length === 0 || (job.skills && job.skills.some(skill => skillsFilter.includes(skill)));
    const matchesCategory = categoryFilter.length === 0 || categoryFilter.includes(job.category);
    const matchesDays = daysFilter.length === 0 || (job.daysOfWeek && job.daysOfWeek.some(day => daysFilter.includes(day)));
    const matchesTimeCommitment = timeCommitmentFilter.length === 0 || timeCommitmentFilter.includes(job.timeCommitment);
    const matchesDuration = durationFilter.length === 0 || durationFilter.includes(job.duration);
    const matchesRecurrence = recurrenceFilter.length === 0 || recurrenceFilter.includes(job.recurrence);
    const matchesTimeOfDay = timeOfDayFilter.length === 0 || timeOfDayFilter.includes(job.timeOfDay);
    
    return matchesSearch && matchesLocation && matchesFrequency && matchesSkills && 
           matchesCategory && matchesDays && matchesTimeCommitment && matchesDuration && 
           matchesRecurrence && matchesTimeOfDay;
  });

  const oneOffJobs = filteredJobs.filter(j => j.frequency === 'One-off');
  const ongoingJobs = filteredJobs.filter(j => j.frequency === 'Recurring');

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
    setDurationFilter([]);
    setRecurrenceFilter([]);
    setTimeOfDayFilter([]);
  };

  const getStatusChip = (status) => {
    const statusConfig = {
      pending: { color: 'warning', label: 'Pending' },
      accepted: { color: 'success', label: 'Active' },
      rejected: { color: 'error', label: 'Rejected' },
      completed: { color: 'info', label: 'Completed' }
    };
    const config = statusConfig[status] || { color: 'default', label: status };
    return <Chip size="small" color={config.color} label={config.label} />;
  };

  const JobCard = ({ job }) => (
    <Card 
      sx={{ 
        cursor: 'pointer',
        transition: 'all 0.2s',
        '&:hover': { 
          transform: 'translateY(-2px)',
          boxShadow: 3
        },
        height: '100%',
        display: 'flex',
        flexDirection: 'column',
        borderRadius: 2
      }}
      onClick={() => navigate(`/volunteer/jobs/${job.id}`)}
    >
      <Box sx={{ position: 'relative', height: 200, backgroundColor: '#f5f5f5' }}>
        {/* Job category specific images/colors */}
        <Box 
          sx={{ 
            width: '100%', 
            height: '100%', 
            background: job.category === 'Digital Campaign' ? 'linear-gradient(135deg, #4285f4 0%, #34a853 100%)' :
                       job.category === 'Photographer/Videomaker' ? 'linear-gradient(135deg, #333 0%, #666 100%)' :
                       job.title.includes('Gaza Doctors') ? 'linear-gradient(135deg, #dc3545 0%, #fd7e14 100%)' :
                       'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: 'white',
            fontSize: '3rem'
          }}
        >
          {job.category === 'Digital Campaign' || job.title.includes('Social media') ? '📱' : 
           job.category === 'Photographer/Videomaker' || job.title.includes('Photographer') ? '📷' :
           job.title.includes('Gaza Doctors') ? '🎬' : '🎯'}
        </Box>
        <Box sx={{ position: 'absolute', top: 12, right: 12 }}>
          <IconButton size="small" sx={{ backgroundColor: 'rgba(255,255,255,0.9)' }}>
            <FavoriteBorder fontSize="small" />
          </IconButton>
        </Box>
        <Box sx={{ position: 'absolute', top: 12, right: 52 }}>
          <IconButton size="small" sx={{ backgroundColor: 'rgba(255,255,255,0.9)' }}>
            <Share fontSize="small" />
          </IconButton>
        </Box>
      </Box>
      <CardContent sx={{ flexGrow: 1, display: 'flex', flexDirection: 'column', p: 2 }}>
        <Typography variant="h6" fontWeight="bold" mb={1} sx={{ fontSize: '1rem' }}>
          {job.title}
        </Typography>
        <Typography variant="body2" color="text.secondary" mb={2}>
          {job.organizationName || 'Imperial College Students for Palestine'}
        </Typography>
        <Box sx={{ mt: 'auto' }}>
          <Stack direction="row" justifyContent="space-between" alignItems="center">
            {getStatusChip(job.status)}
            <Typography variant="body2" color="text.secondary">
              {job.frequency}
            </Typography>
          </Stack>
        </Box>
      </CardContent>
    </Card>
  );

  const FilterChip = ({ label, selected, onClick }) => (
    <Chip 
      label={label}
      size="small"
      clickable
      color={selected ? 'primary' : 'default'}
      onClick={onClick}
      sx={{ 
        mb: 1, 
        mr: 1,
        backgroundColor: selected ? '#1976d2' : '#f5f5f5',
        color: selected ? 'white' : 'text.primary',
        '&:hover': {
          backgroundColor: selected ? '#1565c0' : '#e0e0e0'
        }
      }}
    />
  );

  const FiltersPanel = () => (
    <Box sx={{ width: 300, height: '100%', backgroundColor: 'white', p: 3 }}>
      <Stack direction="row" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h6" fontWeight="bold">Filters</Typography>
        <Stack direction="row" spacing={1}>
          <Button size="small" onClick={clearAllFilters}>Clear all</Button>
          <IconButton size="small" onClick={() => setFiltersOpen(false)}>
            <Close />
          </IconButton>
        </Stack>
      </Stack>

      <Box sx={{ maxHeight: 'calc(100vh - 120px)', overflowY: 'auto' }}>
        {/* Location */}
        <Box mb={3}>
          <Typography variant="subtitle2" fontWeight={600} mb={2}>Location</Typography>
          <TextField
            size="small"
            fullWidth
            placeholder="London, UK"
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
              label="Ongoing" 
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
              {categoryOptions.map(category => (
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

        {/* Duration */}
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
            onClick={() => setDurationExpanded(!durationExpanded)}
            endIcon={durationExpanded ? <ExpandLess /> : <ExpandMore />}
          >
            Duration
          </Button>
          <Collapse in={durationExpanded}>
            <Box sx={{ pl: 1, pt: 1 }}>
              {durationOptions.map(duration => (
                <FilterChip 
                  key={duration}
                  label={duration}
                  selected={durationFilter.includes(duration)}
                  onClick={() => {
                    if (durationFilter.includes(duration)) {
                      setDurationFilter(prev => prev.filter(d => d !== duration));
                    } else {
                      setDurationFilter(prev => [...prev, duration]);
                    }
                  }}
                />
              ))}
            </Box>
          </Collapse>
        </Box>

        {/* Recurrence */}
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
            onClick={() => setRecurrenceExpanded(!recurrenceExpanded)}
            endIcon={recurrenceExpanded ? <ExpandLess /> : <ExpandMore />}
          >
            Recurrence
          </Button>
          <Collapse in={recurrenceExpanded}>
            <Box sx={{ pl: 1, pt: 1 }}>
              {recurrenceOptions.map(recurrence => (
                <FilterChip 
                  key={recurrence}
                  label={recurrence}
                  selected={recurrenceFilter.includes(recurrence)}
                  onClick={() => {
                    if (recurrenceFilter.includes(recurrence)) {
                      setRecurrenceFilter(prev => prev.filter(r => r !== recurrence));
                    } else {
                      setRecurrenceFilter(prev => [...prev, recurrence]);
                    }
                  }}
                />
              ))}
            </Box>
          </Collapse>
        </Box>

        {/* Time of day */}
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
            onClick={() => setTimeOfDayExpanded(!timeOfDayExpanded)}
            endIcon={timeOfDayExpanded ? <ExpandLess /> : <ExpandMore />}
          >
            Time of day
          </Button>
          <Collapse in={timeOfDayExpanded}>
            <Box sx={{ pl: 1, pt: 1 }}>
              {timeOfDayOptions.map(timeOfDay => (
                <FilterChip 
                  key={timeOfDay}
                  label={timeOfDay}
                  selected={timeOfDayFilter.includes(timeOfDay)}
                  onClick={() => {
                    if (timeOfDayFilter.includes(timeOfDay)) {
                      setTimeOfDayFilter(prev => prev.filter(t => t !== timeOfDay));
                    } else {
                      setTimeOfDayFilter(prev => [...prev, timeOfDay]);
                    }
                  }}
                />
              ))}
            </Box>
          </Collapse>
        </Box>
      </Box>
    </Box>
  );

  return (
    <Box sx={{ backgroundColor: '#f8f9fa', minHeight: '100vh' }}>
      {/* Top App Bar */}
      <AppBar position="static" elevation={0} sx={{ backgroundColor: 'white', color: 'text.primary' }}>
        <Toolbar>
          <IconButton
            edge="start"
            onClick={() => setSideMenuOpen(true)}
            sx={{ mr: 2 }}
          >
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" sx={{ flexGrow: 1 }}>
            My Jobs
          </Typography>
        </Toolbar>
      </AppBar>

      {/* Side Menu Drawer */}
      <Drawer
        anchor="left"
        open={sideMenuOpen}
        onClose={() => setSideMenuOpen(false)}
        sx={{
          '& .MuiDrawer-paper': {
            width: 280,
            boxSizing: 'border-box',
          },
        }}
      >
        <VolunteerSideMenu selectedPath={location.pathname} />
      </Drawer>

      {/* Filters Drawer */}
      <Drawer
        anchor="left"
        open={filtersOpen}
        onClose={() => setFiltersOpen(false)}
        sx={{
          '& .MuiDrawer-paper': {
            width: 300,
            boxSizing: 'border-box',
          },
        }}
      >
        <FiltersPanel />
      </Drawer>

      {/* Main content */}
      <Box p={3}>
        {/* Header */}
        <Box mb={4}>
          <Stack direction="row" justifyContent="space-between" alignItems="center" mb={3}>
            <Stack direction="row" spacing={2} alignItems="center">
              <Button
                variant="outlined"
                startIcon={<FilterList />}
                onClick={() => setFiltersOpen(true)}
                sx={{ textTransform: 'none' }}
              >
                Filters
              </Button>
              <Typography variant="h4" fontWeight="bold">
                All roles and events ({filteredJobs.length})
              </Typography>
            </Stack>
            <FormControl size="small" sx={{ minWidth: 120 }}>
              <InputLabel>Sort by</InputLabel>
              <Select
                value={sortBy}
                label="Sort by"
                onChange={(e) => setSortBy(e.target.value)}
              >
                <MenuItem value="Recent">Recent</MenuItem>
                <MenuItem value="Alphabetical">Alphabetical</MenuItem>
                <MenuItem value="Status">Status</MenuItem>
              </Select>
            </FormControl>
          </Stack>

          {/* Search bar */}
          <TextField
            fullWidth
            placeholder="Search for a role/event or organisation name"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            InputProps={{
              startAdornment: <Search sx={{ color: 'text.secondary', mr: 1 }} />
            }}
            sx={{ mb: 3 }}
          />
        </Box>

        {/* One-off section */}
        <Box mb={4}>
          <Typography variant="h5" fontWeight="bold" mb={3}>
            One-off ({oneOffJobs.length})
          </Typography>
          {oneOffJobs.length === 0 ? (
            <Typography color="text.secondary">No one-off jobs found.</Typography>
          ) : (
            <Box 
              sx={{ 
                display: 'grid', 
                gridTemplateColumns: 'repeat(auto-fill, minmax(320px, 1fr))', 
                gap: 3 
              }}
            >
              {oneOffJobs.map(job => (
                <JobCard key={job.id} job={job} />
              ))}
            </Box>
          )}
        </Box>

        {/* Ongoing section */}
        <Box>
          <Typography variant="h5" fontWeight="bold" mb={3}>
            Ongoing ({ongoingJobs.length})
          </Typography>
          {ongoingJobs.length === 0 ? (
            <Typography color="text.secondary">No ongoing jobs found.</Typography>
          ) : (
            <Box 
              sx={{ 
                display: 'grid', 
                gridTemplateColumns: 'repeat(auto-fill, minmax(320px, 1fr))', 
                gap: 3 
              }}
            >
              {ongoingJobs.map(job => (
                <JobCard key={job.id} job={job} />
              ))}
            </Box>
          )}
        </Box>
      </Box>
    </Box>
  );
};

export default VolunteerMyJobsPage; 