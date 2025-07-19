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
import { login as apiLogin } from '../../api/index.js';

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
    const role = tab === 0 ? 'volunteer' : 'organization';
    const res = await apiLogin({ ...form, role });
    setLoading(false);
    if (res.success) {
      login(res.user);
      if (role === 'organization') navigate('/organization');
      else navigate('/volunteer');
    } else {
      setError(res.error);
    }
  };

  return (
    <Box display="flex" flexDirection="column" alignItems="center" justifyContent="center" minHeight="100vh">
      <Typography variant="h4" mb={4} textAlign="center">
        Welcome to Saed Platform
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