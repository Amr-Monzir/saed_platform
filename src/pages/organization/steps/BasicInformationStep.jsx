import React from 'react';
import {
  Box,
  Typography,
  TextField,
  Button,
  FormControl,
  MenuItem,
  Select,
} from '@mui/material';

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

const BasicInformationStep = ({ data, errors, onUpdate, onNext }) => {
  const [imagePreview, setImagePreview] = React.useState(null);

  const handleChange = (field, value) => {
    onUpdate({ [field]: value });
  };

  const handleSubmit = () => {
    // Basic validation
    const newErrors = {};
    if (!data.title?.trim()) newErrors.title = 'Title is required';
    if (!data.category) newErrors.category = 'Category is required';
    if (!data.description?.trim()) newErrors.description = 'Description is required';

    if (Object.keys(newErrors).length === 0) {
      onNext();
    }
  };

  return (
    <Box>
      {/* Frequency Selection */}
      <Box mb={4}>
        <Typography variant="h6" mb={3}>
          Frequency
        </Typography>
        <Box display="flex" gap={2}>
          <Box
            onClick={() => handleChange('frequency', 'Single event/role')}
            sx={{
              flex: 1,
              p: 3,
              border: '2px solid',
              borderColor: data.frequency === 'Single event/role' ? '#6366f1' : '#e5e7eb',
              borderRadius: 2,
              cursor: 'pointer',
              backgroundColor: data.frequency === 'Single event/role' ? '#f0f0ff' : 'transparent',
              position: 'relative'
            }}
          >
            <Box
              sx={{
                position: 'absolute',
                top: 12,
                right: 12,
                width: 20,
                height: 20,
                borderRadius: '50%',
                border: '2px solid #6366f1',
                backgroundColor: data.frequency === 'Single event/role' ? '#6366f1' : 'transparent',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
              }}
            >
              {data.frequency === 'Single event/role' && (
                <Box
                  sx={{
                    width: 8,
                    height: 8,
                    borderRadius: '50%',
                    backgroundColor: 'white'
                  }}
                />
              )}
            </Box>
            <Typography variant="h6" color="#6366f1" mb={1}>
              Single event/role
            </Typography>
            <Typography variant="body2" color="text.secondary">
              One-off event
            </Typography>
          </Box>

          <Box
            onClick={() => handleChange('frequency', 'Recurring event/role')}
            sx={{
              flex: 1,
              p: 3,
              border: '2px solid',
              borderColor: data.frequency === 'Recurring event/role' ? '#6366f1' : '#e5e7eb',
              borderRadius: 2,
              cursor: 'pointer',
              backgroundColor: data.frequency === 'Recurring event/role' ? '#f0f0ff' : 'transparent',
              position: 'relative'
            }}
          >
            <Box
              sx={{
                position: 'absolute',
                top: 12,
                right: 12,
                width: 20,
                height: 20,
                borderRadius: '50%',
                border: '2px solid #6366f1',
                backgroundColor: data.frequency === 'Recurring event/role' ? '#6366f1' : 'transparent',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
              }}
            >
              {data.frequency === 'Recurring event/role' && (
                <Box
                  sx={{
                    width: 8,
                    height: 8,
                    borderRadius: '50%',
                    backgroundColor: 'white'
                  }}
                />
              )}
            </Box>
            <Typography variant="h6" mb={1}>
              Recurring event/role
            </Typography>
            <Typography variant="body2" color="text.secondary">
              Happens in multiple days
            </Typography>
          </Box>
        </Box>
      </Box>

      {/* Category */}
      <Box mb={4}>
        <Typography variant="h6" mb={2}>
          Category
        </Typography>
        <FormControl fullWidth>
          <Select
            value={data.category || ''}
            onChange={(e) => handleChange('category', e.target.value)}
            displayEmpty
            sx={{ backgroundColor: 'white' }}
          >
            <MenuItem value="" disabled>
              Select
            </MenuItem>
            {categories.map((cat) => (
              <MenuItem key={cat} value={cat}>
                {cat}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
        {errors.category && (
          <Typography color="error" variant="body2" mt={1}>
            {errors.category}
          </Typography>
        )}
      </Box>

      {/* Title */}
      <Box mb={4}>
        <Typography variant="h6" mb={1}>
          Title
        </Typography>
        <Typography variant="body2" color="text.secondary" mb={2}>
          Be clear and descriptive with a title that tells people what your role/event is about
        </Typography>
        <TextField
          fullWidth
          placeholder="Title"
          value={data.title || ''}
          onChange={(e) => handleChange('title', e.target.value)}
          error={!!errors.title}
          helperText={errors.title}
          sx={{ backgroundColor: 'white' }}
        />
      </Box>

      {/* Description */}
      <Box mb={4}>
        <Typography variant="h6" mb={1}>
          Description
        </Typography>
        <Typography variant="body2" color="text.secondary" mb={2}>
          Grab people's attention with a description
        </Typography>
        <TextField
          fullWidth
          multiline
          rows={4}
          placeholder="Description"
          value={data.description || ''}
          onChange={(e) => handleChange('description', e.target.value)}
          error={!!errors.description}
          helperText={errors.description}
          sx={{ backgroundColor: 'white' }}
        />
      </Box>

      {/* Image Upload */}
      <Box mb={6}>
        <Box
          sx={{
            border: '2px dashed #d1d5db',
            borderRadius: 3,
            p: 6,
            textAlign: 'center',
            backgroundColor: '#f9fafb',
            cursor: 'pointer',
            transition: 'all 0.2s ease',
            '&:hover': {
              backgroundColor: '#f3f4f6',
              borderColor: '#6366f1'
            }
          }}
          onClick={() => document.getElementById('job-image-upload').click()}
        >
          {imagePreview ? (
            /* Image Preview */
            <Box sx={{ position: 'relative', width: '100%', height: 'auto' }}>
              <Box
                component="img"
                src={imagePreview}
                alt="Preview"
                sx={{
                  width: '100%',
                  maxHeight: 300,
                  objectFit: 'cover',
                  borderRadius: 2,
                  mb: 2
                }}
              />
              <Button
                variant="outlined"
                sx={{
                  borderColor: '#6366f1',
                  color: '#6366f1',
                  textTransform: 'none',
                  borderRadius: 2,
                  px: 3,
                  py: 1,
                  '&:hover': {
                    backgroundColor: '#f0f0ff',
                    borderColor: '#5856eb'
                  }
                }}
              >
                Change image
              </Button>
            </Box>
          ) : (
            /* Upload Prompt */
            <>
              <Box
                sx={{
                  width: 80,
                  height: 80,
                  mx: 'auto',
                  mb: 3,
                  backgroundColor: '#e0e7ff',
                  borderRadius: 2,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center'
                }}
              >
                <Box
                  sx={{
                    width: 40,
                    height: 40,
                    backgroundColor: '#6366f1',
                    borderRadius: 1,
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    position: 'relative'
                  }}
                >
                  <Box
                    sx={{
                      width: 24,
                      height: 18,
                      backgroundColor: 'white',
                      borderRadius: '2px',
                      position: 'relative',
                      '&::before': {
                        content: '""',
                        position: 'absolute',
                        top: 4,
                        left: 4,
                        width: 6,
                        height: 6,
                        backgroundColor: '#6366f1',
                        borderRadius: '50%'
                      },
                      '&::after': {
                        content: '""',
                        position: 'absolute',
                        bottom: 2,
                        left: 2,
                        right: 2,
                        height: 8,
                        backgroundColor: '#6366f1',
                        clipPath: 'polygon(0 100%, 40% 20%, 60% 40%, 100% 0, 100% 100%)'
                      }
                    }}
                  />
                </Box>
              </Box>

              <Typography variant="body1" sx={{ color: '#6b7280', mb: 1 }}>
                Click to select an asset or drag and drop in this area
              </Typography>

              <Button
                variant="outlined"
                startIcon={<span style={{ fontSize: '16px' }}>+</span>}
                sx={{
                  borderColor: '#6366f1',
                  color: '#6366f1',
                  textTransform: 'none',
                  borderRadius: 2,
                  px: 3,
                  py: 1,
                  '&:hover': {
                    backgroundColor: '#f0f0ff',
                    borderColor: '#5856eb'
                  }
                }}
              >
                Add image
              </Button>
            </>
          )}

          <input
            id="job-image-upload"
            type="file"
            accept="image/*"
            onChange={(e) => {
              const file = e.target.files[0];
              if (file) {
                console.log('Image uploaded:', file.name);
                // Create preview URL
                const reader = new FileReader();
                reader.onload = (event) => {
                  setImagePreview(event.target.result);
                };
                reader.readAsDataURL(file);
                // Handle the image upload
                handleChange('image', file);
              }
            }}
            style={{ display: 'none' }}
          />
        </Box>
      </Box>

      {/* Next Button */}
      <Box display="flex" justifyContent="flex-end">
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

export default BasicInformationStep; 