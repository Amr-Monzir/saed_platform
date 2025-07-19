import React, { useState } from 'react';
import { Box, Typography, Paper, Stack, TextField, Button, Chip, Autocomplete } from '@mui/material';
import { useAuth } from '../../contexts/useAuth';
import { useLocation } from 'react-router-dom';
import VolunteerSideMenu from './VolunteerSideMenu';

const allSkills = [
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

const VolunteerProfilePage = () => {
  const { user, login } = useAuth();
  const location = useLocation();
  const [form, setForm] = useState({
    name: user?.name || '',
    description: user?.description || '',
    skills: user?.skills || [],
  });
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSkillsChange = (event, value) => {
    setForm({ ...form, skills: value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    setSaving(true);
    // Simulate save and update user context
    setTimeout(() => {
      login({ ...user, ...form });
      setSaving(false);
      setSaved(true);
      setTimeout(() => setSaved(false), 2000);
    }, 800);
  };

  return (
    <Box display="flex">
      <VolunteerSideMenu selectedPath={location.pathname} />
      <Box component="main" flex={1} p={4} ml={2}>
        <Box maxWidth={600} mx="auto" mt={4}>
          <Paper elevation={3} sx={{ borderRadius: 4, p: 4, background: '#fafbfc' }}>
            <Typography variant="h4" mb={3}>My Profile</Typography>
            <form onSubmit={handleSubmit}>
              <Stack spacing={3}>
                <TextField
                  label="Name"
                  name="name"
                  value={form.name}
                  onChange={handleChange}
                  required
                  fullWidth
                />
                <TextField
                  label="Email"
                  name="email"
                  value={user?.email || ''}
                  disabled
                  fullWidth
                />
                <TextField
                  label="Description"
                  name="description"
                  value={form.description}
                  onChange={handleChange}
                  multiline
                  minRows={2}
                  fullWidth
                />
                <Autocomplete
                  multiple
                  options={allSkills}
                  value={form.skills}
                  onChange={handleSkillsChange}
                  renderTags={(value, getTagProps) =>
                    value.map((option, index) => (
                      <Chip variant="outlined" label={option} {...getTagProps({ index })} />
                    ))
                  }
                  renderInput={(params) => (
                    <TextField {...params} variant="outlined" label="Skills" placeholder="Select skills" />
                  )}
                  fullWidth
                />
                <Button type="submit" variant="contained" color="primary" disabled={saving}>
                  {saving ? 'Saving...' : 'Save'}
                </Button>
                {saved && <Typography color="success.main">Profile saved!</Typography>}
              </Stack>
            </form>
          </Paper>
        </Box>
      </Box>
    </Box>
  );
};

export default VolunteerProfilePage; 