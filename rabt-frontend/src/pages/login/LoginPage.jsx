import React, { useState } from 'react';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Alert from '@mui/material/Alert';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../contexts/useAuth';
import { authService } from '../../api/services.js';
import { setAuthToken } from '../../api/client.js';

const LoginPage = () => {
  const navigate = useNavigate();
  const { login } = useAuth();
  const [tab, setTab] = useState(0); // 0: Volunteer, 1: Organization
  const [form, setForm] = useState({ email: '', password: '' });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleTabChange = (event, newValue) => {
    setTab(newValue);
    setForm({ email: '', password: '' });
    setError('');
  };

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    
    try {
      const role = tab === 0 ? 'volunteer' : 'organization';
      const { success, data, error } = await authService.login(form.email, form.password);
      
      if (success && data) {
        // Store the auth token
        setAuthToken(data.access_token);
        localStorage.setItem('authToken', data.access_token);
        
        // Create login data for context
        const loginData = {
          role: role,
          email: form.email,
          token: data.access_token
        };
        
        // Update auth context and fetch user profile
        const loginResult = await login(loginData);
        
        if (loginResult.success) {
          // Navigate based on role
          if (role === 'organization') {
            navigate('/organization');
          } else {
            navigate('/volunteer');
          }
        } else {
          setError(loginResult.error || 'Failed to fetch user profile.');
        }
      } else {
        setError(error?.message || 'Login failed. Please check your credentials.');
      }
    } catch (err) {
      setError('Network error. Please try again.');
      console.error('Login error:', err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box display="flex" flexDirection="column" alignItems="center" justifyContent="center" minHeight="100vh">
      <Typography variant="h4" mb={4} textAlign="center">
        Welcome to Rabt Platform
      </Typography>
      <Tabs value={tab} onChange={handleTabChange} sx={{ mb: 3, width: 320 }}>
        <Tab label="Volunteer Login" />
        <Tab label="Organization Login" />
      </Tabs>
      <Box component="form" onSubmit={handleSubmit} sx={{ width: 320 }}>
        <TextField
          label="Email"
          name="email"
          type="email"
          value={form.email}
          onChange={handleChange}
          required
          placeholder="Enter your email"
          margin="normal"
          fullWidth
        />
        <TextField
          label="Password"
          name="password"
          type="password"
          value={form.password}
          onChange={handleChange}
          required
          placeholder="Enter your password"
          margin="normal"
          fullWidth
        />
        {error && <Alert severity="error" sx={{ mt: 2 }}>{error}</Alert>}
        <Button type="submit" variant="contained" color="primary" fullWidth sx={{ mt: 2 }} disabled={loading}>
          {loading ? 'Logging in...' : 'Login'}
        </Button>
        <Button variant="outlined" fullWidth sx={{ mt: 1 }} onClick={() => navigate('/guest/jobs')}>
          View Jobs as Guest Volunteer
        </Button>
        <Button variant="text" fullWidth sx={{ mt: 1 }} onClick={() => navigate('/signup')}>
          Sign Up
        </Button>
      </Box>
    </Box>
  );
};

export default LoginPage; 