import React, { useState } from 'react';
import {
  Box, Typography, TextField, Button, MenuItem, Select, InputLabel, FormControl, Checkbox, ListItemText, OutlinedInput, Stack, Stepper, Step, StepLabel, Radio, RadioGroup, FormControlLabel
} from '@mui/material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { format } from 'date-fns';

const categories = [
  'Protest/Rally',
  'Digital Campaign',
  'Community Outreach',
  'Educational Workshop',
  'Fundraising',
  'Media/Communications',
  'Legal Support',
  'Logistics/Operations',
  'Other',
];

const skills = [
  'Graphic Design',
  'Social Media',
  'Translation',
  'Public Speaking',
  'Event Planning',
  'Photography',
  'Writing',
  'Research',
  'Other',
  'No Skills Required',
];

const screeningQuestionsList = [
  'Why do you want to volunteer with us?',
  'Have you volunteered with similar organisations? Please specify which ones and roles.',
  'What specific skills/experience do you bring?',
  'Are you available for training sessions?',
  'Can you commit to our confidentiality policies?',
  'Provide two references from previous volunteer work. Name, organisation, contact info',
];

const steps = [
  'Basic Information',
  'Requirements',
  'Logistics',
  'Screening',
  'Scheduling',
  'Summary',
];

const oneOffTimes = [
  '1–2 hours',
  '3–5 hours',
  '6–10 hours',
  '10+ hours',
];
const recurringTimes = [
  '1–5',
  '6–10',
  '11–20',
  '20+',
];

