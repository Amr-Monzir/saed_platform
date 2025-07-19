import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import LoginPage from '../pages/login/LoginPage';
import SignupPage from '../pages/signup/SignupPage';
import OrganizationDashboard from '../pages/organization/OrganizationDashboard';
import VolunteerDashboard from '../pages/volunteer/VolunteerDashboard';
import GuestJobsPage from '../pages/guest/GuestJobsPage';
import CreateJobPage from '../pages/organization/CreateJobPage';
import MyJobsPage from '../pages/organization/MyJobsPage';
import ApplicationsPage from '../pages/organization/ApplicationsPage';
import { useAuth } from '../contexts/useAuth';

const ProtectedRoute = ({ children, role }) => {
  const { user } = useAuth();
  if (!user || (role && user.role !== role)) {
    return <Navigate to="/login" replace />;
  }
  return children;
};

const AppRoutes = () => (
  <Routes>
    <Route path="/login" element={<LoginPage />} />
    <Route path="/signup" element={<SignupPage />} />
    <Route path="/guest/jobs" element={<GuestJobsPage />} />
    <Route
      path="/organization/*"
      element={
        <ProtectedRoute role="organization">
          <OrganizationDashboard />
        </ProtectedRoute>
      }
    >
      <Route index element={<MyJobsPage />} />
      <Route path="create-job" element={<CreateJobPage />} />
      <Route path="applications" element={<ApplicationsPage />} />
    </Route>
    <Route
      path="/volunteer/*"
      element={
        <ProtectedRoute role="volunteer">
          <VolunteerDashboard />
        </ProtectedRoute>
      }
    />
    <Route path="*" element={<Navigate to="/login" replace />} />
  </Routes>
);

export default AppRoutes; 