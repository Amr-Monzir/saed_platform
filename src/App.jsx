import React from "react";
import { BrowserRouter as Router } from "react-router-dom";
import CssBaseline from "@mui/material/CssBaseline";
import { AuthProvider } from "./contexts/AuthContext";
import { useAuth } from "./contexts/useAuth";
import AppRoutes from "./routes/AppRoutes";
import { Box, CircularProgress, Typography } from "@mui/material";
import "./App.css";

import AppTheme from "./themes/AppTheme";
// Loading component for auth check
const AuthLoadingScreen = () => (
  <Box
    display="flex"
    flexDirection="column"
    alignItems="center"
    justifyContent="center"
    minHeight="100vh"
    gap={2}
  >
    <CircularProgress size={60} />
    <Typography variant="h6" color="text.secondary">
      Loading...
    </Typography>
  </Box>
);

// App content that uses auth context
const AppContent = () => {
  const { loading } = useAuth();

  if (loading) {
    return <AuthLoadingScreen />;
  }

  return <AppRoutes />;
};

function App() {
  return (
    <AppTheme>
      <CssBaseline enableColorScheme />

      {/*<ThemeProvider theme={theme}>*/}
      <AuthProvider>
        <Router>
          <AppContent />
        </Router>
      </AuthProvider>
      {/* </ThemeProvider> */}
    </AppTheme>
  );
}

export default App;
