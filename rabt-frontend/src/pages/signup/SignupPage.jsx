import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Box, Typography, ToggleButton, ToggleButtonGroup } from '@mui/material';

const SignupPage = () => {
  const [role, setRole] = React.useState('volunteer');
  const navigate = useNavigate();

  const handleRoleChange = (_, newRole) => {
    if (newRole) {
      setRole(newRole);
      if (newRole === 'organization') {
        navigate('/signup/organization');
      } else {
        navigate('/signup/volunteer');
      }
    }
  };

  return (
    <Box display="flex" flexDirection="column" alignItems="center" justifyContent="center" minHeight="100vh">
      <Typography variant="h4" mb={2}>Sign Up</Typography>
      <Typography variant="subtitle1" mb={4} color="text.secondary" maxWidth={500} textAlign="center">
        Connect with supporters who share your cause<br />
        Join the platform where Palestinian campaign organisers find skilled volunteers ready to make a difference
      </Typography>
      <ToggleButtonGroup
        value={role}
        exclusive
        onChange={handleRoleChange}
        fullWidth
        sx={{ mb: 3, maxWidth: 400 }}
      >
        <ToggleButton value="volunteer">Volunteer</ToggleButton>
        <ToggleButton value="organization">Organization</ToggleButton>
      </ToggleButtonGroup>
    </Box>
  );
};

export default SignupPage; 