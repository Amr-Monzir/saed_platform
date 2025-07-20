import React, { useState } from "react";
import {
  Box,
  Typography,
  Button,
  Stepper,
  Step,
  StepLabel,
  Snackbar,
  Alert,
} from "@mui/material";
import { useNavigate } from "react-router-dom";
import { advertService } from "../../api/services.js";

// Import step components
import BasicInformationStep from "./steps/BasicInformationStep";
import RequirementsStep from "./steps/RequirementsStep";
import LogisticsStep from "./steps/LogisticsStep";
import ScreeningStep from "./steps/ScreeningStep";
import SchedulingStep from "./steps/SchedulingStep";

const steps = [
  "Basic Information",
  "Requirements",
  "Logistics",
  "Screening",
  "Scheduling",
];

const CreateJobPage = () => {
  const navigate = useNavigate();
  const [activeStep, setActiveStep] = useState(0);
  const [loading, setLoading] = useState(false);
  const [snackbar, setSnackbar] = useState({
    open: false,
    message: "",
    severity: "success",
  });

  // All form data state
  const [formData, setFormData] = useState({
    // Step 1: Basic Info
    frequency: "Single event/role",
    category: "",
    title: "",
    description: "",
    image: null, // File object for image upload

    // Step 2: Requirements
    skillsRequired: [],
    volunteersNeeded: "",

    // Step 3: Logistics
    locationType: "on-site",
    locationDetails: "",

    // Step 4: Screening
    selectedQuestions: [],
    customQuestions: [""],

    // Step 5: Scheduling
    eventDate: null,
    startTime: "",
    endTime: "",
    deadline: null,
    timeCommitment: "",
    recurrence: "",
    duration: "",
    daysOfWeek: [],
  });

  const [errors, setErrors] = useState({});

  const updateFormData = (stepData) => {
    setFormData((prev) => ({ ...prev, ...stepData }));
  };

  const handleNext = () => {
    setActiveStep((prev) => prev + 1);
    setErrors({});
  };

  const handleBack = () => {
    setActiveStep((prev) => prev - 1);
    setErrors({});
  };

  const handleStepClick = (stepIndex) => {
    setActiveStep(stepIndex);
    setErrors({});
  };

  const transformFormDataToAPI = (data) => {
    // Transform the form data to match the API model
    const apiData = {
      title: data.title,
      description: data.description,
      category: data.category,
      frequency:
        data.frequency === "Single event/role" ? "one-off" : "recurring",
      number_of_volunteers: parseInt(data.volunteersNeeded) || 1,
      location_type: data.locationType,
      address_text: data.locationDetails || "",
      postcode: "", // Will be filled from location details if available
      latitude: 0,
      longitude: 0,
      advert_image_url: "", // Will be set by the server
      is_active: true,
      required_skills: data.skillsRequired.map((skill) => {
        // If skill is a string (skill name), return it as is
        if (typeof skill === "string") {
          return skill;
        }
        // If skill is an object, return the name
        return skill.name || skill;
      }),
    };

    // Helper function to convert time commitment format
    const convertTimeCommitment = (timeCommitment) => {
      if (!timeCommitment) return "1-2h";

      // Convert from "1–2 hours" to "1-2h" format
      return timeCommitment
        .replace(/–/g, "-") // Replace en dash with hyphen
        .replace(/\s*hours?/i, "h") // Replace "hours" or "hour" with "h"
        .replace(/\s*\+/g, "+"); // Keep plus sign for "10+"
    };

    // Add frequency-specific details
    if (data.frequency === "Single event/role") {
      // One-off event details
      const eventDateTime = new Date(data.eventDate);
      if (data.startTime) {
        eventDateTime.setHours(
          data.startTime.getHours(),
          data.startTime.getMinutes(),
        );
      }

      apiData.oneoff_details = {
        event_datetime: eventDateTime.toISOString(),
        time_commitment: convertTimeCommitment(data.timeCommitment),
        application_deadline: data.deadline
          ? data.deadline.toISOString()
          : null,
      };
    } else {
      // Recurring event details
      apiData.recurring_details = {
        recurrence: data.recurrence?.toLowerCase() || "weekly",
        time_commitment_per_session: convertTimeCommitment(data.timeCommitment),
        duration: data.duration?.toLowerCase().replace(" ", "") || "1month",
        specific_days:
          data.daysOfWeek?.map((day) => ({
            day: day.toLowerCase(),
            periods: ["am", "pm"], // Default periods
          })) || [],
      };
    }

    return apiData;
  };

  const handleSave = async () => {
    setLoading(true);
    try {
      console.log("Submitting job with data:", formData);

      // Transform form data to API format
      const apiData = transformFormDataToAPI(formData);
      console.log("Transformed API data:", apiData);

      // Submit to API
      const response = await advertService.createAdvert(
        apiData,
        formData.image,
      );

      if (response.success) {
        setSnackbar({
          open: true,
          message: "Job created successfully!",
          severity: "success",
        });
        // Navigate to My Jobs page after a short delay
        setTimeout(() => {
          navigate("/organization/my-jobs");
        }, 2000);
      } else {
        setSnackbar({
          open: true,
          message: response.error?.message || "Failed to create job",
          severity: "error",
        });
      }
    } catch (error) {
      console.error("Error creating job:", error);
      setSnackbar({
        open: true,
        message: "An error occurred while creating the job",
        severity: "error",
      });
    } finally {
      setLoading(false);
    }
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
            loading={loading}
          />
        );
      default:
        return <div>Invalid step</div>;
    }
  };

  return (
    <Box display="flex" sx={{ height: "100vh", overflow: "hidden" }}>
      {/* Left sidebar - Fixed */}
      <Box
        sx={{
          width: 300,
          backgroundColor: "#f5f5f7",
          p: 3,
          borderRight: "1px solid #e0e0e0",
          flexShrink: 0,
          overflow: "hidden",
        }}
      >
        <Typography variant="h6" mb={2}>
          Role/Event Title
        </Typography>
        <Typography variant="body2" color="text.secondary" mb={3}>
          📅 Mon, 21 July 2025, 6pm
        </Typography>

        <Typography variant="h6" mb={2} color="text.secondary">
          STEPS
        </Typography>
        <Box>
          {steps.map((step, index) => (
            <Box
              key={step}
              display="flex"
              alignItems="center"
              mb={1.5}
              onClick={() => handleStepClick(index)}
              sx={{
                color: index <= activeStep ? "#333" : "#999",
                fontWeight: index === activeStep ? "bold" : "normal",
                cursor: "pointer",
              }}
            >
              <Box
                sx={{
                  width: 20,
                  height: 20,
                  borderRadius: "50%",
                  border: "2px solid",
                  borderColor: index <= activeStep ? "#6366f1" : "#ccc",
                  backgroundColor:
                    index < activeStep ? "#6366f1" : "transparent",
                  mr: 2,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                }}
              >
                {index < activeStep && (
                  <Typography variant="caption" color="white" fontSize="12px">
                    ✓
                  </Typography>
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
          backgroundColor: "#f8f9fa",
          overflow: "auto",
          height: "100vh",
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
                "& .MuiStepIcon-root": {
                  color: "#e0e0e0",
                  "&.Mui-active": {
                    color: "#6366f1",
                  },
                  "&.Mui-completed": {
                    color: "#6366f1",
                  },
                },
                "& .MuiStep-root": {
                  cursor: "pointer",
                },
              }}
            >
              {steps.map((label, index) => (
                <Step key={label} onClick={() => handleStepClick(index)}>
                  <StepLabel>{label}</StepLabel>
                </Step>
              ))}
            </Stepper>

            {/* Step content */}
            {renderStepContent()}
          </Box>
        </Box>
      </Box>

      {/* Snackbar for notifications */}
      <Snackbar
        open={snackbar.open}
        autoHideDuration={6000}
        onClose={() => setSnackbar({ ...snackbar, open: false })}
        anchorOrigin={{ vertical: "top", horizontal: "right" }}
      >
        <Alert
          onClose={() => setSnackbar({ ...snackbar, open: false })}
          severity={snackbar.severity}
          sx={{ width: "100%" }}
        >
          {snackbar.message}
        </Alert>
      </Snackbar>
    </Box>
  );
};

export default CreateJobPage;