const CreateJobPage = () => {
  // Stepper state
  const [activeStep, setActiveStep] = useState(0);

  // Step 1: Basic Info
  const [frequency, setFrequency] = useState('One-off');
  const [category, setCategory] = useState('');
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');

  // Step 2: Requirements
  const [skillsRequired, setSkillsRequired] = useState([]);
  const [volunteersNeeded, setVolunteersNeeded] = useState('');

  // Step 3: Logistics
  const [locationType, setLocationType] = useState('venue');

  // Step 4: Screening
  const [selectedQuestions, setSelectedQuestions] = useState([]);
  const [customQuestions, setCustomQuestions] = useState(['']);

  // Step 5: Scheduling
  const [startDate, setStartDate] = useState(null);
  const [startTime, setStartTime] = useState('');
  const [deadline, setDeadline] = useState(null);
  const [timeCommitment, setTimeCommitment] = useState('');

  // Validation errors
  const [errors, setErrors] = useState({});

  // Step validation
  const validateStep = () => {
    const newErrors = {};
    if (activeStep === 0) {
      if (!title) newErrors.title = 'Title required';
      if (!category) newErrors.category = 'Category required';
      if (!description) newErrors.description = 'Description required';
    }
    if (activeStep === 1) {
      if (!skillsRequired.length) newErrors.skillsRequired = 'Select at least one skill';
      if (!volunteersNeeded) newErrors.volunteersNeeded = 'Number required';
    }
    if (activeStep === 2) {
      if (!locationType) newErrors.locationType = 'Location type required';
    }
    if (activeStep === 3) {
      if (!selectedQuestions.length && customQuestions.filter(q => q.trim()).length === 0) {
        newErrors.screening = 'Select or add at least one question';
      }
    }
    if (activeStep === 4) {
      if (!startDate) newErrors.startDate = 'Start date required';
      if (!startTime) newErrors.startTime = 'Start time required';
      if (!deadline) newErrors.deadline = 'Application deadline required';
      if (!timeCommitment) newErrors.timeCommitment = 'Time commitment required';
    }
    return newErrors;
  };

  // Step navigation
  const handleNext = () => {
    const newErrors = validateStep();
    setErrors(newErrors);
    if (Object.keys(newErrors).length === 0) {
      setActiveStep((prev) => prev + 1);
    }
  };
  const handleBack = () => setActiveStep((prev) => prev - 1);

  // Screening custom question handlers
  const handleCustomQuestionChange = (idx, value) => {
    const updated = [...customQuestions];
    updated[idx] = value;
    setCustomQuestions(updated);
  };
  const addCustomQuestion = () => setCustomQuestions([...customQuestions, '']);
  const removeCustomQuestion = (idx) => {
    setCustomQuestions(customQuestions.filter((_, i) => i !== idx));
  };

  // Step content
  const renderStepContent = () => {
    switch (activeStep) {
      case 0:
        return (
          <Stack spacing={3}>
            <FormControl fullWidth required>
              <InputLabel>Frequency</InputLabel>
              <Select value={frequency} label="Frequency" onChange={e => setFrequency(e.target.value)}>
                <MenuItem value="One-off">One-off</MenuItem>
                <MenuItem value="Recurring">Recurring</MenuItem>
              </Select>
            </FormControl>
            <FormControl fullWidth required error={!!errors.category}>
              <InputLabel>Category</InputLabel>
              <Select value={category} label="Category" onChange={e => setCategory(e.target.value)}>
                {categories.map(cat => (
                  <MenuItem key={cat} value={cat}>{cat}</MenuItem>
                ))}
              </Select>
              {errors.category && <Typography color="error">{errors.category}</Typography>}
            </FormControl>
            <TextField
              label="Job Title"
              value={title}
              onChange={e => setTitle(e.target.value)}
              error={!!errors.title}
              helperText={errors.title}
              required
              fullWidth
            />
            <TextField
              label="Description"
              value={description}
              onChange={e => setDescription(e.target.value)}
              error={!!errors.description}
              helperText={errors.description}
              multiline
              minRows={3}
              fullWidth
              required
            />
          </Stack>
        );
      case 1:
        return (
          <Stack spacing={3}>
            <FormControl fullWidth required error={!!errors.skillsRequired}>
              <InputLabel>Skills Required</InputLabel>
              <Select
                multiple
                value={skillsRequired}
                onChange={e => setSkillsRequired(e.target.value)}
                input={<OutlinedInput label="Skills Required" />}
                renderValue={selected => selected.join(', ')}
              >
                {skills.map(skill => (
                  <MenuItem key={skill} value={skill}>
                    <Checkbox checked={skillsRequired.indexOf(skill) > -1} />
                    <ListItemText primary={skill} />
                  </MenuItem>
                ))}
              </Select>
              {errors.skillsRequired && <Typography color="error">{errors.skillsRequired}</Typography>}
            </FormControl>
            <TextField
              label="Number of Volunteers Needed"
              type="number"
              value={volunteersNeeded}
              onChange={e => setVolunteersNeeded(e.target.value)}
              error={!!errors.volunteersNeeded}
              helperText={errors.volunteersNeeded}
              required
              fullWidth
              inputProps={{ min: 1 }}
            />
          </Stack>
        );
      case 2:
        return (
          <Stack spacing={3}>
            <FormControl component="fieldset" required error={!!errors.locationType}>
              <Typography variant="subtitle1" mb={1}>Location</Typography>
              <RadioGroup
                row
                value={locationType}
                onChange={e => setLocationType(e.target.value)}
              >
                <FormControlLabel value="venue" control={<Radio />} label="Venue" />
                <FormControlLabel value="online" control={<Radio />} label="Online" />
                <FormControlLabel value="tba" control={<Radio />} label="To be announced" />
              </RadioGroup>
              {errors.locationType && <Typography color="error">{errors.locationType}</Typography>}
            </FormControl>
            {locationType === 'venue' && (
              <Box>
                <Typography variant="subtitle2" mb={1}>Select Venue Location (optional):</Typography>
                <Box height={300} borderRadius={2} overflow="hidden" border={1} borderColor="grey.300" display="flex" alignItems="center" justifyContent="center" bgcolor="#f5f5f5">
                  <Typography color="text.secondary">[Map placeholder here]</Typography>
                </Box>
              </Box>
            )}
          </Stack>
        );
      case 3:
        return (
          <Stack spacing={3}>
            <Typography variant="h6">Screening Questions</Typography>
            <FormControl error={!!errors.screening}>
              <Stack>
                {screeningQuestionsList.map((q, idx) => (
                  <FormControlLabel
                    key={idx}
                    control={
                      <Checkbox
                        checked={selectedQuestions.includes(q)}
                        onChange={e => {
                          if (e.target.checked) setSelectedQuestions([...selectedQuestions, q]);
                          else setSelectedQuestions(selectedQuestions.filter(sq => sq !== q));
                        }}
                      />
                    }
                    label={q}
                  />
                ))}
              </Stack>
              {errors.screening && <Typography color="error">{errors.screening}</Typography>}
            </FormControl>
            <Typography variant="subtitle1" mt={2}>Add Your Own Questions</Typography>
            <Stack spacing={1}>
              {customQuestions.map((q, idx) => (
                <Box key={idx} display="flex" alignItems="center">
                  <TextField
                    value={q}
                    onChange={e => handleCustomQuestionChange(idx, e.target.value)}
                    placeholder="Enter your question"
                    fullWidth
                  />
                  {customQuestions.length > 1 && (
                    <Button onClick={() => removeCustomQuestion(idx)} color="error" sx={{ ml: 1 }}>Remove</Button>
                  )}
                </Box>
              ))}
              <Button onClick={addCustomQuestion} sx={{ mt: 1 }}>Add Question</Button>
            </Stack>
          </Stack>
        );
      case 4:
        return (
          <LocalizationProvider dateAdapter={AdapterDateFns}>
            <Stack spacing={3}>
              <FormControl fullWidth required error={!!errors.startDate}>
                <DatePicker
                  label="Job Start Date"
                  value={startDate}
                  onChange={setStartDate}
                  inputFormat="dd/MM/yyyy"
                  renderInput={(params) => <TextField {...params} />}
                />
                {errors.startDate && <Typography color="error">{errors.startDate}</Typography>}
              </FormControl>
              <TextField
                label="Job Start Time"
                type="time"
                value={startTime}
                onChange={e => setStartTime(e.target.value)}
                error={!!errors.startTime}
                helperText={errors.startTime}
                required
                fullWidth
                InputLabelProps={{ shrink: true }}
                inputProps={{ step: 300 }}
              />
              <FormControl fullWidth required error={!!errors.deadline}>
                <DatePicker
                  label="Application Deadline"
                  value={deadline}
                  onChange={setDeadline}
                  inputFormat="dd/MM/yyyy"
                  renderInput={(params) => <TextField {...params} />}
                />
                {errors.deadline && <Typography color="error">{errors.deadline}</Typography>}
              </FormControl>
              <FormControl fullWidth required error={!!errors.timeCommitment}>
                <InputLabel>Time Commitment</InputLabel>
                <Select
                  value={timeCommitment}
                  label="Time Commitment"
                  onChange={e => setTimeCommitment(e.target.value)}
                >
                  {(frequency === 'One-off' ? oneOffTimes : recurringTimes).map(tc => (
                    <MenuItem key={tc} value={tc}>{tc}{frequency === 'Recurring' ? ' hours/week' : ''}</MenuItem>
                  ))}
                </Select>
                {errors.timeCommitment && <Typography color="error">{errors.timeCommitment}</Typography>}
              </FormControl>
            </Stack>
          </LocalizationProvider>
        );
      case 5:
        // Summary step
        return (
          <Box>
            <Typography variant="h5" mb={2}>Review Job Details</Typography>
            <Stack spacing={1}>
              <Typography><b>Title:</b> {title}</Typography>
              <Typography><b>Description:</b> {description}</Typography>
              <Typography><b>Frequency:</b> {frequency}</Typography>
              <Typography><b>Category:</b> {category}</Typography>
              <Typography><b>Skills Required:</b> {skillsRequired.join(', ')}</Typography>
              <Typography><b>Volunteers Needed:</b> {volunteersNeeded}</Typography>
              <Typography><b>Location:</b> {locationType}</Typography>
              <Typography><b>Screening Questions:</b> {[...selectedQuestions, ...customQuestions.filter(q => q.trim())].join(' | ')}</Typography>
              <Typography><b>Start Date:</b> {startDate ? format(startDate, 'dd/MM/yyyy') : ''} {startTime}</Typography>
              <Typography><b>Application Deadline:</b> {deadline ? format(deadline, 'dd/MM/yyyy') : ''}</Typography>
              <Typography><b>Time Commitment:</b> {timeCommitment}{frequency === 'Recurring' ? ' hours/week' : ''}</Typography>
            </Stack>
            <Button variant="contained" color="primary" sx={{ mt: 3 }} onClick={() => {
              // Submit logic here
              alert('Job created! (Check console for data)');
              console.log({
                title, description, frequency, category, skillsRequired, volunteersNeeded, locationType,
                screeningQuestions: [...selectedQuestions, ...customQuestions.filter(q => q.trim())],
                startDate, startTime, deadline, timeCommitment
              });
            }}>Submit Job</Button>
          </Box>
        );
      default:
        return <div>Coming soon...</div>;
    }
  };

  return (
    <Box maxWidth={600} mx="auto" p={4}>
      <Typography variant="h4" mb={3}>Create a New Job</Typography>
      <Stepper activeStep={activeStep} alternativeLabel sx={{ mb: 4 }}>
        {steps.map(label => (
          <Step key={label}>
            <StepLabel>{label}</StepLabel>
          </Step>
        ))}
      </Stepper>
      {renderStepContent()}
      <Box mt={4} display="flex" justifyContent="space-between">
        <Button disabled={activeStep === 0} onClick={handleBack}>Back</Button>
        {activeStep < steps.length - 1 && (
          <Button variant="contained" onClick={handleNext}>
            Next
          </Button>
        )}
      </Box>
    </Box>
  );
};

export default CreateJobPage; 