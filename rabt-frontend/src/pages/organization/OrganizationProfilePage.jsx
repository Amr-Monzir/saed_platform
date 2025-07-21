import React, { useState } from 'react';
import {
  Box,
  Typography,
  TextField,
  Button,
  Paper,
  Stack,
  IconButton,
  Avatar
} from '@mui/material';
import {
  ArrowBack,
  PhotoCamera,
  Facebook,
  Twitter
} from '@mui/icons-material';
import { useNavigate } from 'react-router-dom';

const OrganizationProfilePage = () => {
  const navigate = useNavigate();
  const [profileData, setProfileData] = useState({
    organizerName: 'Eventbrite Careers',
    website: 'https://www.eventbritecareers.com/home',
    facebookId: '152983809050993318',
    twitterHandle: 'EventbriteLife'
  });

  const handleInputChange = (field) => (event) => {
    setProfileData({
      ...profileData,
      [field]: event.target.value
    });
  };

  const handleImageUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
      console.log('Image uploaded:', file.name);
      // Here you would typically upload to your backend
    }
  };

  const handleSave = () => {
    console.log('Saving profile data:', profileData);
    // Here you would typically save to your backend
    alert('Profile saved successfully!');
  };

  const handleCancel = () => {
    navigate('/organization');
  };

  return (
    <Box sx={{ backgroundColor: '#f8f9fa', minHeight: '100vh', p: 4 }}>
      <Box sx={{ maxWidth: 800, mx: 'auto' }}>
        {/* Header */}
        <Stack direction="row" alignItems="center" mb={3}>
          <IconButton 
            onClick={() => navigate('/organization')} 
            sx={{ 
              mr: 2,
              color: '#6366f1',
              '&:hover': {
                backgroundColor: 'rgba(99, 102, 241, 0.1)'
              }
            }}
          >
            <ArrowBack />
          </IconButton>
          <Typography 
            variant="body2" 
            sx={{ 
              color: '#6366f1',
              textDecoration: 'underline',
              cursor: 'pointer',
              '&:hover': {
                color: '#4f46e5'
              }
            }}
          >
            Organization Settings
          </Typography>
        </Stack>

        <Typography variant="h4" fontWeight="bold" mb={4} sx={{ color: '#1f2937' }}>
          Add Organizer Profile
        </Typography>

        {/* Profile Image Section */}
        <Paper 
          sx={{ 
            p: 4, 
            mb: 3, 
            borderRadius: 3,
            boxShadow: '0 1px 3px 0 rgb(0 0 0 / 0.1)',
            border: '1px solid #f3f4f6'
          }}
        >
          <Stack direction="row" alignItems="flex-start" spacing={3}>
            <Box
              sx={{
                width: 60,
                height: 60,
                borderRadius: 2,
                backgroundColor: '#f3f4f6',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
              }}
            >
              <PhotoCamera sx={{ color: '#9ca3af', fontSize: 28 }} />
            </Box>
            <Box flex={1}>
              <Typography variant="h6" fontWeight="600" mb={1} sx={{ color: '#1f2937' }}>
                Organizer profile image
              </Typography>
              <Typography variant="body2" color="#6b7280" mb={3}>
                This is the first image attendees will see at the top of your profile. Use a high quality square image.
              </Typography>
              
              <Paper
                sx={{
                  border: '2px dashed #d1d5db',
                  borderRadius: 2,
                  p: 4,
                  textAlign: 'center',
                  backgroundColor: '#f9fafb',
                  cursor: 'pointer',
                  transition: 'all 0.2s ease',
                  '&:hover': {
                    backgroundColor: '#f3f4f6',
                    borderColor: '#6366f1'
                  }
                }}
                onClick={() => document.getElementById('image-upload').click()}
              >
                <PhotoCamera sx={{ fontSize: 48, color: '#d1d5db', mb: 2 }} />
                <Typography variant="h6" mb={1} sx={{ color: '#374151', fontWeight: 500 }}>
                  Drag & drop or click to add
                </Typography>
                <Typography variant="h6" mb={1} sx={{ color: '#374151', fontWeight: 500 }}>
                  profile image.
                </Typography>
                <Typography variant="body2" sx={{ color: '#6b7280' }}>
                  JPEG or PNG, no larger than 10MB.
                </Typography>
                <input
                  id="image-upload"
                  type="file"
                  accept="image/*"
                  onChange={handleImageUpload}
                  style={{ display: 'none' }}
                />
              </Paper>
            </Box>
          </Stack>
        </Paper>

        {/* About the Organizer */}
        <Paper 
          sx={{ 
            p: 4, 
            mb: 3, 
            borderRadius: 3,
            boxShadow: '0 1px 3px 0 rgb(0 0 0 / 0.1)',
            border: '1px solid #f3f4f6'
          }}
        >
          <Stack direction="row" alignItems="flex-start" spacing={3}>
            <Box
              sx={{
                width: 48,
                height: 48,
                borderRadius: 2,
                backgroundColor: '#f3f4f6',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
              }}
            >
              <Typography variant="h6" sx={{ fontSize: '20px' }}>👤</Typography>
            </Box>
            <Box flex={1}>
              <Typography variant="h6" fontWeight="600" mb={1} sx={{ color: '#1f2937' }}>
                About the organizer
              </Typography>
              <Typography variant="body2" sx={{ color: '#6b7280', mb: 3 }}>
                Let attendees know who is hosting events. 
                <Typography 
                  component="span" 
                  sx={{ 
                    color: '#6366f1',
                    textDecoration: 'underline',
                    cursor: 'pointer',
                    ml: 0.5,
                    '&:hover': {
                      color: '#4f46e5'
                    }
                  }}
                >
                  Learn More
                </Typography>
              </Typography>
              
              <TextField
                fullWidth
                label="Organizer name"
                placeholder="e.g. Eventbrite Careers"
                value={profileData.organizerName}
                onChange={handleInputChange('organizerName')}
                sx={{ 
                  mb: 3,
                  '& .MuiOutlinedInput-root': {
                    borderRadius: 2,
                    backgroundColor: 'white',
                    '&:hover fieldset': {
                      borderColor: '#6366f1'
                    },
                    '&.Mui-focused fieldset': {
                      borderColor: '#6366f1'
                    }
                  },
                  '& .MuiInputLabel-root.Mui-focused': {
                    color: '#6366f1'
                  }
                }}
              />
              
              <TextField
                fullWidth
                label="Your website"
                placeholder="e.g. https://www.eventbritecareers.com/home"
                value={profileData.website}
                onChange={handleInputChange('website')}
                sx={{
                  '& .MuiOutlinedInput-root': {
                    borderRadius: 2,
                    backgroundColor: 'white',
                    '&:hover fieldset': {
                      borderColor: '#6366f1'
                    },
                    '&.Mui-focused fieldset': {
                      borderColor: '#6366f1'
                    }
                  },
                  '& .MuiInputLabel-root.Mui-focused': {
                    color: '#6366f1'
                  }
                }}
              />
            </Box>
          </Stack>
        </Paper>

        {/* Social Media and Marketing */}
        <Paper 
          sx={{ 
            p: 4, 
            mb: 4, 
            borderRadius: 3,
            boxShadow: '0 1px 3px 0 rgb(0 0 0 / 0.1)',
            border: '1px solid #f3f4f6'
          }}
        >
          <Stack direction="row" alignItems="flex-start" spacing={3}>
            <Box
              sx={{
                width: 48,
                height: 48,
                borderRadius: 2,
                backgroundColor: '#f3f4f6',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
              }}
            >
              <Typography variant="h6" sx={{ fontSize: '20px' }}>📱</Typography>
            </Box>
            <Box flex={1}>
              <Typography variant="h6" fontWeight="600" mb={1} sx={{ color: '#1f2937' }}>
                Social media and marketing
              </Typography>
              <Typography variant="body2" sx={{ color: '#6b7280', mb: 3 }}>
                Let attendees know how to connect with you
              </Typography>
              
              <Stack direction="row" alignItems="center" spacing={2} mb={3}>
                <Facebook sx={{ color: '#1877f2', fontSize: 24 }} />
                <TextField
                  fullWidth
                  label="Facebook ID"
                  placeholder="e.g. 152983809050993318"
                  value={profileData.facebookId}
                  onChange={handleInputChange('facebookId')}
                  sx={{
                    '& .MuiOutlinedInput-root': {
                      borderRadius: 2,
                      backgroundColor: 'white',
                      '&:hover fieldset': {
                        borderColor: '#6366f1'
                      },
                      '&.Mui-focused fieldset': {
                        borderColor: '#6366f1'
                      }
                    },
                    '& .MuiInputLabel-root.Mui-focused': {
                      color: '#6366f1'
                    }
                  }}
                />
              </Stack>
              
              <Stack direction="row" alignItems="center" spacing={2}>
                <Twitter sx={{ color: '#1da1f2', fontSize: 24 }} />
                <Typography variant="body1" sx={{ color: '#374151', fontWeight: 500 }}>@</Typography>
                <TextField
                  fullWidth
                  label="Twitter"
                  placeholder="e.g. EventbriteLife"
                  value={profileData.twitterHandle}
                  onChange={handleInputChange('twitterHandle')}
                  sx={{
                    '& .MuiOutlinedInput-root': {
                      borderRadius: 2,
                      backgroundColor: 'white',
                      '&:hover fieldset': {
                        borderColor: '#6366f1'
                      },
                      '&.Mui-focused fieldset': {
                        borderColor: '#6366f1'
                      }
                    },
                    '& .MuiInputLabel-root.Mui-focused': {
                      color: '#6366f1'
                    }
                  }}
                />
              </Stack>
            </Box>
          </Stack>
        </Paper>

        {/* Action Buttons */}
        <Stack direction="row" spacing={2} justifyContent="flex-end">
          <Button
            variant="outlined"
            onClick={handleCancel}
            sx={{
              borderColor: '#d1d5db',
              color: '#6b7280',
              textTransform: 'none',
              px: 4,
              py: 1.5,
              borderRadius: 2,
              fontWeight: 500,
              '&:hover': {
                borderColor: '#9ca3af',
                backgroundColor: '#f9fafb'
              }
            }}
          >
            Cancel
          </Button>
          <Button
            variant="contained"
            onClick={handleSave}
            sx={{
              backgroundColor: '#6366f1',
              color: 'white',
              textTransform: 'none',
              px: 4,
              py: 1.5,
              borderRadius: 2,
              fontWeight: 500,
              boxShadow: '0 1px 2px 0 rgb(0 0 0 / 0.05)',
              '&:hover': {
                backgroundColor: '#4f46e5',
                boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)'
              }
            }}
          >
            Save
          </Button>
        </Stack>
      </Box>
    </Box>
  );
};

export default OrganizationProfilePage; 