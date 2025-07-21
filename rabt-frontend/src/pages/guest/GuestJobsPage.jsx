import React, { useEffect, useState } from 'react';
import { 
  Box, 
  Typography, 
  Card, 
  CardContent, 
  Button, 
  Stack,
  TextField,
  Slider,
  Chip,
  IconButton,
  InputAdornment,
  Accordion,
  AccordionSummary,
  AccordionDetails,
  Grid,
  Avatar
} from '@mui/material';
import { 
  Search, 
  Favorite, 
  Send,
  ExpandMore,
  LocationOn,
  CalendarToday,
  Clear
} from '@mui/icons-material';
import { useNavigate } from 'react-router-dom';
import { advertService, skillsService } from '../../api/services.js';

const GuestJobsPage = () => {
  const navigate = useNavigate();
  const [jobs, setJobs] = useState([]);
  const [skills, setSkills] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filters, setFilters] = useState({
    location: 'London, UK',
    searchRadius: 1,
    date: '',
    frequency: ['one-off', 'recurring'],
    skills: [],
    search: ''
  });

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        
        // Fetch skills for filter options
        const skillsResponse = await skillsService.getSkills();
        if (skillsResponse.success) {
          setSkills(skillsResponse.data.skills || skillsResponse.data);
        }
        
        // Fetch jobs
        const jobsResponse = await advertService.listAdverts();
        if (jobsResponse.success) {
          setJobs(jobsResponse.data || []);
        }
      } catch (error) {
        console.error('Error fetching data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const handleFilterChange = (filterName, value) => {
    setFilters(prev => ({
      ...prev,
      [filterName]: value
    }));
  };

  const toggleFrequency = (freq) => {
    setFilters(prev => ({
      ...prev,
      frequency: prev.frequency.includes(freq)
        ? prev.frequency.filter(f => f !== freq)
        : [...prev.frequency, freq]
    }));
  };

  const toggleSkill = (skill) => {
    setFilters(prev => ({
      ...prev,
      skills: prev.skills.includes(skill)
        ? prev.skills.filter(s => s !== skill)
        : [...prev.skills, skill]
    }));
  };

  const clearAllFilters = () => {
    setFilters({
      location: 'London, UK',
      searchRadius: 1,
      date: '',
      frequency: ['one-off', 'recurring'],
      skills: [],
      search: ''
    });
  };

  const getFrequencyLabel = (frequency) => {
    return frequency === 'one-off' ? 'One-off' : 'Ongoing';
  };

  const getTimeCommitmentLabel = (details) => {
    if (details?.oneoff_details?.time_commitment) {
      return details.oneoff_details.time_commitment;
    }
    if (details?.recurring_details?.time_commitment_per_session) {
      return details.recurring_details.time_commitment_per_session;
    }
    return '1-2h';
  };



  const filteredJobs = jobs.filter(job => {
    // Filter by frequency
    if (filters.frequency.length > 0 && !filters.frequency.includes(job.frequency)) {
      return false;
    }
    
    // Filter by skills
    if (filters.skills.length > 0) {
      const jobSkills = job.required_skills?.map(skill => skill.name || skill) || [];
      const hasMatchingSkill = filters.skills.some(skill => 
        jobSkills.some(jobSkill => 
          jobSkill.toLowerCase().includes(skill.toLowerCase())
        )
      );
      if (!hasMatchingSkill) return false;
    }
    
    // Filter by search
    if (filters.search) {
      const searchLower = filters.search.toLowerCase();
      const matchesTitle = job.title?.toLowerCase().includes(searchLower);
      const matchesDescription = job.description?.toLowerCase().includes(searchLower);
      const matchesOrganizer = job.organizer?.name?.toLowerCase().includes(searchLower);
      if (!matchesTitle && !matchesDescription && !matchesOrganizer) {
        return false;
      }
    }
    
    return true;
  });

  const oneOffJobs = filteredJobs.filter(job => job.frequency === 'one-off');
  const ongoingJobs = filteredJobs.filter(job => job.frequency === 'recurring');

  return (
    <Box sx={{ display: 'flex', height: '100vh', overflow: 'hidden' }}>
      {/* Left Sidebar - Filters */}
      <Box sx={{ 
        width: 300, 
        backgroundColor: '#f8f9fa', 
        borderRight: '1px solid #e0e0e0',
        p: 3,
        overflow: 'auto'
      }}>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
          <Typography variant="h6" fontWeight="bold">Filters</Typography>
          <Button 
            size="small" 
            onClick={clearAllFilters}
            sx={{ color: '#6366f1', textTransform: 'none' }}
          >
            Clear all
          </Button>
        </Box>

        {/* Location */}
        <Box mb={3}>
          <Typography variant="body2" mb={1} fontWeight="medium">Location</Typography>
          <TextField
            fullWidth
            size="small"
            value={filters.location}
            onChange={(e) => handleFilterChange('location', e.target.value)}
            sx={{ backgroundColor: 'white' }}
          />
        </Box>

        {/* Search Radius */}
        <Box mb={3}>
          <Typography variant="body2" mb={1} fontWeight="medium">Search radius</Typography>
          <Box sx={{ px: 1 }}>
            <Slider
              value={filters.searchRadius}
              onChange={(e, value) => handleFilterChange('searchRadius', value)}
              min={1}
              max={200}
              valueLabelDisplay="auto"
              valueLabelFormat={(value) => `${value} mile${value > 1 ? 's' : ''}`}
            />
          </Box>
        </Box>

        {/* Date */}
        <Box mb={3}>
          <Typography variant="body2" mb={1} fontWeight="medium">Date</Typography>
          <TextField
            fullWidth
            size="small"
            type="date"
            value={filters.date}
            onChange={(e) => handleFilterChange('date', e.target.value)}
            sx={{ backgroundColor: 'white' }}
            InputProps={{
              endAdornment: (
                <InputAdornment position="end">
                  <CalendarToday sx={{ color: '#9ca3af' }} />
                </InputAdornment>
              )
            }}
          />
        </Box>

        {/* Frequency */}
        <Box mb={3}>
          <Typography variant="body2" mb={1} fontWeight="medium">Frequency</Typography>
          <Stack direction="row" spacing={1} flexWrap="wrap" useFlexGap>
            {['one-off', 'recurring'].map((freq) => (
              <Chip
                key={freq}
                label={getFrequencyLabel(freq)}
                onClick={() => toggleFrequency(freq)}
                onDelete={filters.frequency.includes(freq) ? () => toggleFrequency(freq) : undefined}
                deleteIcon={<Clear />}
                color={filters.frequency.includes(freq) ? 'primary' : 'default'}
                sx={{ 
                  backgroundColor: filters.frequency.includes(freq) ? '#6366f1' : '#e5e7eb',
                  color: filters.frequency.includes(freq) ? 'white' : '#374151',
                  '&:hover': {
                    backgroundColor: filters.frequency.includes(freq) ? '#5856eb' : '#d1d5db'
                  }
                }}
              />
            ))}
          </Stack>
        </Box>

        {/* Skills Required */}
        <Box mb={3}>
          <Typography variant="body2" mb={1} fontWeight="medium">Skills required</Typography>
          <Stack direction="row" spacing={1} flexWrap="wrap" useFlexGap>
            {skills.map((skill) => (
              <Chip
                key={skill.id}
                label={skill.name}
                onClick={() => toggleSkill(skill.name)}
                onDelete={filters.skills.includes(skill.name) ? () => toggleSkill(skill.name) : undefined}
                deleteIcon={<Clear />}
                color={filters.skills.includes(skill.name) ? 'primary' : 'default'}
                sx={{ 
                  backgroundColor: filters.skills.includes(skill.name) ? '#6366f1' : '#e5e7eb',
                  color: filters.skills.includes(skill.name) ? 'white' : '#374151',
                  '&:hover': {
                    backgroundColor: filters.skills.includes(skill.name) ? '#5856eb' : '#d1d5db'
                  }
                }}
              />
            ))}
          </Stack>
        </Box>

        {/* Additional Filter Categories */}
        {['Category', 'Days of the week', 'Time commitment', 'Duration', 'Recurrence', 'Time of day'].map((category) => (
          <Accordion key={category} sx={{ boxShadow: 'none', '&:before': { display: 'none' } }}>
            <AccordionSummary expandIcon={<ExpandMore />}>
              <Typography variant="body2" fontWeight="medium">{category}</Typography>
            </AccordionSummary>
            <AccordionDetails>
              <Typography variant="body2" color="text.secondary">
                Filter options for {category.toLowerCase()}
              </Typography>
            </AccordionDetails>
          </Accordion>
        ))}
      </Box>

      {/* Right Section - Job Listings */}
      <Box sx={{ flex: 1, backgroundColor: 'white', overflow: 'auto' }}>
        {/* Header */}
        <Box sx={{ p: 3, borderBottom: '1px solid #e0e0e0' }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
            <Typography variant="h5" fontWeight="bold">
              All roles and events ({filteredJobs.length})
            </Typography>
            <Button 
              variant="contained" 
              onClick={() => navigate('/signup')}
              sx={{ 
                backgroundColor: '#6366f1',
                '&:hover': { backgroundColor: '#5856eb' }
              }}
            >
              Sign Up
            </Button>
          </Box>
          
          <Box sx={{ display: 'flex', gap: 2 }}>
            <TextField
              placeholder="Search for a role/event or organisation name"
              fullWidth
              size="small"
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <Search sx={{ color: '#9ca3af' }} />
                  </InputAdornment>
                )
              }}
              value={filters.search}
              onChange={(e) => handleFilterChange('search', e.target.value)}
              sx={{ backgroundColor: '#f8f9fa' }}
            />
            <Button variant="outlined" size="small">
              Sort by
            </Button>
          </Box>
        </Box>

        {/* Job Listings */}
        <Box sx={{ p: 3 }}>
          {loading ? (
            <Typography>Loading...</Typography>
          ) : (
            <>
              {/* One-off Jobs */}
              {oneOffJobs.length > 0 && (
                <Box mb={4}>
                  <Typography variant="h6" mb={2} fontWeight="bold">
                    One-off ({oneOffJobs.length})
                  </Typography>
                  <Grid container spacing={2}>
                    {oneOffJobs.slice(0, 6).map((job) => (
                      <Grid item xs={12} sm={6} md={4} key={job.id}>
                        <Card sx={{ 
                          height: 280, 
                          position: 'relative',
                          cursor: 'pointer',
                          '&:hover': { boxShadow: 3 }
                        }}
                        onClick={() => navigate(`/guest/jobs/${job.id}`)}
                        >
                          <Box sx={{ 
                            height: 140, 
                            backgroundColor: '#f3f4f6',
                            position: 'relative',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            overflow: 'hidden'
                          }}>
                            {job.advert_image_url ? (
                              <img 
                                src={`${import.meta.env.VITE_API_MEDIA_URL}${job.advert_image_url}`}
                                alt={job.title}
                                style={{
                                  width: '100%',
                                  height: '100%',
                                  objectFit: 'cover'
                                }}
                                onError={(e) => {
                                  e.target.style.display = 'none';
                                  e.target.nextSibling.style.display = 'flex';
                                }}
                              />
                            ) : null}
                            <Box 
                              sx={{ 
                                position: 'absolute',
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                display: job.advert_image_url ? 'none' : 'flex',
                                alignItems: 'center',
                                justifyContent: 'center',
                                backgroundColor: '#f3f4f6'
                              }}
                            >
                              <Typography variant="body2" color="text.secondary">
                                No Image
                              </Typography>
                            </Box>
                            <Box sx={{ position: 'absolute', top: 8, right: 8 }}>
                              <IconButton size="small" sx={{ color: 'white', backgroundColor: 'rgba(0,0,0,0.3)' }}>
                                <Favorite fontSize="small" />
                              </IconButton>
                              <IconButton size="small" sx={{ color: 'white', backgroundColor: 'rgba(0,0,0,0.3)', ml: 1 }}>
                                <Send fontSize="small" />
                              </IconButton>
                            </Box>
                          </Box>
                          <CardContent sx={{ p: 2 }}>
                            <Typography variant="h6" fontWeight="bold" mb={1} noWrap>
                              {job.title}
                            </Typography>
                            <Typography variant="body2" color="text.secondary" mb={1}>
                              {job.organizer?.name || 'Organization'}
                            </Typography>
                            <Typography variant="caption" color="text.secondary">
                              {getTimeCommitmentLabel(job.oneoff_details || job.recurring_details)}
                            </Typography>
                          </CardContent>
                        </Card>
                      </Grid>
                    ))}
                  </Grid>
                </Box>
              )}

              {/* Ongoing Jobs */}
              {ongoingJobs.length > 0 && (
                <Box>
                  <Typography variant="h6" mb={2} fontWeight="bold">
                    Ongoing ({ongoingJobs.length})
                  </Typography>
                  <Grid container spacing={2}>
                    {ongoingJobs.slice(0, 3).map((job) => (
                      <Grid item xs={12} sm={6} md={4} key={job.id}>
                        <Card sx={{ 
                          height: 280, 
                          position: 'relative',
                          cursor: 'pointer',
                          '&:hover': { boxShadow: 3 }
                        }}
                        onClick={() => navigate(`/guest/jobs/${job.id}`)}
                        >
                          <Box sx={{ 
                            height: 140, 
                            backgroundColor: '#f3f4f6',
                            position: 'relative',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            overflow: 'hidden'
                          }}>
                            {job.advert_image_url ? (
                              <img 
                                src={`${import.meta.env.VITE_API_MEDIA_URL}${job.advert_image_url}`}
                                alt={job.title}
                                style={{
                                  width: '100%',
                                  height: '100%',
                                  objectFit: 'cover'
                                }}
                                onError={(e) => {
                                  e.target.style.display = 'none';
                                  e.target.nextSibling.style.display = 'flex';
                                }}
                              />
                            ) : null}
                            <Box 
                              sx={{ 
                                position: 'absolute',
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                display: job.advert_image_url ? 'none' : 'flex',
                                alignItems: 'center',
                                justifyContent: 'center',
                                backgroundColor: '#f3f4f6'
                              }}
                            >
                              <Typography variant="body2" color="text.secondary">
                                No Image
                              </Typography>
                            </Box>
                            <Box sx={{ position: 'absolute', top: 8, right: 8 }}>
                              <IconButton size="small" sx={{ color: 'white', backgroundColor: 'rgba(0,0,0,0.3)' }}>
                                <Favorite fontSize="small" />
                              </IconButton>
                              <IconButton size="small" sx={{ color: 'white', backgroundColor: 'rgba(0,0,0,0.3)', ml: 1 }}>
                                <Send fontSize="small" />
                              </IconButton>
                            </Box>
                          </Box>
                          <CardContent sx={{ p: 2 }}>
                            <Typography variant="h6" fontWeight="bold" mb={1} noWrap>
                              {job.title}
                            </Typography>
                            <Typography variant="body2" color="text.secondary" mb={1}>
                              {job.organizer?.name || 'Organization'}
                            </Typography>
                            <Typography variant="caption" color="text.secondary">
                              {getTimeCommitmentLabel(job.oneoff_details || job.recurring_details)}
                            </Typography>
            </CardContent>
          </Card>
                      </Grid>
                    ))}
                  </Grid>
                </Box>
              )}

              {filteredJobs.length === 0 && !loading && (
                <Box sx={{ textAlign: 'center', py: 4 }}>
                  <Typography variant="h6" color="text.secondary">
                    No jobs found matching your filters
                  </Typography>
                </Box>
              )}
            </>
          )}
        </Box>
      </Box>
    </Box>
  );
};

export default GuestJobsPage; 