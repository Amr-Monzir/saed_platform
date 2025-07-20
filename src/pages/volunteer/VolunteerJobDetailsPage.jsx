import React from 'react';
import { useParams, useNavigate, useLocation } from 'react-router-dom';
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
  Drawer
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
  Menu as MenuIcon
} from '@mui/icons-material';
import { mockJobs } from '../../api/index.js';
import VolunteerSideMenu from './VolunteerSideMenu';

// Mock organizer info (in real app, fetch from API)
const mockOrgs = {
  101: {
    name: 'Green Earth Org',
    description: 'A non-profit focused on environmental awareness and community outreach.',
    website: 'https://greenearth.org',
    facebook: 'https://facebook.com/greenearth',
    twitter: 'https://twitter.com/greenearth',
    type: 'Local Environmental Group',
    size: '51-100 active members',
    mission: 'Mobilizing communities for urgent climate action through grassroots campaigns, education, and direct action initiatives.',
    activities: ['Climate Protests', 'Educational Workshops', 'Digital Campaigns', 'Community Outreach'],
    campaigns: ['Stop Airport Expansion', 'Green Transport Initiative', 'Climate Education in Schools']
  },
  102: {
    name: 'Digital Campaigners',
    description: 'Driving change through digital activism and creative campaigns.',
    website: 'https://digitalcampaigners.org',
    facebook: 'https://facebook.com/digitalcampaigners',
    twitter: 'https://twitter.com/digicampaigners',
    type: 'Digital Activism Group',
    size: '11-50 active members',
    mission: 'Amplifying voices for social justice through innovative digital campaigns.',
    activities: ['Digital Campaigns', 'Content Creation', 'Social Media Management'],
    campaigns: ['Digital Rights Campaign', 'Youth Voice Initiative']
  },
  103: {
    name: 'Fundraising Friends',
    description: 'Supporting causes through effective fundraising events.',
    website: 'https://fundraisingfriends.org',
    facebook: 'https://facebook.com/fundraisingfriends',
    twitter: 'https://twitter.com/fundfriends',
    type: 'Fundraising Organization',
    size: '21-50 active members',
    mission: 'Creating impactful fundraising campaigns for social causes.',
    activities: ['Fundraising Events', 'Community Outreach', 'Grant Writing'],
    campaigns: ['Emergency Relief Fund', 'Education Support Campaign']
  },
  104: {
    name: 'Workshop Wizards',
    description: 'Empowering communities with educational workshops.',
    website: 'https://workshopwizards.org',
    facebook: 'https://facebook.com/workshopwizards',
    twitter: 'https://twitter.com/workshopwizards',
    type: 'Educational Organization',
    size: '31-50 active members',
    mission: 'Building community capacity through skill-sharing workshops.',
    activities: ['Educational Workshops', 'Skill Development', 'Community Training'],
    campaigns: ['Digital Literacy Program', 'Leadership Development Initiative']
  },
};

const VolunteerJobDetailsPage = () => {
  const { jobId } = useParams();
  const navigate = useNavigate();
  const location = useLocation();
  const [sideMenuOpen, setSideMenuOpen] = React.useState(false);
  const job = mockJobs.find(j => String(j.id) === String(jobId));
  const org = job ? mockOrgs[job.organizationId] : null;

  if (!job) {
    return <Typography color="error">Job not found.</Typography>;
  }

  const getOrgInitials = (name) => {
    return name.split(' ').map(word => word[0]).join('').substring(0, 2).toUpperCase();
  };

  return (
    <Box sx={{ backgroundColor: '#f5f5f5', minHeight: '100vh' }}>
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
            Job Details
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
              label={`${job.category} • Recurring Position`} 
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
              <Typography>{job.location}</Typography>
            </Stack>
            <Stack direction="row" alignItems="center" spacing={1}>
              <Schedule fontSize="small" />
              <Typography>{job.timeCommitment}</Typography>
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
                    {job.description}
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
                  {job.skills?.map((skill, index) => (
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
                      <Typography>{job.timeCommitment}</Typography>
                    </Stack>
                    <Stack direction="row" justifyContent="space-between">
                      <Typography variant="subtitle2" fontWeight={600}>Duration:</Typography>
                      <Typography>6 months (March - August 2025)</Typography>
                    </Stack>
                    <Stack direction="row" justifyContent="space-between">
                      <Typography variant="subtitle2" fontWeight={600}>Schedule:</Typography>
                      <Typography>Flexible - mostly {job.frequency}</Typography>
                    </Stack>
                    <Stack direction="row" justifyContent="space-between">
                      <Typography variant="subtitle2" fontWeight={600}>Location:</Typography>
                      <Typography>{job.location}</Typography>
                    </Stack>
                    <Stack direction="row" justifyContent="space-between">
                      <Typography variant="subtitle2" fontWeight={600}>Application Deadline:</Typography>
                      <Typography>{job.deadline}</Typography>
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
            <Button 
              variant="contained" 
              size="large" 
              fullWidth 
              sx={{ 
                py: 2, 
                background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                fontSize: '1.1rem',
                fontWeight: 600
              }}
            >
              Apply for This Position
            </Button>
            <Typography variant="body2" color="text.secondary" textAlign="center" mt={1}>
              Application responses will be sent via platform messaging<br />
              Questions? Contact us through our profile
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
                    {org ? getOrgInitials(org.name) : 'OR'}
                  </Avatar>
                  <Box textAlign="center">
                    <Typography variant="h6" fontWeight="bold">
                      {org?.name || 'Organization'}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      {org?.type}
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
                      {org?.mission}
                    </Typography>
                  </Box>

                  <Box>
                    <Typography variant="subtitle2" fontWeight={600} color="text.secondary">
                      Organization Size
                    </Typography>
                    <Typography variant="body2" color="primary">
                      {org?.size}
                    </Typography>
                  </Box>

                  <Box>
                    <Typography variant="subtitle2" fontWeight={600} color="text.secondary">
                      Main Activities
                    </Typography>
                    <Stack spacing={0.5}>
                      {org?.activities?.map((activity, index) => (
                        <Typography key={index} variant="body2">
                          {activity}
                        </Typography>
                      ))}
                    </Stack>
                  </Box>

                  <Box>
                    <Typography variant="subtitle2" fontWeight={600} color="text.secondary">
                      Other Active Campaigns
                    </Typography>
                    <Stack spacing={0.5}>
                      {org?.campaigns?.map((campaign, index) => (
                        <Stack key={index} direction="row" alignItems="center" spacing={1}>
                          <Box sx={{ width: 4, height: 4, borderRadius: '50%', backgroundColor: '#667eea' }} />
                          <Typography variant="body2">{campaign}</Typography>
                        </Stack>
                      ))}
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

export default VolunteerJobDetailsPage; 