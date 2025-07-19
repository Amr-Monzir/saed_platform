import React from 'react';
import { Drawer, Box, Typography, List, ListItemButton, ListItemIcon, ListItemText } from '@mui/material';
import WorkIcon from '@mui/icons-material/Work';
import PersonIcon from '@mui/icons-material/Person';
import SettingsIcon from '@mui/icons-material/Settings';
import LogoutIcon from '@mui/icons-material/Logout';
import { useNavigate } from 'react-router-dom';

const drawerWidth = 240;
const sidebarItems = [
  { label: 'Jobs', path: '/volunteer', icon: <WorkIcon /> },
  { label: 'My Jobs', path: '/volunteer/my-jobs', icon: <PersonIcon /> },
  { label: 'Profile', path: '/volunteer/profile', icon: <PersonIcon /> },
  { label: 'Settings', path: '/volunteer/settings', icon: <SettingsIcon /> },
];
const logoutItem = { label: 'Logout', path: '/login', icon: <LogoutIcon /> };

const VolunteerSideMenu = ({ selectedPath }) => {
  const navigate = useNavigate();
  return (
    <Drawer
      variant="permanent"
      anchor="left"
      sx={{
        width: drawerWidth,
        flexShrink: 0,
        [`& .MuiDrawer-paper`]: { width: drawerWidth, boxSizing: 'border-box', display: 'flex', flexDirection: 'column' },
      }}
    >
      <Box sx={{ px: 3, pt: 4, pb: 2 }}>
        <Typography variant="h4" fontWeight="bold" color="primary" letterSpacing={2}>
          Saed
        </Typography>
      </Box>
      <Box sx={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
        <List sx={{ flex: 1, pt: 2 }}>
          {sidebarItems.map((item) => (
            <ListItemButton
              key={item.label}
              selected={selectedPath === item.path}
              onClick={() => navigate(item.path)}
              sx={{ mb: 1, mx: 2, borderRadius: 2 }}
            >
              <ListItemIcon>{item.icon}</ListItemIcon>
              <ListItemText primary={item.label} />
            </ListItemButton>
          ))}
        </List>
        <Box sx={{ mb: 3, mx: 2 }}>
          <ListItemButton
            selected={selectedPath === logoutItem.path}
            onClick={() => navigate(logoutItem.path)}
            sx={{ borderRadius: 2 }}
          >
            <ListItemIcon>{logoutItem.icon}</ListItemIcon>
            <ListItemText primary={logoutItem.label} />
          </ListItemButton>
        </Box>
      </Box>
    </Drawer>
  );
};

export default VolunteerSideMenu; 