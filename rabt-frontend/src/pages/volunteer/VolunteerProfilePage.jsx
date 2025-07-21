import React, { useState } from 'react';
import {
  Box,
  Typography,
  Paper,
  Stack,
  TextField,
  Button,
  Chip,
  Autocomplete,
  AppBar,
  Toolbar,
  IconButton,
  Drawer
} from '@mui/material';
import { Menu as MenuIcon } from '@mui/icons-material';
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
  const [sideMenuOpen, setSideMenuOpen] = useState(false);
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
    <Box sx={{ backgroundColor: '#f8f9fa', minHeight: '100vh' }}>
      {/* Top App Bar */}
      <AppBar position="static" elevation={0} sx={{ backgroundColor: 'white', color: 'text.primary' }}>
        <Toolbar>
          <IconButton
            edge="start"
            onClick={() => setSideMenuOpen(true)}
            sx={{ mr: 2 }}
          >
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" sx={{ flexGrow: 1 }}>
            My Profile
          </Typography>
        </Toolbar>
      </AppBar>

      {/* Side Menu Drawer */}
      <Drawer
        anchor="left"
        open={sideMenuOpen}
        onClose={() => setSideMenuOpen(false)}
        sx={{
          '& .MuiDrawer-paper': {
            width: 280,
            boxSizing: 'border-box',
          },
        }}
      >
        <VolunteerSideMenu selectedPath={location.pathname} />
      </Drawer>

      {/* Main content */}
      <Box p={3}>
        <Box maxWidth={600} mx="auto">
          <Paper elevation={3} sx={{ borderRadius: 4, p: 4, background: '#fafbfc' }}>
            <Typography variant="h4" mb={3}>My Profile</Typography>
            <form onSubmit={handleSubmit}>
              <Stack spacing={3}>
                <TextField
                  label="Full Name"
                  name="name"
                  value={form.name}
                  onChange={handleChange}
                  fullWidth
                  required
                />
                <TextField
                  label="Bio / Description"
                  name="description"
                  value={form.description}
                  onChange={handleChange}
                  fullWidth
                  multiline
                  rows={4}
                  placeholder="Tell us about yourself and your interests..."
                />
                <Autocomplete
                  multiple
                  options={allSkills}
                  value={form.skills}
                  onChange={handleSkillsChange}
                  renderTags={(value, getTagProps) =>
                    value.map((option, index) => (
                      <Chip variant="outlined" label={option} {...getTagProps({ index })} key={index} />
                    ))
                  }
                  renderInput={(params) => (
                    <TextField {...params} label="Skills" placeholder="Select your skills" />
                  )}
                />
                <Button
                  type="submit"
                  variant="contained"
                  disabled={saving}
                  sx={{ py: 1.5 }}
                >
                  {saving ? 'Saving...' : saved ? 'Saved!' : 'Save Profile'}
                </Button>
              </Stack>
            </form>
          </Paper>
        </Box>
      </Box>
    </Box>
  );
};

export default VolunteerProfilePage; 