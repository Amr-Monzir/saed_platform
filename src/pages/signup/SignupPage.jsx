import React, { useState } from 'react';
import {
  Box, Button, Typography, Stack, TextField, ToggleButton, ToggleButtonGroup, InputLabel, MenuItem, Select, OutlinedInput, Checkbox, ListItemText, Avatar, Alert
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

// Mock org verification DB
const orgVerifications = {};

const SignupPage = () => {
  const [role, setRole] = useState('volunteer');
  const [form, setForm] = useState({
    name: '',
    email: '',
    password: '',
    description: '',
    skills: [],
    logo: '',
    website: '',
    facebookId: '',
    twitter: '',
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [orgSubmitted, setOrgSubmitted] = useState(false);
  const [orgEmailToVerify, setOrgEmailToVerify] = useState('');
  const navigate = useNavigate();
  const { login } = useAuth();

  const handleRoleChange = (_, newRole) => {
    if (newRole) {
      setRole(newRole);
      setForm({ name: '', email: '', password: '', description: '', skills: [], logo: '', website: '', facebookId: '', twitter: '' });
      setError('');
      setOrgSubmitted(false);
    }
  };

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
    if (role === 'organization') {
      if (!form.name) return 'Organization name is required';
      if (!form.description) return 'Description is required';
      if (!form.website) return 'Website is required';
      if (!form.email) return 'Admin email is required';
      if (!form.password) return 'Password is required';
      // Email format check
      if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(form.email)) return 'Invalid email';
    } else {
      if (!form.name) return 'Name is required';
      if (!form.email) return 'Email is required';
      if (!form.password) return 'Password is required';
      if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(form.email)) return 'Invalid email';
    }
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
    if (role === 'organization') {
      // Mock: org@example.com is always verified, others must verify
      if (form.email === 'org@example.com') {
        login({ role: 'organization', organizationId: 101, email: form.email, name: form.name });
        navigate('/organization');
      } else {
        // Mock: send verification email
        orgVerifications[form.email] = false;
        setOrgSubmitted(true);
        setOrgEmailToVerify(form.email);
      }
    } else {
      // Volunteer: log in directly
      login({ role: 'volunteer', email: form.email, name: form.name });
      navigate('/volunteer');
    }
    setLoading(false);
  };

  const handleVerifyOrg = () => {
    // Mock: mark as verified
    orgVerifications[orgEmailToVerify] = true;
    login({ role: 'organization', organizationId: 999, email: orgEmailToVerify, name: form.name });
    navigate('/organization');
  };

  return (
    <Box display="flex" flexDirection="column" alignItems="center" justifyContent="center" minHeight="100vh">
      <Typography variant="h4" mb={4}>Sign Up</Typography>
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
      {orgSubmitted ? (
        <Box width={350}>
          <Alert severity="info" sx={{ mb: 2 }}>
            A verification email has been sent to <b>{orgEmailToVerify}</b>.<br />
            Please verify your email before logging in.
          </Alert>
          <Button variant="contained" color="primary" fullWidth onClick={handleVerifyOrg}>
            (Mock) I have verified my email
          </Button>
        </Box>
      ) : (
        <form onSubmit={handleSubmit} style={{ width: 350 }}>
          <Stack spacing={2}>
            <TextField
              label={role === 'organization' ? 'Organization Name' : 'Name'}
              name="name"
              value={form.name}
              onChange={handleChange}
              required
              fullWidth
            />
            {role === 'organization' && (
              <>
                <TextField
                  label="Description"
                  name="description"
                  value={form.description}
                  onChange={handleChange}
                  required
                  fullWidth
                  multiline
                  minRows={2}
                />
                <TextField
                  label="Website"
                  name="website"
                  value={form.website}
                  onChange={handleChange}
                  required
                  fullWidth
                />
                <TextField
                  label="Facebook ID (optional)"
                  name="facebookId"
                  value={form.facebookId}
                  onChange={handleChange}
                  fullWidth
                />
                <TextField
                  label="Twitter Link (optional)"
                  name="twitter"
                  value={form.twitter}
                  onChange={handleChange}
                  fullWidth
                />
                <Box display="flex" alignItems="center" gap={2}>
                  <Button variant="outlined" component="label">
                    Upload Logo
                    <input type="file" accept="image/*" hidden onChange={handleLogoChange} />
                  </Button>
                  {form.logo && <Avatar src={form.logo} alt="Logo" sx={{ width: 48, height: 48 }} />}
                </Box>
              </>
            )}
            {role === 'volunteer' && (
              <>
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
              </>
            )}
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
      )}
    </Box>
  );
};

export default SignupPage; 