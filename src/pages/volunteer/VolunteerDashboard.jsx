import React, { useEffect, useState } from 'react';
import { 
  Box, 
  Drawer, 
  Typography, 
  Card, 
  CardContent, 
  Button, 
  Stack, 
  TextField, 
  MenuItem, 
  FormControl, 
  InputLabel, 
  Select,
  AppBar,
  Toolbar,
  IconButton,
  Chip
} from '@mui/material';
import { 
  Menu as MenuIcon, 
  Search, 
  LocationOn, 
  Schedule, 
  Group,
  Favorite,
  FavoriteBorder,
  Share
} from '@mui/icons-material';
import { advertService } from '../../api/services.js';
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

const VolunteerDashboard = () => {
  const [jobs, setJobs] = useState([]);
  const [search, setSearch] = useState('');
  const [category, setCategory] = useState('All');
  const [frequency, setFrequency] = useState('All');
  const [sideMenuOpen, setSideMenuOpen] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    const fetchJobs = async () => {
      try {
        const response = await advertService.listAdverts();
        if (response.success) {
          setJobs(response.data || []);
        }
      } catch (error) {
        console.error('Error fetching jobs:', error);
      }
    };
    
    fetchJobs();
  }, []);

  const filteredJobs = jobs.filter(job => {
    const matchesSearch = job.title?.toLowerCase().includes(search.toLowerCase()) || 
                         job.description?.toLowerCase().includes(search.toLowerCase()) ||
                         job.organizer?.name?.toLowerCase().includes(search.toLowerCase());
    const matchesCategory = category === 'All' || job.category === category;
    const matchesFrequency = frequency === 'All' || 
                           (frequency === 'One-off' && job.frequency === 'one-off') ||
                           (frequency === 'Recurring' && job.frequency === 'recurring');
    return matchesSearch && matchesCategory && matchesFrequency;
  });

  const oneOffJobs = filteredJobs.filter(j => j.frequency === 'one-off');
  const ongoingJobs = filteredJobs.filter(j => j.frequency === 'recurring');

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
      <Box sx={{ position: 'relative', height: 200, backgroundColor: '#f5f5f5', overflow: 'hidden' }}>
        {/* Display actual image if available, otherwise fallback to gradient */}
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
            width: '100%', 
            height: '100%', 
            background: job.category === 'Digital Campaign' ? 'linear-gradient(135deg, #4285f4 0%, #34a853 100%)' :
                       job.title.includes('Social media') ? 'linear-gradient(135deg, #4285f4 0%, #34a853 100%)' :
                       job.title.includes('Photographer') ? 'linear-gradient(135deg, #333 0%, #666 100%)' :
                       job.title.includes('Gaza Doctors') ? 'linear-gradient(135deg, #dc3545 0%, #fd7e14 100%)' :
                       'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            display: job.advert_image_url ? 'none' : 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: 'white',
            fontSize: '3rem'
          }}
        >
          {job.category === 'Digital Campaign' || job.title.includes('Social media') ? '📱' : 
           job.title.includes('Photographer') ? '📷' :
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
          {job.organizer?.name || 'Organization'}
        </Typography>
        <Box sx={{ mt: 'auto' }}>
          <Stack direction="row" justifyContent="space-between" alignItems="center">
            <Chip 
              size="small" 
              color="primary" 
              label="Available" 
              sx={{ backgroundColor: '#e8f5e8', color: '#2e7d32' }}
            />
            <Typography variant="body2" color="text.secondary">
              {job.frequency === 'one-off' ? 'One-off' : 'Ongoing'}
            </Typography>
          </Stack>
        </Box>
      </CardContent>
    </Card>
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
            Available Jobs
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

      {/* Main content */}
      <Box p={3}>
        {/* Header */}
        <Box mb={4}>
          <Typography variant="h4" fontWeight="bold" mb={3}>
            All roles and events ({filteredJobs.length})
          </Typography>

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

          {/* Filters */}
          <Stack direction={{ xs: 'column', md: 'row' }} spacing={2} mb={3}>
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

export default VolunteerDashboard; 