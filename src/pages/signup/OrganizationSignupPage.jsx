import React, { useState } from 'react';
import {
  Box, Button, Typography, Stack, TextField, InputLabel, MenuItem, Select, OutlinedInput, Checkbox, ListItemText, Alert, Stepper, Step, StepLabel, FormControl, FormControlLabel
} from '@mui/material';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../contexts/useAuth';

const orgSizes = [
  '1-10 people',
  '11-50 people',
  '51-200 people',
  '200+ people',
];
const orgTypes = [
  'Local solidarity group',
  'Student organisation',
  'Community campaign',
  'Advocacy organisation',
];
const mainActivities = [
  'Protests & demonstrations',
  'Educational events',
  'Fundraising campaigns',
  'Community outreach',
  'Digital campaigns',
  'Legal advocacy',
  'Cultural events',
  'Other',
];
const volunteerNeeds = [
  'Graphic design',
  'Event planning',
  'Social media management',
  'Translation services',
  'Legal research',
  'Photography/videography',
  'Administrative support',
  'Other',
];

const OrganizationSignupPage = () => {
  const [step, setStep] = useState(0);
  const [form, setForm] = useState({
    name: '',
    orgCityCountry: '',
    orgSize: '',
    orgType: '',
    orgTypeOther: '',
    email: '',
    password: '',
    mission: '',
    mainActivities: [],
    mainActivitiesOther: '',
    volunteerNeeds: [],
    volunteerNeedsOther: '',
  });
  const [agreement, setAgreement] = useState({
    infoAccurate: false,
    terms: false,
    solidarity: false,
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [orgSubmitted, setOrgSubmitted] = useState(false);
  const [orgEmailToVerify, setOrgEmailToVerify] = useState('');
  const navigate = useNavigate();
  const { login } = useAuth();

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleAgreementChange = (e) => {
    setAgreement({ ...agreement, [e.target.name]: e.target.checked });
  };

  const validate = () => {
    if (step === 0) {
      if (!form.name) return 'Organisation name is required';
      if (!form.orgCityCountry) return 'Location is required';
      if (!form.orgSize) return 'Organisation size is required';
      if (!form.orgType) return 'Organisation type is required';
      if (form.orgType === 'Advocacy organisation' && !form.orgTypeOther) return 'Please specify advocacy organisation type';
      if (!form.email) return 'Admin email is required';
      if (!form.password) return 'Password is required';
      if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(form.email)) return 'Invalid email';
    } else if (step === 1) {
      if (!form.mission) return 'Mission is required';
      if (form.mission.length > 50) return 'Mission must be 50 characters or less';
      if (form.mainActivities.length === 0) return 'Select at least one main activity';
      if (form.mainActivities.includes('Other') && !form.mainActivitiesOther) return 'Please specify other main activity';
      if (form.volunteerNeeds.length === 0) return 'Select at least one volunteer need';
      if (form.volunteerNeeds.includes('Other') && !form.volunteerNeedsOther) return 'Please specify other volunteer need';
    } else if (step === 2) {
      if (!agreement.infoAccurate || !agreement.terms || !agreement.solidarity) return 'You must agree to all statements';
    }
    return '';
  };

  const handleNext = () => {
    setError('');
    const err = validate();
    if (err) {
      setError(err);
      return;
    }
    setStep(step + 1);
  };

  const handleBack = () => {
    setError('');
    setStep(step - 1);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    const err = validate();
    if (err) {
      setError(err);
      setLoading(false);
      return;
    }
    // Mock: org@example.com is always verified, others must verify
    if (form.email === 'org@example.com') {
      login({ role: 'organization', organizationId: 101, email: form.email, name: form.name });
      navigate('/organization');
    } else {
      setOrgSubmitted(true);
      setOrgEmailToVerify(form.email);
    }
    setLoading(false);
  };

  const handleVerifyOrg = () => {
    setOrgSubmitted(false);
    login({ role: 'organization', organizationId: 999, email: orgEmailToVerify, name: form.name });
    navigate('/organization');
  };

  return (
    <Box display="flex" flexDirection="column" alignItems="center" justifyContent="center" minHeight="100vh">
      <Typography variant="h4" mb={2}>Organization Sign Up</Typography>
      <Typography variant="subtitle1" mb={4} color="text.secondary" maxWidth={500} textAlign="center">
        Connect with supporters who share your cause<br />
        Join the platform where Palestinian campaign organisers find skilled volunteers ready to make a difference
      </Typography>
      {orgSubmitted ? (
        <Box width={350}>
          <Alert severity="info" sx={{ mb: 2 }}>
            A verification email has been sent to <b>{orgEmailToVerify}</b>.<br />
            Please verify your email before logging in.
          </Alert>
          <Button variant="contained" color="primary" fullWidth onClick={handleVerifyOrg}>
            (Mock) I have verified my email
          </Button>
        </Box>
      ) : (
        <form onSubmit={handleSubmit} style={{ width: 350 }}>
          <Stepper activeStep={step} alternativeLabel sx={{ mb: 4 }}>
            <Step><StepLabel>Organisation Details</StepLabel></Step>
            <Step><StepLabel>About Your Work</StepLabel></Step>
            <Step><StepLabel>Agreement</StepLabel></Step>
          </Stepper>
          {step === 0 && (
            <Stack spacing={2}>
              <Typography variant="h6">Step 1: Organisation Details</Typography>
              <Typography variant="body2" color="text.secondary">
                Tell us about your organisation. This information helps volunteers understand who you are and what you do.
              </Typography>
              <TextField
                label="Organisation Name"
                name="name"
                value={form.name}
                onChange={handleChange}
                required
                fullWidth
              />
              <TextField
                label="Where are you based?* City, Country"
                name="orgCityCountry"
                value={form.orgCityCountry}
                onChange={handleChange}
                required
                fullWidth
              />
              <FormControl fullWidth required>
                <InputLabel>How many active members do you have?</InputLabel>
                <Select
                  name="orgSize"
                  value={form.orgSize}
                  label="How many active members do you have?"
                  onChange={handleChange}
                >
                  {orgSizes.map(size => (
                    <MenuItem key={size} value={size}>{size}</MenuItem>
                  ))}
                </Select>
              </FormControl>
              <FormControl fullWidth required>
                <InputLabel>What best describes your organisation?</InputLabel>
                <Select
                  name="orgType"
                  value={form.orgType}
                  label="What best describes your organisation?"
                  onChange={handleChange}
                >
                  {orgTypes.map(type => (
                    <MenuItem key={type} value={type}>{type}</MenuItem>
                  ))}
                </Select>
              </FormControl>
              {form.orgType === 'Advocacy organisation' && (
                <TextField
                  label="Please specify advocacy organisation type"
                  name="orgTypeOther"
                  value={form.orgTypeOther}
                  onChange={handleChange}
                  fullWidth
                />
              )}
              <Typography variant="body2" color="text.secondary">
                Please provide an admin email and password for your organisation account.
              </Typography>
              <TextField
                label="Admin Email"
                name="email"
                type="email"
                value={form.email}
                onChange={handleChange}
                required
                fullWidth
              />
              <TextField
                label="Password"
                name="password"
                type="password"
                value={form.password}
                onChange={handleChange}
                required
                fullWidth
              />
            </Stack>
          )}
          {step === 1 && (
            <Stack spacing={2}>
              <Typography variant="h6">Step 2: About Your Work</Typography>
              <Typography variant="body2" color="text.secondary">
                Briefly describe your organisation's mission and the main activities you organise. This helps volunteers understand your focus and how they can contribute.
              </Typography>
              <TextField
                label="Organisation's mission (50 characters max)"
                name="mission"
                value={form.mission}
                onChange={handleChange}
                inputProps={{ maxLength: 50 }}
                required
                fullWidth
              />
              <Typography variant="body2" color="text.secondary">
                What activities do you typically organise? (Check all that apply)
              </Typography>
              <FormControl fullWidth required>
                <InputLabel>Main Activities</InputLabel>
                <Select
                  multiple
                  name="mainActivities"
                  value={form.mainActivities}
                  onChange={e => setForm(f => ({ ...f, mainActivities: e.target.value }))}
                  input={<OutlinedInput label="Main Activities" />}
                  renderValue={selected => selected.join(', ')}
                >
                  {mainActivities.map(act => (
                    <MenuItem key={act} value={act}>
                      <Checkbox checked={form.mainActivities.indexOf(act) > -1} />
                      <ListItemText primary={act} />
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
              {form.mainActivities.includes('Other') && (
                <TextField
                  label="Please specify other main activity"
                  name="mainActivitiesOther"
                  value={form.mainActivitiesOther}
                  onChange={handleChange}
                  fullWidth
                />
              )}
              <Typography variant="body2" color="text.secondary">
                What types of volunteer help do you usually need? (Check all that apply)
              </Typography>
              <FormControl fullWidth required>
                <InputLabel>Volunteer Needs</InputLabel>
                <Select
                  multiple
                  name="volunteerNeeds"
                  value={form.volunteerNeeds}
                  onChange={e => setForm(f => ({ ...f, volunteerNeeds: e.target.value }))}
                  input={<OutlinedInput label="Volunteer Needs" />}
                  renderValue={selected => selected.join(', ')}
                >
                  {volunteerNeeds.map(need => (
                    <MenuItem key={need} value={need}>
                      <Checkbox checked={form.volunteerNeeds.indexOf(need) > -1} />
                      <ListItemText primary={need} />
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
              {form.volunteerNeeds.includes('Other') && (
                <TextField
                  label="Please specify other volunteer need"
                  name="volunteerNeedsOther"
                  value={form.volunteerNeedsOther}
                  onChange={handleChange}
                  fullWidth
                />
              )}
            </Stack>
          )}
          {step === 2 && (
            <Stack spacing={2}>
              <Typography variant="h6">Agreement</Typography>
              <Typography variant="body2" color="text.secondary">
                Please confirm the following statements to complete your registration.
              </Typography>
              <FormControlLabel
                control={<Checkbox checked={agreement.infoAccurate} onChange={handleAgreementChange} name="infoAccurate" />}
                label="I confirm that this information is accurate and that I represent this organisation"
              />
              <FormControlLabel
                control={<Checkbox checked={agreement.terms} onChange={handleAgreementChange} name="terms" />}
                label="I agree to the Terms of Service and Privacy Policy"
              />
              <FormControlLabel
                control={<Checkbox checked={agreement.solidarity} onChange={handleAgreementChange} name="solidarity" />}
                label="I understand this platform is specifically for Palestinian solidarity work"
              />
            </Stack>
          )}
          {error && <Alert severity="error" sx={{ mt: 2 }}>{error}</Alert>}
          <Stack direction="row" spacing={2} mt={3}>
            {step > 0 && (
              <Button variant="outlined" onClick={handleBack} disabled={loading}>
                Back
              </Button>
            )}
            {step < 2 && (
              <Button variant="contained" onClick={handleNext} disabled={loading}>
                Next
              </Button>
            )}
            {step === 2 && (
              <Button type="submit" variant="contained" color="primary" disabled={loading}>
                {loading ? 'Signing up...' : 'Sign Up'}
              </Button>
            )}
          </Stack>
        </form>
      )}
    </Box>
  );
};

export default OrganizationSignupPage; 