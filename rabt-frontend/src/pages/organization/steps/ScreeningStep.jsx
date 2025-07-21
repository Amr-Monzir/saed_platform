import React from "react";
import {
  Box,
  Typography,
  Button,
  FormControl,
  Select,
  MenuItem,
  Checkbox,
  FormControlLabel,
  TextField,
} from "@mui/material";

const predefinedQuestions = [
  "Why do you want to volunteer with us?",
  "Have you volunteered with similar organisations? Please specify which ones and roles.",
  "What specific skills/experience do you bring?",
  "Are you available for training sessions?",
  "Can you commit to our confidentiality policies?",
  "Provide two references from previous volunteer work. Name, organisation, contact info",
];

const ScreeningStep = ({ data, onUpdate, onNext, onBack }) => {
  const handleChange = (field, value) => {
    onUpdate({ [field]: value });
  };

  const handleQuestionToggle = (question, checked) => {
    const currentQuestions = data.selectedQuestions || [];
    if (checked) {
      handleChange("selectedQuestions", [...currentQuestions, question]);
    } else {
      handleChange(
        "selectedQuestions",
        currentQuestions.filter((q) => q !== question),
      );
    }
  };

  const handleCustomQuestionChange = (index, value) => {
    const customQuestions = [...(data.customQuestions || [""])];
    customQuestions[index] = value;
    handleChange("customQuestions", customQuestions);
  };

  const addCustomQuestion = () => {
    const customQuestions = [...(data.customQuestions || [""])];
    customQuestions.push("");
    handleChange("customQuestions", customQuestions);
  };

  const removeCustomQuestion = (index) => {
    const customQuestions = [...(data.customQuestions || [""])];
    customQuestions.splice(index, 1);
    handleChange("customQuestions", customQuestions);
  };

  const handleSubmit = () => {
    onNext();
  };

  const handleSkip = () => {
    // Clear all screening questions and proceed
    handleChange("selectedQuestions", []);
    handleChange("customQuestions", [""]);
    onNext();
  };

  return (
    <Box>
      {/* Header */}
      <Box mb={4}>
        <Typography variant="h6" mb={2}>
          Add questions to filter unsuitable applicants
        </Typography>

        <FormControl fullWidth>
          <Select displayEmpty value="" sx={{ backgroundColor: "white" }}>
            <MenuItem value="" disabled>
              Select questions and/or add your own
            </MenuItem>
          </Select>
        </FormControl>
      </Box>

      {/* Predefined Questions */}
      <Box mb={4}>
        {predefinedQuestions.map((question, index) => (
          <Box key={index} display="flex" alignItems="flex-start" mb={2}>
            <Checkbox
              checked={(data.selectedQuestions || []).includes(question)}
              onChange={(e) => handleQuestionToggle(question, e.target.checked)}
              sx={{
                color: "#d1d5db",
                "&.Mui-checked": {
                  color: "#6366f1",
                },
                p: 1,
                mr: 1,
              }}
            />
            <Typography variant="body2" sx={{ flex: 1, mt: 1 }}>
              {question}
            </Typography>
          </Box>
        ))}
      </Box>

      {/* Custom Questions */}
      <Box mb={4}>
        {(data.customQuestions || [""]).map((question, index) => (
          <Box key={index} display="flex" alignItems="flex-start" mb={2}>
            <Checkbox
              checked={question.trim() !== ""}
              sx={{
                color: "#d1d5db",
                "&.Mui-checked": {
                  color: "#6366f1",
                },
                p: 1,
                mr: 1,
                mt: 0.5,
              }}
            />
            <Box sx={{ flex: 1 }}>
              <TextField
                fullWidth
                placeholder="Add own question"
                value={question}
                onChange={(e) =>
                  handleCustomQuestionChange(index, e.target.value)
                }
                sx={{
                  backgroundColor: "white",
                  "& .MuiOutlinedInput-root": {
                    fontSize: "14px",
                  },
                }}
              />
              {(data.customQuestions || []).length > 1 && (
                <Button
                  size="small"
                  onClick={() => removeCustomQuestion(index)}
                  sx={{
                    mt: 1,
                    color: "#ef4444",
                    fontSize: "12px",
                    textTransform: "none",
                  }}
                >
                  Remove
                </Button>
              )}
            </Box>
          </Box>
        ))}

        <Button
          variant="text"
          onClick={addCustomQuestion}
          sx={{
            color: "#6366f1",
            textTransform: "none",
            fontSize: "14px",
            p: 0,
            ml: 6, // Align with the text fields
            "&:hover": {
              backgroundColor: "transparent",
              textDecoration: "underline",
            },
          }}
        >
          + Add another question
        </Button>
      </Box>

      {/* Navigation Buttons */}
      <Box display="flex" justifyContent="space-between" alignItems="center">
        <Button
          variant="text"
          onClick={handleSkip}
          sx={{
            color: "#6b7280",
            textTransform: "none",
            fontSize: "14px",
            "&:hover": {
              backgroundColor: "transparent",
              textDecoration: "underline",
            },
          }}
        >
          Skip
        </Button>

        <Box display="flex" gap={2}>
          <Button
            variant="outlined"
            onClick={onBack}
            sx={{
              borderColor: "#d1d5db",
              color: "#6b7280",
              px: 4,
              py: 1.5,
            }}
          >
            Back
          </Button>
          <Button
            variant="contained"
            onClick={handleSubmit}
            sx={{
              backgroundColor: "#6366f1",
              "&:hover": {
                backgroundColor: "#5856eb",
              },
              px: 4,
              py: 1.5,
            }}
          >
            Next
          </Button>
        </Box>
      </Box>
    </Box>
  );
};

export default ScreeningStep;
