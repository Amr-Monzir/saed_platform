import React, { useState } from 'react';
import {
  Box, Button, Typography, Stack, TextField, InputLabel, MenuItem, Select, OutlinedInput, Checkbox, ListItemText, Avatar, Alert
} from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../contexts/useAuth';

const skillsList = [
  'Graphic Design',
  'Social Media',
  'Translation',
  'Public Speaking',
  'Event Planning',
  'Photography',
  'Writing',
  'Research',
  'Other',
];

const VolunteerSignupPage = () => {
  const [form, setForm] = useState({
    name: '',
    email: '',
    password: '',
    description: '',
    skills: [],
    logo: '',
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();
  const { login } = useAuth();

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSkillsChange = (e) => {
    setForm({ ...form, skills: e.target.value });
  };

  const handleLogoChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (ev) => setForm(f => ({ ...f, logo: ev.target.result }));
      reader.readAsDataURL(file);
    } else {
      setForm(f => ({ ...f, logo: '' }));
    }
  };

  const validate = () => {
    if (!form.name) return 'Name is required';
    if (!form.email) return 'Email is required';
    if (!form.password) return 'Password is required';
    if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(form.email)) return 'Invalid email';
    return '';
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    const err = validate();
    if (err) {
      setError(err);
      setLoading(false);
      return;
    }
    // Volunteer: log in directly
    login({ role: 'volunteer', email: form.email, name: form.name });
    navigate('/volunteer');
    setLoading(false);
  };

  return (
    <Box display="flex" flexDirection="column" alignItems="center" justifyContent="center" minHeight="100vh">
      <Typography variant="h4" mb={2}>Volunteer Sign Up</Typography>
      <Typography variant="subtitle1" mb={4} color="text.secondary" maxWidth={500} textAlign="center">
        Connect with supporters who share your cause<br />
        Join the platform where Palestinian campaign organisers find skilled volunteers ready to make a difference
      </Typography>
      <form onSubmit={handleSubmit} style={{ width: 350 }}>
        <Stack spacing={2}>
          <TextField
            label="Name"
            name="name"
            value={form.name}
            onChange={handleChange}
            required
            fullWidth
          />
          <InputLabel id="skills-label">Skills</InputLabel>
          <Select
            labelId="skills-label"
            multiple
            name="skills"
            value={form.skills}
            onChange={handleSkillsChange}
            input={<OutlinedInput label="Skills" />}
            renderValue={selected => selected.join(', ')}
            fullWidth
          >
            {skillsList.map(skill => (
              <MenuItem key={skill} value={skill}>
                <Checkbox checked={form.skills.indexOf(skill) > -1} />
                <ListItemText primary={skill} />
              </MenuItem>
            ))}
          </Select>
          <TextField
            label="Short Description"
            name="description"
            value={form.description}
            onChange={handleChange}
            fullWidth
            multiline
            minRows={2}
          />
          <Box display="flex" alignItems="center" gap={2}>
            <Button variant="outlined" component="label">
              Upload Avatar
              <input type="file" accept="image/*" hidden onChange={handleLogoChange} />
            </Button>
            {form.logo && <Avatar src={form.logo} alt="Avatar" sx={{ width: 48, height: 48 }} />}
          </Box>
          <TextField
            label="Email"
            name="email"
            type="email"
            value={form.email}
            onChange={handleChange}
            required
            fullWidth
          />
          <TextField
            label="Password"
            name="password"
            type="password"
            value={form.password}
            onChange={handleChange}
            required
            fullWidth
          />
          {error && <Alert severity="error">{error}</Alert>}
          <Button type="submit" variant="contained" color="primary" disabled={loading}>
            {loading ? 'Signing up...' : 'Sign Up'}
          </Button>
        </Stack>
      </form>
    </Box>
  );
};

export default VolunteerSignupPage; 