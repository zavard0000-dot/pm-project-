import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamup/features/home/tabs/create_tab/widgets/widgets.dart';
import 'package:teamup/widgets/widgets.dart';
import 'package:teamup/constances.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/models/models.dart';
import 'package:teamup/providers/my_auth_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CreateTabScreen extends StatefulWidget {
  const CreateTabScreen({super.key});

  @override
  State<CreateTabScreen> createState() => _CreateTabScreenState();
}

class _CreateTabScreenState extends State<CreateTabScreen> {
  // Controllers
  final TextEditingController _adTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _eventLocationController =
      TextEditingController();
  final TextEditingController _teamSizeController = TextEditingController();

  // Selected values
  String? _selectedAdType;
  String? _selectedUniversity;
  String? _selectedEventType;
  List<String> _selectedSkills = [];

  // Optional event details
  DateTime? _eventDateStart;
  DateTime? _eventDateEnd;

  bool _isLoading = false;

  bool _isFormValid() {
    return _selectedAdType != null &&
        _adTitleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedUniversity != null &&
        _selectedEventType != null &&
        _selectedSkills.isNotEmpty;
  }

  Future<void> _selectDateRange(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_eventDateStart ?? DateTime.now())
          : (_eventDateEnd ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _eventDateStart = picked;
        } else {
          _eventDateEnd = picked;
        }
      });
    }
  }

  void _createAnnouncement() async {
    if (!_isFormValid()) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<MyAuthProvider>();
      final currentUser = authProvider.currentUser;

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not authenticated'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final announcement = Announcement(
        type: _selectedAdType!,
        title: _adTitleController.text,
        description: _descriptionController.text,
        university: _selectedUniversity!,
        eventType: _selectedEventType!,
        requiredSkills: _selectedSkills,
        telegramLink: currentUser.username,
        eventDateStart: _eventDateStart,
        eventDateEnd: _eventDateEnd,
        eventLocation: _eventLocationController.text.isNotEmpty
            ? _eventLocationController.text
            : null,
        requiredTeamSize:
            (_selectedAdType != 'person' && _teamSizeController.text.isNotEmpty)
            ? int.tryParse(_teamSizeController.text)
            : null,
        userId: currentUser.uid,
        userName: currentUser.fullName,
        userCourse: currentUser.currentCourse,
        userUniversity: currentUser.universityName,
      );

      await authProvider.saveAnnouncement(announcement);

      Talker().debug("""{
      adType = ${announcement.type},
      title = ${announcement.title},
      desc = ${announcement.description},
      university = ${announcement.university},
      event = ${announcement.eventType},
      skills = ${announcement.requiredSkills.join(', ')},
      telegram = ${announcement.telegramLink},
      location = ${announcement.eventLocation},
      teamSize = ${announcement.requiredTeamSize}
      }""");

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Announcement created successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Reset form
      _resetForm();
    } catch (e) {
      print('Error creating announcement: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetForm() {
    setState(() {
      _adTitleController.clear();
      _descriptionController.clear();
      _eventLocationController.clear();
      _teamSizeController.clear();
      _selectedAdType = null;
      _selectedUniversity = null;
      _selectedEventType = null;
      _selectedSkills = [];
      _eventDateStart = null;
      _eventDateEnd = null;
    });
  }

  @override
  void dispose() {
    _adTitleController.dispose();
    _descriptionController.dispose();
    _eventLocationController.dispose();
    _teamSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Header
        Header(),

        const SizedBox(height: 32),

        Container(
          color: isDarkMode ? AppColors.darkBackground : AppColors.background,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ad Type Selector
                AdTypeSelector(
                  selectedType: _selectedAdType,
                  onTypeChanged: (type) {
                    setState(() {
                      _selectedAdType = type;
                      // Clear team size if person type is selected
                      if (type == 'person') {
                        _teamSizeController.clear();
                      }
                    });
                  },
                ),

                // Ad Title
                CustomTextField(
                  title: "Ad title",
                  isRequired: true,
                  hint:
                      "For example: Looking for a Frontend Developer for a Hackathon",
                  controller: _adTitleController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),

                // Description
                CustomTextField(
                  title: "Description",
                  isRequired: true,
                  hint:
                      "Tell us more about the project, its objectives, and requirements...",
                  controller: _descriptionController,
                  maxLength: 500,
                  maxLines: 5,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),

                // University
                CustomDropDownMenu(
                  title: "University",
                  isRequired: true,
                  value: _selectedUniversity,
                  onChanged: (value) {
                    setState(() {
                      _selectedUniversity = value;
                    });
                  },
                  dropDownMenuEntries: UNIVERSITIES_DROP_DOWN_MENU_ENTRIES,
                ),

                // Event Type
                CustomDropDownMenu(
                  title: "Event type",
                  isRequired: true,
                  value: _selectedEventType,
                  onChanged: (value) {
                    setState(() {
                      _selectedEventType = value;
                    });
                  },
                  dropDownMenuEntries: EVENTS_DROP_DOWN_MENU_ENTRIES,
                ),

                // Optional Event Details Section
                _buildEventDetailsSection(isDarkMode),

                // Info text
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    'After publication, the ad will appear in the general feed',
                    style: AppTextStyles.infoText.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),

                // Skills Selector (Last)
                SkillsSelector(
                  selectedSkills: _selectedSkills,
                  onSkillsChanged: (skills) {
                    setState(() {
                      _selectedSkills = skills;
                    });
                  },
                  availableSkills: AVAILABLE_SKILLS,
                  maxSkills: 8,
                ),

                const SizedBox(height: 16),

                // Create Button
                Material(
                  child: PrimaryButton(
                    text: _isLoading ? "Creating..." : "Create announcement",
                    icon: Icons.star_border,
                    onPressed: (_isFormValid() && !_isLoading)
                        ? _createAnnouncement
                        : null,
                  ),
                ),

                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetailsSection(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: BaseCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Details (Optional)',
              style: AppTextStyles.labelLarge.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Event Date Start
            GestureDetector(
              onTap: () => _selectDateRange(context, true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.darkInputBorder
                        : AppColors.inputBorder,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isDarkMode
                      ? AppColors.darkSurfaceVariant
                      : AppColors.surface,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _eventDateStart != null
                          ? 'Start: ${_eventDateStart!.day}/${_eventDateStart!.month}/${_eventDateStart!.year}'
                          : 'Select start date',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _eventDateStart != null
                            ? (isDarkMode
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary)
                            : (isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Event Date End
            GestureDetector(
              onTap: () => _selectDateRange(context, false),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.darkInputBorder
                        : AppColors.inputBorder,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isDarkMode
                      ? AppColors.darkSurfaceVariant
                      : AppColors.surface,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _eventDateEnd != null
                          ? 'End: ${_eventDateEnd!.day}/${_eventDateEnd!.month}/${_eventDateEnd!.year}'
                          : 'Select end date',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _eventDateEnd != null
                            ? (isDarkMode
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary)
                            : (isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Event Location
            CustomTextField(
              title: "Event Location",
              hint: "For example: KBTU, Almaty",
              controller: _eventLocationController,
              onChanged: (value) {
                setState(() {});
              },
            ),

            // Team Size (hidden if person type)
            if (_selectedAdType != 'person')
              CustomTextField(
                title: "Required Team Size",
                hint: "For example: 3",
                controller: _teamSizeController,
                onChanged: (value) {
                  setState(() {});
                },
              ),
          ],
        ),
      ),
    );
  }
}
