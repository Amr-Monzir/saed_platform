import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import LoginPage from '../pages/login/LoginPage';
import SignupPage from '../pages/signup/SignupPage';
import OrganizationSignupPage from '../pages/signup/OrganizationSignupPage';
import VolunteerSignupPage from '../pages/signup/VolunteerSignupPage';
import OrganizationDashboard from '../pages/organization/OrganizationDashboard';
import VolunteerDashboard from '../pages/volunteer/VolunteerDashboard';
import GuestJobsPage from '../pages/guest/GuestJobsPage';
import GuestJobDetailsPage from '../pages/guest/GuestJobDetailsPage';
import CreateJobPage from '../pages/organization/CreateJobPage';
import MyJobsPage from '../pages/organization/MyJobsPage';
import ApplicationsPage from '../pages/organization/ApplicationsPage';
import OrganizationProfilePage from '../pages/organization/OrganizationProfilePage';
import VolunteerJobDetailsPage from '../pages/volunteer/VolunteerJobDetailsPage';
import VolunteerMyJobsPage from '../pages/volunteer/VolunteerMyJobsPage';
import VolunteerProfilePage from '../pages/volunteer/VolunteerProfilePage';
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
    <Route path="/signup/organization" element={<OrganizationSignupPage />} />
    <Route path="/signup/volunteer" element={<VolunteerSignupPage />} />
    <Route path="/guest/jobs" element={<GuestJobsPage />} />
    <Route path="/guest/jobs/:jobId" element={<GuestJobDetailsPage />} />
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
      <Route path="profile" element={<OrganizationProfilePage />} />
    </Route>
    <Route
      path="/volunteer/*"
      element={
        <ProtectedRoute role="volunteer">
          <VolunteerDashboard />
        </ProtectedRoute>
      }
    />
    <Route path="/volunteer/jobs/:jobId" element={<VolunteerJobDetailsPage />} />
    <Route path="/volunteer/my-jobs" element={<VolunteerMyJobsPage />} />
    <Route path="/volunteer/profile" element={<VolunteerProfilePage />} />
    <Route path="*" element={<Navigate to="/login" replace />} />
  </Routes>
);

export default AppRoutes; 