import React from 'react';
import {
  Box,
  Typography,
  TextField,
  Button,
  FormControl,
  Select,
  MenuItem,
  Stack
} from '@mui/material';

const skills = [
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

const RequirementsStep = ({ data, errors, onUpdate, onNext, onBack }) => {
  const handleChange = (field, value) => {
    onUpdate({ [field]: value });
  };

  const handleSubmit = () => {
    // Basic validation
    const newErrors = {};
    if (!data.skillsRequired || data.skillsRequired.length === 0) {
      newErrors.skillsRequired = 'Please select at least one skill';
    }
    if (!data.volunteersNeeded?.trim()) {
      newErrors.volunteersNeeded = 'Please specify number of volunteers needed';
    }

    if (Object.keys(newErrors).length === 0) {
      onNext();
    }
  };

  return (
    <Box>
      {/* Skills Required */}
      <Box mb={4}>
        <Typography variant="h6" mb={2}>
          Skills required
        </Typography>
        <FormControl fullWidth>
          <Select
            multiple
            value={data.skillsRequired || []}
            onChange={(e) => handleChange('skillsRequired', e.target.value)}
            displayEmpty
            renderValue={(selected) => {
              if (selected.length === 0) {
                return <span style={{ color: '#9ca3af' }}>Select</span>;
              }
              return selected.join(', ');
            }}
            sx={{ backgroundColor: 'white' }}
          >
            {skills.map((skill) => (
              <MenuItem key={skill} value={skill}>
                {skill}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
        {errors.skillsRequired && (
          <Typography color="error" variant="body2" mt={1}>
            {errors.skillsRequired}
          </Typography>
        )}
      </Box>

      {/* Volunteers Needed */}
      <Box mb={4}>
        <Typography variant="h6" mb={2}>
          Volunteers needs
        </Typography>
        <TextField
          fullWidth
          placeholder="Add a number of volunteers you need"
          type="number"
          value={data.volunteersNeeded || ''}
          onChange={(e) => handleChange('volunteersNeeded', e.target.value)}
          error={!!errors.volunteersNeeded}
          helperText={errors.volunteersNeeded}
          inputProps={{ min: 1 }}
          sx={{ backgroundColor: 'white' }}
        />
      </Box>

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

export default RequirementsStep; 