import React, { useState } from 'react';
import { 
  Box, 
  Drawer, 
  List, 
  ListItemButton, 
  ListItemIcon, 
  ListItemText, 
  Typography,
  AppBar,
  Toolbar,
  IconButton
} from '@mui/material';
import WorkIcon from '@mui/icons-material/Work';
import AddCircleIcon from '@mui/icons-material/AddCircle';
import SettingsIcon from '@mui/icons-material/Settings';
import LogoutIcon from '@mui/icons-material/Logout';
import AssignmentIndIcon from '@mui/icons-material/AssignmentInd';
import PersonIcon from '@mui/icons-material/Person';
import { Menu as MenuIcon } from '@mui/icons-material';
import { useNavigate, useLocation, Outlet } from 'react-router-dom';

const drawerWidth = 280;
const sidebarItems = [
  { label: 'My Jobs', path: '/organization', icon: <WorkIcon /> },
  { label: 'Create Job', path: '/organization/create-job', icon: <AddCircleIcon /> },
  { label: 'Applications', path: '/organization/applications', icon: <AssignmentIndIcon /> },
  { label: 'Profile', path: '/organization/profile', icon: <PersonIcon /> },
  { label: 'Settings', path: '/organization/settings', icon: <SettingsIcon /> },
];
const logoutItem = { label: 'Logout', path: '/login', icon: <LogoutIcon /> };

const OrganizationDashboard = () => {
  const navigate = useNavigate();
  const location = useLocation();
  const [sideMenuOpen, setSideMenuOpen] = useState(false);

  const SideMenuContent = () => (
    <>
      <Box sx={{ px: 3, pt: 4, pb: 2 }}>
        <Typography variant="h4" fontWeight="bold" color="primary" letterSpacing={2}>
          Rabt
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
                onClick={() => {
                  navigate(item.path);
                  setSideMenuOpen(false);
                }}
                sx={{ mb: 1, mx: 2, borderRadius: 2 }}
              >
                <ListItemIcon>{item.icon}</ListItemIcon>
                <ListItemText primary={item.label} />
              </ListItemButton>
            );
          })}
        </List>
        <List sx={{ mt: 'auto', pb: 2 }}>
          <ListItemButton
            onClick={() => {
              navigate(logoutItem.path);
              setSideMenuOpen(false);
            }}
            sx={{ mb: 1, mx: 2, borderRadius: 2 }}
          >
            <ListItemIcon>{logoutItem.icon}</ListItemIcon>
            <ListItemText primary={logoutItem.label} />
          </ListItemButton>
        </List>
      </Box>
    </>
  );

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
            Organization Dashboard
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
            width: drawerWidth,
            boxSizing: 'border-box',
            display: 'flex',
            flexDirection: 'column'
          },
        }}
      >
        <SideMenuContent />
      </Drawer>

      {/* Main content */}
      <Box>
        <Outlet />
      </Box>
    </Box>
  );
};

export default OrganizationDashboard; 