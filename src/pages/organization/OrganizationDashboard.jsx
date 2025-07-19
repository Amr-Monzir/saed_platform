import React from 'react';
import { Box, Drawer, List, ListItemButton, ListItemIcon, ListItemText, Typography } from '@mui/material';
import WorkIcon from '@mui/icons-material/Work';
import AddCircleIcon from '@mui/icons-material/AddCircle';
import SettingsIcon from '@mui/icons-material/Settings';
import LogoutIcon from '@mui/icons-material/Logout';
import AssignmentIndIcon from '@mui/icons-material/AssignmentInd';
import { useNavigate, useLocation, Outlet } from 'react-router-dom';

const drawerWidth = 240;
const sidebarItems = [
  { label: 'My Jobs', path: '/organization', icon: <WorkIcon /> },
  { label: 'Create Job', path: '/organization/create-job', icon: <AddCircleIcon /> },
  { label: 'Applications', path: '/organization/applications', icon: <AssignmentIndIcon /> },
  { label: 'Settings', path: '/organization/settings', icon: <SettingsIcon /> },
];
const logoutItem = { label: 'Logout', path: '/login', icon: <LogoutIcon /> };

const OrganizationDashboard = () => {
  const navigate = useNavigate();
  const location = useLocation();
  return (
    <Box display="flex">
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
            {sidebarItems.map((item) => {
              const selected =
                item.path === '/organization'
                  ? location.pathname === '/organization'
                  : location.pathname.startsWith(item.path);
              return (
                <ListItemButton
                  key={item.label}
                  selected={selected}
                  onClick={() => navigate(item.path)}
                  sx={{ mb: 1, mx: 2, borderRadius: 2 }}
                >
                  <ListItemIcon>{item.icon}</ListItemIcon>
                  <ListItemText primary={item.label} />
                </ListItemButton>
              );
            })}
          </List>
          <Box sx={{ mb: 3, mx: 2 }}>
            <ListItemButton
              selected={location.pathname === logoutItem.path}
              onClick={() => navigate(logoutItem.path)}
              sx={{ borderRadius: 2 }}
            >
              <ListItemIcon>{logoutItem.icon}</ListItemIcon>
              <ListItemText primary={logoutItem.label} />
            </ListItemButton>
          </Box>
        </Box>
      </Drawer>
      <Box component="main" flex={1} sx={{ ml: 2, p: 3 }}>
        <Outlet />
      </Box>
    </Box>
  );
};

export default OrganizationDashboard; 