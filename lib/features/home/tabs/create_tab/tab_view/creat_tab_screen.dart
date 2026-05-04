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
  final Announcement? announcementToEdit;

  const CreateTabScreen({super.key, this.announcementToEdit});

  @override
  State<CreateTabScreen> createState() => _CreateTabScreenState();
}

class _CreateTabScreenState extends State<CreateTabScreen> {
  // Controllers
  late TextEditingController _adTitleController;
  late TextEditingController _descriptionController;
  late TextEditingController _eventLocationController;
  late TextEditingController _teamSizeController;

  // Selected values
  String? _selectedAdType;
  String? _selectedUniversity;
  String? _selectedEventType;
  List<String> _selectedSkills = [];

  // Optional event details
  DateTime? _eventDateStart;
  DateTime? _eventDateEnd;

  bool _isLoading = false;

  bool get _isEditing => widget.announcementToEdit != null;

  @override
  void initState() {
    super.initState();
    _adTitleController = TextEditingController(
      text: widget.announcementToEdit?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.announcementToEdit?.description ?? '',
    );
    _eventLocationController = TextEditingController(
      text: widget.announcementToEdit?.eventLocation ?? '',
    );
    _teamSizeController = TextEditingController(
      text: widget.announcementToEdit?.requiredTeamSize?.toString() ?? '',
    );

    if (_isEditing) {
      _selectedAdType = widget.announcementToEdit!.type;
      _selectedUniversity = widget.announcementToEdit!.university;
      _selectedEventType = widget.announcementToEdit!.eventType;
      _selectedSkills = List.from(widget.announcementToEdit!.requiredSkills);
      _eventDateStart = widget.announcementToEdit!.eventDateStart;
      _eventDateEnd = widget.announcementToEdit!.eventDateEnd;
    }
  }

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

  void _saveOrUpdateAnnouncement() async {
    if (!_isFormValid()) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<MyAuthProvider>();
      final currentUser = authProvider.user;

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
        id: widget.announcementToEdit?.id,
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
        userAvatarLink: currentUser.avatarLink,
        userCourse: currentUser.currentCourse,
        userUniversity: currentUser.universityName,
      );

      bool success;
      if (_isEditing) {
        success = await authProvider.updateAnnouncement(announcement);
      } else {
        success = await authProvider.saveAnnouncement(announcement);
      }

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Announcement updated successfully!'
                  : 'Announcement created successfully!',
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        // Обновляем список своих объявлений
        await authProvider.loadMyAnnouncements();

        if (_isEditing) {
          Navigator.of(context).pop();
        } else {
          _resetForm();
        }
      }
    } catch (e) {
      print('Error saving announcement: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _deleteAnnouncement() async {
    if (!_isEditing) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Announcement'),
        content: const Text(
          'Are you sure you want to delete this announcement?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<MyAuthProvider>();
      final success = await authProvider.deleteAnnouncement(
        widget.announcementToEdit!.id!,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Announcement deleted successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        // Обновляем список своих объявлений
        await authProvider.loadMyAnnouncements();
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error deleting announcement: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : AppColors.background,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          Header(
            title: _isEditing ? "Edit Announcement" : "Create Announcement",
            showBackButton: _isEditing,
          ),

          const SizedBox(height: 32),

          Padding(
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

                // Action Buttons
                if (_isEditing) ...[
                  PrimaryButton(
                    text: "Save changes",
                    icon: Icons.check,
                    isLoading: _isLoading,
                    onPressed: (_isFormValid() && !_isLoading)
                        ? _saveOrUpdateAnnouncement
                        : null,
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    text: "Delete announcement",
                    icon: Icons.delete_outline,
                    isLoading: _isLoading,
                    color: Colors.red.withValues(alpha: 0.1),
                    textColor: Colors.red,
                    onPressed: _isLoading ? null : _deleteAnnouncement,
                  ),
                ] else ...[
                  PrimaryButton(
                    text: "Create announcement",
                    icon: Icons.star_border,
                    isLoading: _isLoading,
                    onPressed: (_isFormValid() && !_isLoading)
                        ? _saveOrUpdateAnnouncement
                        : null,
                  ),
                ],

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
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
