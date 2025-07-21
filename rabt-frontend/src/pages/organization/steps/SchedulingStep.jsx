import React from 'react';
import {
  Box,
  Typography,
  TextField,
  Button,
  FormControl,
  Select,
  MenuItem,
  Stack,
  InputAdornment
} from '@mui/material';
import { DatePicker, TimePicker } from '@mui/x-date-pickers';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { enGB } from 'date-fns/locale';
import { CalendarToday, Schedule } from '@mui/icons-material';

const timeCommitmentOptions = [
  '1–2 hours',
  '3–5 hours', 
  '6–10 hours',
  '10+ hours'
];

const recurringTimeCommitmentOptions = [
  '1–5',
  '6–10',
  '11–20',
  '20+'
];

const recurrenceOptions = [
  'Daily',
  'Weekly',
  'Bi-weekly',
  'Monthly',
  'Custom'
];

const durationOptions = [
  '1 week',
  '2 weeks',
  '1 month',
  '2 months',
  '3 months',
  '6 months',
  '1 year',
  'Ongoing'
];

const daysOfWeekOptions = [
  'Monday',
  'Tuesday', 
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

const SchedulingStep = ({ data, errors, onUpdate, onSave, onBack, loading = false }) => {
  const handleChange = (field, value) => {
    onUpdate({ [field]: value });
  };

  const handleSubmit = () => {
    // Basic validation
    const newErrors = {};
    
    if (data.frequency === 'Single event/role') {
      if (!data.eventDate) newErrors.eventDate = 'Event date is required';
      if (!data.startTime) newErrors.startTime = 'Start time is required';
      if (!data.endTime) newErrors.endTime = 'End time is required';
      if (!data.deadline) newErrors.deadline = 'Application deadline is required';
      if (!data.timeCommitment) newErrors.timeCommitment = 'Time commitment is required';
    } else {
      if (!data.timeCommitment) newErrors.timeCommitment = 'Time commitment is required';
      if (!data.recurrence) newErrors.recurrence = 'Recurrence is required';
      if (!data.duration) newErrors.duration = 'Duration is required';
      if (!data.daysOfWeek || data.daysOfWeek.length === 0) {
        newErrors.daysOfWeek = 'Please select days of the week';
      }
    }

    if (Object.keys(newErrors).length === 0) {
      onSave();
    }
  };

  const isOneOff = data.frequency === 'Single event/role';

  return (
    <LocalizationProvider dateAdapter={AdapterDateFns} adapterLocale={enGB}>
      <Box>
        {isOneOff ? (
          // One-off event layout
          <>
            {/* Date and Time Section */}
            <Box mb={4}>
              <Typography variant="h6" mb={3}>
                Date and Time
              </Typography>
              
              <Stack direction="row" spacing={3} mb={3}>
                <Box flex={1}>
                  <Typography variant="body2" mb={1}>
                    Pick an event date
                  </Typography>
                  <DatePicker
                    value={data.eventDate || null}
                    onChange={(date) => handleChange('eventDate', date)}
                    format="dd/MM/yyyy"
                    renderInput={(params) => (
                      <TextField
                        {...params}
                        fullWidth
                        placeholder="DD/MM/YYYY"
                        sx={{ backgroundColor: 'white' }}
                        InputProps={{
                          ...params.InputProps,
                          startAdornment: (
                            <InputAdornment position="start">
                              <CalendarToday sx={{ color: '#9ca3af' }} />
                            </InputAdornment>
                          )
                        }}
                      />
                    )}
                  />
                  {errors?.eventDate && (
                    <Typography color="error" variant="body2" mt={1}>
                      {errors.eventDate}
                    </Typography>
                  )}
                </Box>
                
                <Box flex={1}>
                  <Typography variant="body2" mb={1}>
                    Start time
                  </Typography>
                  <TimePicker
                    value={data.startTime || null}
                    onChange={(time) => handleChange('startTime', time)}
                    renderInput={(params) => (
                      <TextField
                        {...params}
                        fullWidth
                        placeholder="--:--"
                        sx={{ backgroundColor: 'white' }}
                        InputProps={{
                          ...params.InputProps,
                          startAdornment: (
                            <InputAdornment position="start">
                              <Schedule sx={{ color: '#9ca3af' }} />
                            </InputAdornment>
                          )
                        }}
                      />
                    )}
                  />
                  {errors?.startTime && (
                    <Typography color="error" variant="body2" mt={1}>
                      {errors.startTime}
                    </Typography>
                  )}
                </Box>
                
                <Box flex={1}>
                  <Typography variant="body2" mb={1}>
                    End time
                  </Typography>
                  <TimePicker
                    value={data.endTime || null}
                    onChange={(time) => handleChange('endTime', time)}
                    renderInput={(params) => (
                      <TextField
                        {...params}
                        fullWidth
                        placeholder="--:--"
                        sx={{ backgroundColor: 'white' }}
                        InputProps={{
                          ...params.InputProps,
                          startAdornment: (
                            <InputAdornment position="start">
                              <Schedule sx={{ color: '#9ca3af' }} />
                            </InputAdornment>
                          )
                        }}
                      />
                    )}
                  />
                  {errors?.endTime && (
                    <Typography color="error" variant="body2" mt={1}>
                      {errors.endTime}
                    </Typography>
                  )}
                </Box>
              </Stack>
            </Box>

            {/* Application Deadline */}
            <Box mb={4}>
              <Typography variant="h6" mb={2}>
                Application deadline
              </Typography>
              <DatePicker
                value={data.deadline || null}
                onChange={(date) => handleChange('deadline', date)}
                format="dd/MM/yyyy"
                renderInput={(params) => (
                  <TextField
                    {...params}
                    fullWidth
                    placeholder="DD/MM/YYYY"
                    sx={{ backgroundColor: 'white', maxWidth: 300 }}
                    InputProps={{
                      ...params.InputProps,
                      startAdornment: (
                        <InputAdornment position="start">
                          <CalendarToday sx={{ color: '#9ca3af' }} />
                        </InputAdornment>
                      )
                    }}
                  />
                )}
              />
              {errors?.deadline && (
                <Typography color="error" variant="body2" mt={1}>
                  {errors.deadline}
                </Typography>
              )}
            </Box>

            {/* Time Commitment */}
            <Box mb={4}>
              <Typography variant="h6" mb={2}>
                Time commitment
              </Typography>
              <FormControl sx={{ maxWidth: 300 }}>
                <Select
                  value={data.timeCommitment || ''}
                  onChange={(e) => handleChange('timeCommitment', e.target.value)}
                  displayEmpty
                  sx={{ backgroundColor: 'white' }}
                >
                  <MenuItem value="" disabled>
                    Select time commitment range
                  </MenuItem>
                  {timeCommitmentOptions.map((option) => (
                    <MenuItem key={option} value={option}>
                      {option}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
              {errors?.timeCommitment && (
                <Typography color="error" variant="body2" mt={1}>
                  {errors.timeCommitment}
                </Typography>
              )}
            </Box>
          </>
        ) : (
          // Recurring event layout
          <>
            <Stack direction="row" spacing={3} mb={4}>
              <Box flex={1}>
                <Typography variant="h6" mb={2}>
                  Time commitment
                </Typography>
                <FormControl fullWidth>
                  <Select
                    value={data.timeCommitment || ''}
                    onChange={(e) => handleChange('timeCommitment', e.target.value)}
                    displayEmpty
                    sx={{ backgroundColor: 'white' }}
                  >
                    <MenuItem value="" disabled>
                      Select
                    </MenuItem>
                    {recurringTimeCommitmentOptions.map((option) => (
                      <MenuItem key={option} value={option}>
                        {option} hours/week
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
                {errors?.timeCommitment && (
                  <Typography color="error" variant="body2" mt={1}>
                    {errors.timeCommitment}
                  </Typography>
                )}
              </Box>

              <Box flex={1}>
                <Typography variant="h6" mb={2}>
                  Recurrence
                </Typography>
                <FormControl fullWidth>
                  <Select
                    value={data.recurrence || ''}
                    onChange={(e) => handleChange('recurrence', e.target.value)}
                    displayEmpty
                    sx={{ backgroundColor: 'white' }}
                  >
                    <MenuItem value="" disabled>
                      Select
                    </MenuItem>
                    {recurrenceOptions.map((option) => (
                      <MenuItem key={option} value={option}>
                        {option}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
                {errors?.recurrence && (
                  <Typography color="error" variant="body2" mt={1}>
                    {errors.recurrence}
                  </Typography>
                )}
              </Box>

              <Box flex={1}>
                <Typography variant="h6" mb={2}>
                  Duration
                </Typography>
                <FormControl fullWidth>
                  <Select
                    value={data.duration || ''}
                    onChange={(e) => handleChange('duration', e.target.value)}
                    displayEmpty
                    sx={{ backgroundColor: 'white' }}
                  >
                    <MenuItem value="" disabled>
                      Select
                    </MenuItem>
                    {durationOptions.map((option) => (
                      <MenuItem key={option} value={option}>
                        {option}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
                {errors?.duration && (
                  <Typography color="error" variant="body2" mt={1}>
                    {errors.duration}
                  </Typography>
                )}
              </Box>
            </Stack>

            {/* Days of the Week */}
            <Box mb={4}>
              <Typography variant="h6" mb={2}>
                Days of the week
              </Typography>
              <FormControl fullWidth>
                <Select
                  multiple
                  value={data.daysOfWeek || []}
                  onChange={(e) => handleChange('daysOfWeek', e.target.value)}
                  displayEmpty
                  renderValue={(selected) => {
                    if (selected.length === 0) {
                      return <span style={{ color: '#9ca3af' }}>Select</span>;
                    }
                    return selected.join(', ');
                  }}
                  sx={{ backgroundColor: 'white' }}
                >
                  {daysOfWeekOptions.map((day) => (
                    <MenuItem key={day} value={day}>
                      {day}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
              {errors?.daysOfWeek && (
                <Typography color="error" variant="body2" mt={1}>
                  {errors.daysOfWeek}
                </Typography>
              )}
            </Box>
          </>
        )}

        {/* Navigation Buttons */}
        <Box display="flex" justifyContent="flex-end" gap={2}>
          <Button
            variant="outlined"
            onClick={onBack}
            sx={{
              borderColor: '#d1d5db',
              color: '#6b7280',
              px: 4,
              py: 1.5
            }}
          >
            Back
          </Button>
          <Button
            variant="contained"
            onClick={handleSubmit}
            disabled={loading}
            sx={{
              backgroundColor: '#6366f1',
              '&:hover': {
                backgroundColor: '#5856eb',
              },
              px: 4,
              py: 1.5
            }}
          >
            {loading ? 'Creating...' : 'Save'}
          </Button>
        </Box>
      </Box>
    </LocalizationProvider>
  );
};

export default SchedulingStep; 