import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:rabt_mobile/models/advert.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/models/organizer.dart';
import 'package:rabt_mobile/models/skill.dart';
import 'package:rabt_mobile/state/adverts/adverts_providers.dart';
import 'package:rabt_mobile/widgets/app_button.dart';
import '../../services/image_upload_service.dart';
import 'steps/basic_info_step.dart';
import 'steps/location_step.dart';
import 'steps/skills_step.dart';
import 'steps/details_step.dart';
import 'steps/review_step.dart';

class CreateAdvertWizard extends ConsumerStatefulWidget {
  const CreateAdvertWizard({super.key});

  static const String path = '/o/create-advert';

  @override
  ConsumerState<CreateAdvertWizard> createState() => _CreateAdvertWizardState();
}

class _CreateAdvertWizardState extends ConsumerState<CreateAdvertWizard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Form keys for each step
  final _basicFormKey = GlobalKey<FormState>();
  final _locationFormKey = GlobalKey<FormState>();
  final _detailsFormKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _addressController = TextEditingController();
  final _postcodeController = TextEditingController();

  // Form data
  String? _category;
  FrequencyType _frequency = FrequencyType.oneOff;
  int _numberOfVolunteers = 1;
  LocationType _locationType = LocationType.onSite;
  final Set<String> _skills = {};
  File? _selectedImage;

  // One-off specific fields
  DateTime? _eventDateTime;
  TimeCommitment _oneOffTimeCommitment = TimeCommitment.oneToTwo;
  DateTime? _applicationDeadline;

  // Recurring specific fields
  RecurrenceType _recurrence = RecurrenceType.weekly;
  TimeCommitment _recurringTimeCommitment = TimeCommitment.oneToTwo;
  DurationType _duration = DurationType.oneMonth;
  final Map<String, List<DayTimePeriod>> _specificDays = {};

  @override
  void initState() {
    super.initState();
    // Add listeners to text controllers to trigger validation updates
    _titleController.addListener(_onFieldChanged);
    _descController.addListener(_onFieldChanged);
    _addressController.addListener(_onFieldChanged);
    _postcodeController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.removeListener(_onFieldChanged);
    _descController.removeListener(_onFieldChanged);
    _addressController.removeListener(_onFieldChanged);
    _postcodeController.removeListener(_onFieldChanged);
    _titleController.dispose();
    _descController.dispose();
    _addressController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    // Trigger rebuild to update validation state
    setState(() {});
  }

  Future<void> _pickImage({bool fromCamera = false}) async {
    final image = await ImageUploadService().pickImage(fromCamera: fromCamera);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _toggleDayPeriod(String day, DayTimePeriod period) {
    setState(() {
      if (_specificDays[day]?.contains(period) == true) {
        _specificDays[day]!.remove(period);
        if (_specificDays[day]!.isEmpty) {
          _specificDays.remove(day);
        }
      } else {
        _specificDays.putIfAbsent(day, () => []).add(period);
      }
    });
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Basic Info
        return _titleController.text.trim().isNotEmpty && 
               _descController.text.trim().isNotEmpty && 
               _category != null;
      case 1: // Location
        return true; // Location is always valid (optional fields)
      case 2: // Skills
        return true; // Skills are optional
      case 3: // Details
        if (_frequency == FrequencyType.oneOff) {
          return _eventDateTime != null && _applicationDeadline != null;
        } else {
          return _specificDays.isNotEmpty;
        }
      case 4: // Review
        return true;
      default:
        return false;
    }
  }

  void _submitAdvert() {
    final advert = Advert(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      category: _category!,
      frequency: _frequency,
      numberOfVolunteers: _numberOfVolunteers,
      locationType: _locationType,
      addressText: _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : null,
      postcode: _postcodeController.text.trim().isNotEmpty ? _postcodeController.text.trim() : null,
      isActive: true,
      organizer: OrganizerProfile(id: 1, name: 'Me'),
      requiredSkills: _skills.map((s) => SkillResponse(id: 1, name: s, isPredefined: true)).toList(),
      oneoffDetails: _frequency == FrequencyType.oneOff
          ? OneOffAdvertDetails(
              eventDatetime: _eventDateTime!,
              timeCommitment: _oneOffTimeCommitment,
              applicationDeadline: _applicationDeadline!,
            )
          : null,
      recurringDetails: _frequency == FrequencyType.recurring
          ? RecurringAdvertDetails(
              recurrence: _recurrence,
              timeCommitmentPerSession: _recurringTimeCommitment,
              duration: _duration,
              specificDays: _specificDays.entries.map((entry) => 
                RecurringDays(day: entry.key, periods: entry.value)
              ).toList(),
            )
          : null,
      createdAt: DateTime.now(),
    );

    ref.read(createAdvertControllerProvider.notifier).createAdvert(
      advert,
      imageFile: _selectedImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final createAdvertState = ref.watch(createAdvertControllerProvider);

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentStep > 0) {
          _previousStep();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Advert - Step ${_currentStep + 1} of $_totalSteps'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            BasicInfoStep(
              formKey: _basicFormKey,
              titleController: _titleController,
              descController: _descController,
              category: _category,
              frequency: _frequency,
              numberOfVolunteers: _numberOfVolunteers,
              onCategoryChanged: (v) => setState(() => _category = v),
              onFrequencyChanged: (v) => setState(() => _frequency = v ?? FrequencyType.oneOff),
              onVolunteersChanged: (v) => setState(() => _numberOfVolunteers = v ?? 1),
            ),
            LocationStep(
              formKey: _locationFormKey,
              addressController: _addressController,
              postcodeController: _postcodeController,
              locationType: _locationType,
              selectedImage: _selectedImage,
              onLocationTypeChanged: (v) => setState(() => _locationType = v ?? LocationType.onSite),
              onPickImage: _pickImage,
            ),
            SkillsStep(
              selectedSkills: _skills,
              onSkillToggled: (skill) => setState(() {
                if (_skills.contains(skill)) {
                  _skills.remove(skill);
                } else {
                  _skills.add(skill);
                }
              }),
            ),
            DetailsStep(
              formKey: _detailsFormKey,
              frequency: _frequency,
              // One-off fields
              eventDateTime: _eventDateTime,
              oneOffTimeCommitment: _oneOffTimeCommitment,
              applicationDeadline: _applicationDeadline,
              onEventDateTimeChanged: (v) => setState(() => _eventDateTime = v),
              onOneOffTimeCommitmentChanged: (v) => setState(() => _oneOffTimeCommitment = v ?? TimeCommitment.oneToTwo),
              onApplicationDeadlineChanged: (v) => setState(() => _applicationDeadline = v),
              // Recurring fields
              recurrence: _recurrence,
              recurringTimeCommitment: _recurringTimeCommitment,
              duration: _duration,
              specificDays: _specificDays,
              onRecurrenceChanged: (v) => setState(() => _recurrence = v ?? RecurrenceType.weekly),
              onRecurringTimeCommitmentChanged: (v) => setState(() => _recurringTimeCommitment = v ?? TimeCommitment.oneToTwo),
              onDurationChanged: (v) => setState(() => _duration = v ?? DurationType.oneMonth),
              onDayPeriodToggled: _toggleDayPeriod,
            ),
            ReviewStep(
              titleController: _titleController,
              descController: _descController,
              addressController: _addressController,
              postcodeController: _postcodeController,
              category: _category,
              frequency: _frequency,
              numberOfVolunteers: _numberOfVolunteers,
              locationType: _locationType,
              selectedSkills: _skills,
              selectedImage: _selectedImage,
              // One-off fields
              eventDateTime: _eventDateTime,
              oneOffTimeCommitment: _oneOffTimeCommitment,
              applicationDeadline: _applicationDeadline,
              // Recurring fields
              recurrence: _recurrence,
              recurringTimeCommitment: _recurringTimeCommitment,
              duration: _duration,
              specificDays: _specificDays,
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                AppButton(
                  onPressed: _previousStep,
                  label: 'Previous',
                  variant: AppButtonVariant.outline,
                )
              else
                const SizedBox(),
              if (_currentStep < _totalSteps - 1)
                AppButton(
                  onPressed: _validateCurrentStep() ? _nextStep : null,
                  label: 'Next',
                )
              else
                AppButton(
                  onPressed: createAdvertState.isLoading ? null : _submitAdvert,
                  label: createAdvertState.isLoading ? 'Creating...' : 'Create Advert',
                ),
            ],
          ),
        ),
      ),
    );
  }






}
