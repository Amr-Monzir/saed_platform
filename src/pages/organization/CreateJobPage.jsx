import React, { useState } from 'react';
import {
  Box, Typography, Button, Stepper, Step, StepLabel
} from '@mui/material';

// Import step components
import BasicInformationStep from './steps/BasicInformationStep';
import RequirementsStep from './steps/RequirementsStep';
import LogisticsStep from './steps/LogisticsStep';
import ScreeningStep from './steps/ScreeningStep';
import SchedulingStep from './steps/SchedulingStep';

const steps = [
  'Basic Information',
  'Requirements', 
  'Logistics',
  'Screening',
  'Scheduling',
];

const CreateJobPage = () => {
  const [activeStep, setActiveStep] = useState(0);

  // All form data state
  const [formData, setFormData] = useState({
    // Step 1: Basic Info
    frequency: 'Single event/role',
    category: '',
    title: '',
    description: '',

    // Step 2: Requirements
    skillsRequired: [],
    volunteersNeeded: '',

    // Step 3: Logistics
    locationType: 'venue',
    locationDetails: '',

    // Step 4: Screening
    selectedQuestions: [],
    customQuestions: [''],

    // Step 5: Scheduling
    eventDate: null,
    startTime: '',
    endTime: '',
    deadline: null,
    timeCommitment: '',
    recurrence: '',
    duration: '',
    daysOfWeek: [],
  });

  const [errors, setErrors] = useState({});

  const updateFormData = (stepData) => {
    setFormData(prev => ({ ...prev, ...stepData }));
  };

  const handleNext = () => {
    setActiveStep((prev) => prev + 1);
    setErrors({});
  };

  const handleBack = () => {
    setActiveStep((prev) => prev - 1);
    setErrors({});
  };

  const handleSave = () => {
    // Submit logic here
    alert('Job created! (Check console for data)');
    console.log('Form Data:', formData);
  };

  const renderStepContent = () => {
    switch (activeStep) {
      case 0:
        return (
          <BasicInformationStep
            data={formData}
            errors={errors}
            onUpdate={updateFormData}
            onNext={handleNext}
          />
        );
      case 1:
        return (
          <RequirementsStep
            data={formData}
            errors={errors}
            onUpdate={updateFormData}
            onNext={handleNext}
            onBack={handleBack}
          />
        );
      case 2:
        return (
          <LogisticsStep
            data={formData}
            errors={errors}
            onUpdate={updateFormData}
            onNext={handleNext}
            onBack={handleBack}
          />
        );
      case 3:
        return (
          <ScreeningStep
            data={formData}
            errors={errors}
            onUpdate={updateFormData}
            onNext={handleNext}
            onBack={handleBack}
          />
        );
      case 4:
        return (
          <SchedulingStep
            data={formData}
            errors={errors}
            onUpdate={updateFormData}
            onSave={handleSave}
            onBack={handleBack}
          />
        );
      default:
        return <div>Invalid step</div>;
    }
  };

  return (
    <Box display="flex" sx={{ height: '100vh', overflow: 'hidden' }}>
      {/* Left sidebar - Fixed */}
      <Box 
        sx={{ 
          width: 300, 
          backgroundColor: '#f5f5f7', 
          p: 3,
          borderRight: '1px solid #e0e0e0',
          flexShrink: 0,
          overflow: 'hidden'
        }}
      >
        <Typography variant="h6" mb={2}>Role/Event Title</Typography>
        <Typography variant="body2" color="text.secondary" mb={3}>
          📅 Mon, July 21, 2025, 6pm
        </Typography>
        
        <Button 
          variant="outlined" 
          size="small" 
          sx={{ mb: 4, color: '#6366f1', borderColor: '#6366f1' }}
        >
          See draft ▼
        </Button>

        <Typography variant="h6" mb={2} color="text.secondary">STEPS</Typography>
        <Box>
          {steps.map((step, index) => (
            <Box 
              key={step}
              display="flex"
              alignItems="center"
              mb={1.5}
              sx={{ 
                color: index <= activeStep ? '#333' : '#999',
                fontWeight: index === activeStep ? 'bold' : 'normal'
              }}
            >
              <Box
                sx={{
                  width: 20,
                  height: 20,
                  borderRadius: '50%',
                  border: '2px solid',
                  borderColor: index <= activeStep ? '#6366f1' : '#ccc',
                  backgroundColor: index < activeStep ? '#6366f1' : 'transparent',
                  mr: 2,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center'
                }}
              >
                {index < activeStep && (
                  <Typography variant="caption" color="white" fontSize="12px">✓</Typography>
                )}
              </Box>
              <Typography variant="body2">{step}</Typography>
            </Box>
          ))}
        </Box>
      </Box>

      {/* Main content area - Scrollable */}
      <Box 
        flex={1} 
        sx={{ 
          backgroundColor: '#f8f9fa',
          overflow: 'auto',
          height: '100vh'
        }}
      >
        <Box p={4}>
          <Box maxWidth={800}>
            {/* Progress stepper */}
            <Stepper 
              activeStep={activeStep} 
              alternativeLabel 
              sx={{ 
                mb: 4,
                '& .MuiStepIcon-root': {
                  color: '#e0e0e0',
                  '&.Mui-active': {
                    color: '#6366f1',
                  },
                  '&.Mui-completed': {
                    color: '#6366f1',
                  },
                },
              }}
            >
              {steps.map(label => (
                <Step key={label}>
                  <StepLabel>{label}</StepLabel>
                </Step>
              ))}
            </Stepper>

            {/* Step content */}
            {renderStepContent()}
          </Box>
        </Box>
      </Box>
    </Box>
  );
};

export default CreateJobPage; 