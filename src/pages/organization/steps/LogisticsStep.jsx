import React from 'react';
import {
  Box,
  Typography,
  TextField,
  Button,
  FormControlLabel,
  Radio,
  RadioGroup,
  FormControl
} from '@mui/material';
import { Search } from '@mui/icons-material';

const LogisticsStep = ({ data, errors, onUpdate, onNext, onBack }) => {
  const handleChange = (field, value) => {
    onUpdate({ [field]: value });
  };

  const handleSubmit = () => {
    // Basic validation
    const newErrors = {};
    if (!data.locationType) {
      newErrors.locationType = 'Please select a location type';
    }

    if (Object.keys(newErrors).length === 0) {
      onNext();
    }
  };

  return (
    <Box>
      {/* Location Type */}
      <Box mb={4}>
        <Typography variant="h6" mb={3}>
          Location
        </Typography>
        
        <FormControl component="fieldset">
          <RadioGroup
            row
            value={data.locationType || ''}
            onChange={(e) => handleChange('locationType', e.target.value)}
            sx={{ gap: 4 }}
          >
            <FormControlLabel 
              value="venue" 
              control={
                <Radio 
                  sx={{
                    color: '#d1d5db',
                    '&.Mui-checked': {
                      color: '#6366f1',
                    },
                  }}
                />
              } 
              label={
                <Box>
                  <Typography variant="body1" fontWeight="500">
                    🏢 Venue
                  </Typography>
                </Box>
              }
            />
            <FormControlLabel 
              value="online" 
              control={
                <Radio 
                  sx={{
                    color: '#d1d5db',
                    '&.Mui-checked': {
                      color: '#6366f1',
                    },
                  }}
                />
              } 
              label={
                <Box>
                  <Typography variant="body1" fontWeight="500">
                    💻 Online
                  </Typography>
                </Box>
              }
            />
            <FormControlLabel 
              value="tba" 
              control={
                <Radio 
                  sx={{
                    color: '#d1d5db',
                    '&.Mui-checked': {
                      color: '#6366f1',
                    },
                  }}
                />
              } 
              label={
                <Box>
                  <Typography variant="body1" fontWeight="500">
                    📍 To be announced
                  </Typography>
                </Box>
              }
            />
          </RadioGroup>
        </FormControl>
        
        {errors.locationType && (
          <Typography color="error" variant="body2" mt={1}>
            {errors.locationType}
          </Typography>
        )}
      </Box>

      {/* Location Search and Map - only show if venue is selected */}
      {data.locationType === 'venue' && (
        <Box mb={4}>
          <TextField
            fullWidth
            placeholder="Set approximate location for the role/event"
            value={data.locationDetails || ''}
            onChange={(e) => handleChange('locationDetails', e.target.value)}
            InputProps={{
              startAdornment: <Search sx={{ color: '#9ca3af', mr: 1 }} />
            }}
            sx={{ 
              backgroundColor: 'white',
              mb: 3
            }}
          />
          
          {/* Map placeholder */}
          <Box
            sx={{
              height: 400,
              borderRadius: 2,
              overflow: 'hidden',
              border: '1px solid #e5e7eb',
              position: 'relative',
              background: `
                linear-gradient(45deg, #f3f4f6 25%, transparent 25%),
                linear-gradient(-45deg, #f3f4f6 25%, transparent 25%),
                linear-gradient(45deg, transparent 75%, #f3f4f6 75%),
                linear-gradient(-45deg, transparent 75%, #f3f4f6 75%)
              `,
              backgroundSize: '20px 20px',
              backgroundPosition: '0 0, 0 10px, 10px -10px, -10px 0px'
            }}
          >
            {/* Map content - this would be replaced with actual map component */}
            <Box
              sx={{
                position: 'absolute',
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                background: `url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1000 600'%3E%3Cpath d='M0,0 L200,100 L400,50 L600,150 L800,80 L1000,120 L1000,600 L0,600 Z' fill='%23e0f2fe'/%3E%3Cpath d='M0,100 L150,200 L350,180 L550,250 L750,200 L1000,240 L1000,600 L0,600 Z' fill='%23b3e5fc'/%3E%3C/svg%3E") center/cover`,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
              }}
            >
              {/* Road network overlay */}
              <Box
                sx={{
                  position: 'absolute',
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  background: `
                    linear-gradient(90deg, transparent 48%, #666 48%, #666 52%, transparent 52%),
                    linear-gradient(0deg, transparent 48%, #666 48%, #666 52%, transparent 52%),
                    linear-gradient(45deg, transparent 48%, #666 48%, #666 52%, transparent 52%),
                    linear-gradient(-45deg, transparent 48%, #666 48%, #666 52%, transparent 52%)
                  `,
                  backgroundSize: '100px 100px, 100px 100px, 141px 141px, 141px 141px',
                  opacity: 0.3
                }}
              />
              
              {/* Location markers */}
              <Box
                sx={{
                  position: 'absolute',
                  top: '30%',
                  left: '40%',
                  width: 30,
                  height: 30,
                  backgroundColor: '#ef4444',
                  borderRadius: '50% 50% 50% 0',
                  transform: 'rotate(-45deg)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  '&::after': {
                    content: '"📍"',
                    transform: 'rotate(45deg)',
                    fontSize: '12px'
                  }
                }}
              />
              
              {/* Area labels */}
              <Typography
                variant="h4"
                sx={{
                  position: 'absolute',
                  top: '45%',
                  left: '45%',
                  fontWeight: 'bold',
                  color: '#1f2937',
                  textShadow: '2px 2px 4px rgba(255,255,255,0.8)'
                }}
              >
                London
              </Typography>
              
              {/* Neighborhood labels */}
              <Typography
                variant="body2"
                sx={{
                  position: 'absolute',
                  top: '25%',
                  left: '25%',
                  fontWeight: '500',
                  color: '#4b5563',
                  backgroundColor: 'rgba(255,255,255,0.8)',
                  px: 1,
                  borderRadius: 1
                }}
              >
                KENSINGTON
              </Typography>
              
              <Typography
                variant="body2"
                sx={{
                  position: 'absolute',
                  top: '60%',
                  left: '60%',
                  fontWeight: '500',
                  color: '#4b5563',
                  backgroundColor: 'rgba(255,255,255,0.8)',
                  px: 1,
                  borderRadius: 1
                }}
              >
                BRIXTON
              </Typography>
              
              {/* Road labels */}
              <Box
                sx={{
                  position: 'absolute',
                  top: '20%',
                  right: '10%',
                  backgroundColor: '#22c55e',
                  color: 'white',
                  px: 1,
                  py: 0.5,
                  borderRadius: 1,
                  fontSize: '12px',
                  fontWeight: 'bold'
                }}
              >
                A11
              </Box>
              
              <Box
                sx={{
                  position: 'absolute',
                  bottom: '30%',
                  left: '20%',
                  backgroundColor: '#22c55e',
                  color: 'white',
                  px: 1,
                  py: 0.5,
                  borderRadius: 1,
                  fontSize: '12px',
                  fontWeight: 'bold'
                }}
              >
                A205
              </Box>
            </Box>
          </Box>
        </Box>
      )}

      {/* Navigation Buttons */}
      <Box display="flex" justifyContent="flex-end" gap={2}>
        <Button
          variant="outlined"
          onClick={onBack}
          sx={{
            borderColor: '#d1d5db',
            color: '#6b7280',
            px: 4,
            py: 1.5
          }}
        >
          Back
        </Button>
        <Button
          variant="contained"
          onClick={handleSubmit}
          sx={{
            backgroundColor: '#6366f1',
            '&:hover': {
              backgroundColor: '#5856eb',
            },
            px: 4,
            py: 1.5
          }}
        >
          Next
        </Button>
      </Box>
    </Box>
  );
};

export default LogisticsStep; 