import React from 'react';
import { useLocation } from 'react-router-dom';
import JobDetailsPage from '../../components/JobDetailsPage';
import VolunteerSideMenu from './VolunteerSideMenu';

const VolunteerJobDetailsPage = () => {
  const location = useLocation();

  const handleApply = () => {
    // Handle volunteer application logic here
    console.log('Applying for job...');
  };

  return (
    <JobDetailsPage 
      isGuest={false}
      SideMenu={VolunteerSideMenu}
      selectedPath={location.pathname}
      onApply={handleApply}
    />
  );
};

export default VolunteerJobDetailsPage; 