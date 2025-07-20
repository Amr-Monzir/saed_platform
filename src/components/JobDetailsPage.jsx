import React, { useEffect, useState } from 'react';
import { 
  Box, 
  Typography, 
  Paper, 
  Stack, 
  Divider, 
  Link, 
  Button, 
  Chip,
  Avatar,
  IconButton,
  Card,
  CardContent,
  AppBar,
  Toolbar,
  Drawer,
  Grid
} from '@mui/material';
import { 
  LocationOn, 
  Schedule, 
  Group, 
  Language, 
  Facebook, 
  Twitter,
  ArrowBack,
  CheckCircle,
  Menu as MenuIcon,
  Favorite,
  Share,
  AccessTime
} from '@mui/icons-material';
import { useNavigate, useParams } from 'react-router-dom';
import { advertService } from '../api/services.js';

const JobDetailsPage = ({ 
  isGuest = false, 
  SideMenu = null, 
  selectedPath = null,
  onApply = null 
}) => {
  const navigate = useNavigate();
  const { jobId } = useParams();
  const [job, setJob] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [sideMenuOpen, setSideMenuOpen] = useState(false);

  useEffect(() => {
    const fetchJobDetails = async () => {
      try {
        setLoading(true);
        const response = await advertService.getAdvert(jobId);
        if (response.success) {
          setJob(response.data);
        } else {
          setError('Failed to load job details');
        }
      } catch (error) {
        console.error('Error fetching job details:', error);
        setError('Failed to load job details');
      } finally {
        setLoading(false);
      }
    };

    if (jobId) {
      fetchJobDetails();
    }
  }, [jobId]);

  const getTimeCommitmentLabel = (details) => {
    if (details?.oneoff_details?.time_commitment) {
      return details.oneoff_details.time_commitment;
    }
    if (details?.recurring_details?.time_commitment_per_session) {
      return details.recurring_details.time_commitment_per_session;
    }
    return '1-2h';
  };

  const getFrequencyLabel = (frequency) => {
    return frequency === 'one-off' ? 'One-off' : 'Ongoing';
  };

  const getSkillsList = (skills) => {
    if (!skills || skills.length === 0) return ['No specific skills required'];
    return skills.map(skill => skill.name || skill);
  };

  const getOrgInitials = (name) => {
    return name.split(' ').map(word => word[0]).join('').substring(0, 2).toUpperCase();
  };

  if (loading) {
    return (
      <Box sx={{ p: 3, textAlign: 'center' }}>
        <Typography>Loading job details...</Typography>
      </Box>
    );
  }

  if (error || !job) {
    return (
      <Box sx={{ p: 3, textAlign: 'center' }}>
        <Typography color="error">{error || 'Job not found'}</Typography>
        <Button sx={{ mt: 2 }} onClick={() => navigate(isGuest ? '/guest/jobs' : '/volunteer')}>
          Back to Jobs
        </Button>
      </Box>
    );
  }

  return (
    <Box sx={{ backgroundColor: '#f5f5f5', minHeight: '100vh' }}>
      {/* Top App Bar - Only for volunteer view */}
      {!isGuest && (
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
              Job Details
            </Typography>
          </Toolbar>
        </AppBar>
      )}

      {/* Side Menu Drawer - Only for volunteer view */}
      {!isGuest && SideMenu && (
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
          <SideMenu selectedPath={selectedPath} />
        </Drawer>
      )}

      {/* Header with gradient background */}
      <Box 
        sx={{ 
          background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          color: 'white',
          p: 4,
          position: 'relative'
        }}
      >
        <Box maxWidth={1200} mx="auto">
          <Button 
            startIcon={<ArrowBack />}
            onClick={() => navigate(-1)}
            sx={{ 
              color: 'white', 
              mb: 2,
              '&:hover': { backgroundColor: 'rgba(255,255,255,0.1)' }
            }}
          >
            Back
          </Button>
          
          <Stack spacing={1} mb={2}>
            <Chip 
              label={`${job.category || 'General'} • ${getFrequencyLabel(job.frequency)}`} 
              size="small" 
              sx={{ 
                backgroundColor: 'rgba(255,255,255,0.2)', 
                color: 'white',
                alignSelf: 'flex-start'
              }} 
            />
            <Typography variant="h3" fontWeight="bold">
              {job.title}
            </Typography>
          </Stack>

          <Stack direction="row" spacing={3} alignItems="center" flexWrap="wrap">
            <Stack direction="row" alignItems="center" spacing={1}>
              <LocationOn fontSize="small" />
              <Typography>{job.location || 'Location not specified'}</Typography>
            </Stack>
            <Stack direction="row" alignItems="center" spacing={1}>
              <Schedule fontSize="small" />
              <Typography>{getTimeCommitmentLabel(job.oneoff_details || job.recurring_details)}</Typography>
            </Stack>
            <Stack direction="row" alignItems="center" spacing={1}>
              <Group fontSize="small" />
              <Typography>2-3 volunteers needed</Typography>
            </Stack>
          </Stack>
        </Box>
      </Box>

      {/* Main content */}
      <Box maxWidth={1200} mx="auto" p={4}>
        <Stack direction={{ xs: 'column', lg: 'row' }} spacing={4}>
          {/* Left column - Job details */}
          <Box flex={2}>
            {/* About This Role */}
            <Card sx={{ mb: 3 }}>
              <CardContent>
                <Typography variant="h6" fontWeight="bold" mb={2} sx={{ borderLeft: '4px solid #667eea', pl: 2 }}>
                  About This Role
                </Typography>
                <Box sx={{ backgroundColor: '#f8f9ff', p: 2, borderRadius: 1, border: '1px solid #e3e8ff' }}>
                  <Typography variant="body1" color="text.secondary">
                    {job.description || 'No description available.'}
                  </Typography>
                </Box>
              </CardContent>
            </Card>

            {/* Skills & Experience */}
            <Card sx={{ mb: 3 }}>
              <CardContent>
                <Typography variant="h6" fontWeight="bold" mb={2} sx={{ borderLeft: '4px solid #667eea', pl: 2 }}>
                  Skills & Experience
                </Typography>
                <Typography variant="body2" color="text.secondary" mb={2}>
                  We're looking for volunteers with experience in:
                </Typography>
                <Stack direction="row" spacing={1} flexWrap="wrap" gap={1}>
                  {getSkillsList(job.required_skills).map((skill, index) => (
                    <Chip 
                      key={index} 
                      label={skill} 
                      sx={{ backgroundColor: '#e8f0fe', color: '#1565c0' }}
                    />
                  ))}
                </Stack>
              </CardContent>
            </Card>

            {/* Time Commitment & Schedule */}
            <Card sx={{ mb: 3 }}>
              <CardContent>
                <Typography variant="h6" fontWeight="bold" mb={2} sx={{ borderLeft: '4px solid #667eea', pl: 2 }}>
                  Time Commitment & Schedule
                </Typography>
                <Box sx={{ backgroundColor: '#f0fdf4', p: 2, borderRadius: 1 }}>
                  <Stack spacing={1}>
                    <Stack direction="row" justifyContent="space-between">
                      <Typography variant="subtitle2" fontWeight={600}>Time Commitment:</Typography>
                      <Typography>{getTimeCommitmentLabel(job.oneoff_details || job.recurring_details)}</Typography>
                    </Stack>
                    <Stack direction="row" justifyContent="space-between">
                      <Typography variant="subtitle2" fontWeight={600}>Duration:</Typography>
                      <Typography>6 months (March - August 2025)</Typography>
                    </Stack>
                    <Stack direction="row" justifyContent="space-between">
                      <Typography variant="subtitle2" fontWeight={600}>Schedule:</Typography>
                      <Typography>Flexible - mostly {getFrequencyLabel(job.frequency)}</Typography>
                    </Stack>
                    <Stack direction="row" justifyContent="space-between">
                      <Typography variant="subtitle2" fontWeight={600}>Location:</Typography>
                      <Typography>{job.location || 'Location not specified'}</Typography>
                    </Stack>
                    <Stack direction="row" justifyContent="space-between">
                      <Typography variant="subtitle2" fontWeight={600}>Application Deadline:</Typography>
                      <Typography>Ongoing</Typography>
                    </Stack>
                  </Stack>
                </Box>
              </CardContent>
            </Card>

            {/* What You'll Do */}
            <Card sx={{ mb: 3 }}>
              <CardContent>
                <Typography variant="h6" fontWeight="bold" mb={2} sx={{ borderLeft: '4px solid #667eea', pl: 2 }}>
                  What You'll Do
                </Typography>
                <Stack spacing={2}>
                  <Stack direction="row" spacing={2}>
                    <Box sx={{ color: '#1976d2', mt: 0.5 }}>📱</Box>
                    <Typography>Create and schedule daily social media content</Typography>
                  </Stack>
                  <Stack direction="row" spacing={2}>
                    <Box sx={{ color: '#1976d2', mt: 0.5 }}>🎨</Box>
                    <Typography>Design graphics and infographics for campaigns</Typography>
                  </Stack>
                  <Stack direction="row" spacing={2}>
                    <Box sx={{ color: '#1976d2', mt: 0.5 }}>📊</Box>
                    <Typography>Monitor engagement and track campaign performance</Typography>
                  </Stack>
                  <Stack direction="row" spacing={2}>
                    <Box sx={{ color: '#1976d2', mt: 0.5 }}>💬</Box>
                    <Typography>Engage with followers and build community</Typography>
                  </Stack>
                  <Stack direction="row" spacing={2}>
                    <Box sx={{ color: '#1976d2', mt: 0.5 }}>🎯</Box>
                    <Typography>Develop content strategies for major climate events</Typography>
                  </Stack>
                </Stack>
              </CardContent>
            </Card>

            {/* Apply button */}
            {onApply ? (
              <Button 
                variant="contained" 
                size="large" 
                fullWidth 
                onClick={onApply}
                sx={{ 
                  py: 2, 
                  background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                  fontSize: '1.1rem',
                  fontWeight: 600
                }}
              >
                Apply for This Position
              </Button>
            ) : (
              <Button 
                variant="contained" 
                size="large" 
                fullWidth 
                onClick={() => navigate('/signup?role=volunteer')}
                sx={{ 
                  py: 2, 
                  background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                  fontSize: '1.1rem',
                  fontWeight: 600
                }}
              >
                Sign Up to Apply
              </Button>
            )}
            <Typography variant="body2" color="text.secondary" textAlign="center" mt={1}>
              {isGuest ? 'Sign up to apply for this position and start making a difference.' : 'Application responses will be sent via platform messaging'}
              {!isGuest && <><br />Questions? Contact us through our profile</>}
            </Typography>
          </Box>

          {/* Right column - Organization info */}
          <Box flex={1}>
            <Card>
              <CardContent>
                <Stack alignItems="center" spacing={2} mb={3}>
                  <Avatar 
                    sx={{ 
                      width: 80, 
                      height: 80, 
                      backgroundColor: '#667eea',
                      fontSize: '1.5rem',
                      fontWeight: 'bold'
                    }}
                  >
                    {job.organizer?.name ? getOrgInitials(job.organizer.name) : 'OR'}
                  </Avatar>
                  <Box textAlign="center">
                    <Typography variant="h6" fontWeight="bold">
                      {job.organizer?.name || 'Organization'}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      {job.category || 'General'}
                    </Typography>
                  </Box>
                </Stack>

                <Divider sx={{ my: 2 }} />

                <Stack spacing={2}>
                  <Box>
                    <Typography variant="subtitle2" fontWeight={600} color="text.secondary">
                      Mission
                    </Typography>
                    <Typography variant="body2">
                      Making a difference through community engagement and activism.
                    </Typography>
                  </Box>

                  <Box>
                    <Typography variant="subtitle2" fontWeight={600} color="text.secondary">
                      Organization Size
                    </Typography>
                    <Typography variant="body2" color="primary">
                      11-50 active members
                    </Typography>
                  </Box>

                  <Box>
                    <Typography variant="subtitle2" fontWeight={600} color="text.secondary">
                      Main Activities
                    </Typography>
                    <Stack spacing={0.5}>
                      <Typography variant="body2">Digital Campaigns</Typography>
                      <Typography variant="body2">Community Outreach</Typography>
                      <Typography variant="body2">Educational Workshops</Typography>
                    </Stack>
                  </Box>

                  <Box>
                    <Typography variant="subtitle2" fontWeight={600} color="text.secondary">
                      Other Active Campaigns
                    </Typography>
                    <Stack spacing={0.5}>
                      <Stack direction="row" alignItems="center" spacing={1}>
                        <Box sx={{ width: 4, height: 4, borderRadius: '50%', backgroundColor: '#667eea' }} />
                        <Typography variant="body2">Climate Action Initiative</Typography>
                      </Stack>
                      <Stack direction="row" alignItems="center" spacing={1}>
                        <Box sx={{ width: 4, height: 4, borderRadius: '50%', backgroundColor: '#667eea' }} />
                        <Typography variant="body2">Youth Empowerment Program</Typography>
                      </Stack>
                    </Stack>
                  </Box>

                  <Box>
                    <Typography variant="subtitle2" fontWeight={600} color="text.secondary" mb={1}>
                      Connect With Us
                    </Typography>
                    <Stack direction="row" spacing={1}>
                      <IconButton size="small" sx={{ backgroundColor: '#e3f2fd' }}>
                        <Language fontSize="small" color="primary" />
                      </IconButton>
                      <IconButton size="small" sx={{ backgroundColor: '#e3f2fd' }}>
                        <Facebook fontSize="small" color="primary" />
                      </IconButton>
                      <IconButton size="small" sx={{ backgroundColor: '#e3f2fd' }}>
                        <Twitter fontSize="small" color="primary" />
                      </IconButton>
                    </Stack>
                  </Box>
                </Stack>
              </CardContent>
            </Card>
          </Box>
        </Stack>
      </Box>
    </Box>
  );
};

export default JobDetailsPage; 