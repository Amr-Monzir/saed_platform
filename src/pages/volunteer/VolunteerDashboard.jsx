import React from 'react';
import { Box, Drawer, List, ListItem, ListItemText, Typography } from '@mui/material';

const drawerWidth = 240;
const sidebarItems = [
  'Jobs',
  'Profile',
  'Settings',
  'Logout',
];

const VolunteerDashboard = () => {
  return (
    <Box display="flex">
      <Drawer
        variant="permanent"
        anchor="left"
        sx={{
          width: drawerWidth,
          flexShrink: 0,
          [`& .MuiDrawer-paper`]: { width: drawerWidth, boxSizing: 'border-box' },
        }}
      >
        <List>
          {sidebarItems.map((text) => (
            <ListItem button key={text}>
              <ListItemText primary={text} />
            </ListItem>
          ))}
        </List>
      </Drawer>
      <Box component="main" flex={1} p={4} ml={`${drawerWidth}px`}>
        <Typography variant="h4">Volunteer Dashboard</Typography>
        <Typography mt={2}>Welcome! Here you can browse jobs and manage your profile.</Typography>
      </Box>
    </Box>
  );
};

export default VolunteerDashboard; 