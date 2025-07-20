import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
  TextField,
  Button,
  FormControl,
  Select,
  MenuItem,
  Stack,
  CircularProgress
} from '@mui/material';
import { skillsService } from '../../../api/services.js';

const RequirementsStep = ({ data, errors, onUpdate, onNext, onBack }) => {
  const [skills, setSkills] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchSkills = async () => {
      try {
        setLoading(true);
        console.log('Fetching skills...');
        const response = await skillsService.getSkills();
        console.log('Skills response:', response);
        
        if (response.success && response.data && response.data.skills) {
          console.log('Setting skills:', response.data.skills);
          setSkills(response.data.skills);
        } else {
          console.error('Skills API failed:', response);
          // Use fallback skills instead of showing error
          setSkills([
            { id: 1, name: 'Graphic Design', category: 'General', is_predefined: true },
            { id: 2, name: 'Social Media Management', category: 'General', is_predefined: true },
            { id: 3, name: 'Translation', category: 'General', is_predefined: true },
            { id: 4, name: 'Public Speaking', category: 'General', is_predefined: true },
            { id: 5, name: 'Event Planning', category: 'General', is_predefined: true },
            { id: 6, name: 'Photography', category: 'General', is_predefined: true },
            { id: 7, name: 'Videography', category: 'General', is_predefined: true },
            { id: 8, name: 'Writing', category: 'General', is_predefined: true },
            { id: 9, name: 'Research', category: 'General', is_predefined: true },
            { id: 10, name: 'Legal Knowledge', category: 'General', is_predefined: true },
            { id: 11, name: 'Medical Training', category: 'General', is_predefined: true },
            { id: 12, name: 'None Required', category: 'General', is_predefined: true },
            { id: 13, name: 'Other', category: 'General', is_predefined: true }
          ]);
        }
      } catch (err) {
        console.error('Error fetching skills:', err);
        // Use fallback skills instead of showing error
        setSkills([
          { id: 1, name: 'Graphic Design', category: 'General', is_predefined: true },
          { id: 2, name: 'Social Media Management', category: 'General', is_predefined: true },
          { id: 3, name: 'Translation', category: 'General', is_predefined: true },
          { id: 4, name: 'Public Speaking', category: 'General', is_predefined: true },
          { id: 5, name: 'Event Planning', category: 'General', is_predefined: true },
          { id: 6, name: 'Photography', category: 'General', is_predefined: true },
          { id: 7, name: 'Videography', category: 'General', is_predefined: true },
          { id: 8, name: 'Writing', category: 'General', is_predefined: true },
          { id: 9, name: 'Research', category: 'General', is_predefined: true },
          { id: 10, name: 'Legal Knowledge', category: 'General', is_predefined: true },
          { id: 11, name: 'Medical Training', category: 'General', is_predefined: true },
          { id: 12, name: 'None Required', category: 'General', is_predefined: true },
          { id: 13, name: 'Other', category: 'General', is_predefined: true }
        ]);
      } finally {
        setLoading(false);
      }
    };

    fetchSkills();
  }, []);

  const handleChange = (field, value) => {
    onUpdate({ [field]: value });
  };

  const handleSubmit = () => {
    // Basic validation
    const newErrors = {};
    
    // Only require skills if they were loaded successfully
    if (skills.length > 0 && (!data.skillsRequired || data.skillsRequired.length === 0)) {
      newErrors.skillsRequired = 'Please select at least one skill';
    }
    
    if (!data.volunteersNeeded?.trim()) {
      newErrors.volunteersNeeded = 'Please specify number of volunteers needed';
    }

    if (Object.keys(newErrors).length === 0) {
      onNext();
    }
  };

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" minHeight={200}>
        <CircularProgress />
      </Box>
    );
  }



  console.log('RequirementsStep render:', { skills, loading, data });
  
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
              <MenuItem key={skill.id} value={skill.name}>
                {skill.name}
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