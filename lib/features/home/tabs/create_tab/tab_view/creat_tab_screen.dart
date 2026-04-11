import 'package:flutter/material.dart';
import 'package:teamup/features/home/tabs/create_tab/widgets/widgets.dart';
import 'package:teamup/widgets/widgets.dart';
import 'package:teamup/constances.dart';
import 'package:teamup/theme.dart';
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

  // Selected values
  String? _selectedAdType;
  String? _selectedUniversity;
  String? _selectedEventType;
  List<String> _selectedSkills = [];

  bool _isFormValid() {
    return _selectedAdType != null &&
        _adTitleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedUniversity != null &&
        _selectedEventType != null &&
        _selectedSkills.isNotEmpty;
  }

  void _createAnnouncement() {
    if (!_isFormValid()) return;

    FocusScope.of(context).unfocus();

    Talker().debug("""{
    adType = $_selectedAdType,
    title = ${_adTitleController.text},
    desc = ${_descriptionController.text},
    university = $_selectedUniversity,
    event = $_selectedEventType,
    skills = ${_selectedSkills.join(', ')}
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
  }

  void _resetForm() {
    setState(() {
      _adTitleController.clear();
      _descriptionController.clear();
      _selectedAdType = null;
      _selectedUniversity = null;
      _selectedEventType = null;
      _selectedSkills = [];
    });
  }

  @override
  void dispose() {
    _adTitleController.dispose();
    _descriptionController.dispose();
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
                    });
                  },
                ),

                // Ad Title
                CustomTextField(
                  title: "Ad title",
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
                  value: _selectedEventType,
                  onChanged: (value) {
                    setState(() {
                      _selectedEventType = value;
                    });
                  },
                  dropDownMenuEntries: EVENTS_DROP_DOWN_MENU_ENTRIES,
                ),

                // Skills Selector
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

                // Create Button
                Material(
                  child: PrimaryButton(
                    text: "Create announcement",
                    icon: Icons.star_border,
                    onPressed: _isFormValid() ? _createAnnouncement : null,
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
}
