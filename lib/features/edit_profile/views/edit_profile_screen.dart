import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:teamup/constances.dart';
import 'package:teamup/features/edit_profile/widgets/availability_card.dart';
import 'package:teamup/providers/my_auth_provider.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';
import '../widgets/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController fullNameController;
  late TextEditingController nicknameController;
  late TextEditingController specializationController;
  late TextEditingController aboutController;
  late TextEditingController emailController;
  late TextEditingController githubController;
  late TextEditingController linkedinController;
  late TextEditingController cityController;
  late TextEditingController telegramController;

  String selectedUniversity = 'kbtu';
  String selectedCourse = '1';
  String selectedAvailability = 'available';
  Set<String> selectedSkills = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final user = context.read<MyAuthProvider>().user;

    fullNameController = TextEditingController(text: user?.fullName ?? '');
    nicknameController = TextEditingController(text: user?.username ?? '');
    specializationController = TextEditingController(
      text: user?.professionName ?? '',
    );
    aboutController = TextEditingController(text: user?.aboutMySelf ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    githubController = TextEditingController(text: user?.github ?? '');
    linkedinController = TextEditingController(text: user?.linkedin ?? '');
    cityController = TextEditingController(text: user?.location ?? '');
    telegramController = TextEditingController(text: user?.telegram ?? '');

    selectedUniversity = user?.universityName.toLowerCase() ?? 'kbtu';
    selectedCourse = user?.currentCourse.toString() ?? '1';
    selectedAvailability = user?.availability ?? 'available';
    selectedSkills = Set<String>.from(user?.hardSkills ?? []);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    nicknameController.dispose();
    specializationController.dispose();
    aboutController.dispose();
    emailController.dispose();
    githubController.dispose();
    linkedinController.dispose();
    cityController.dispose();
    telegramController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final authProvider = context.read<MyAuthProvider>();
    final user = authProvider.user;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not found')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final success = await authProvider.updateUserProfile(
        fullName: fullNameController.text.trim(),
        university: selectedUniversity,
        currentCourse: int.parse(selectedCourse),
        professionName: specializationController.text.trim(),
        email: emailController.text.trim(),
        github: githubController.text.trim(),
        linkedin: linkedinController.text.trim(),
        location: cityController.text.trim(),
        telegram: telegramController.text.trim(),
        aboutMySelf: aboutController.text.trim(),
        hardSkills: selectedSkills.toList(),
        availability: selectedAvailability,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.error ?? 'Error updating profile'),
            ),
          );
          setState(() => _isSaving = false);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? AppColors.darkBackground
        : AppColors.background;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          EditProfileHeader(),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Base information
                BaseCard(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "👤 Base information",
                        style: AppTextStyles.headingMedium.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 24),
                      CustomTextField(
                        controller: fullNameController,
                        hint: "Ivan Ivanovich",
                        title: "Full name",
                      ),
                      CustomTextField(
                        controller: nicknameController,
                        hint: "aigerim_dev",
                        title: "Nickname",
                      ),
                      CustomDropDownMenu(
                        title: "University",
                        dropDownMenuEntries:
                            UNIVERSITIES_DROP_DOWN_MENU_ENTRIES,
                        value: selectedUniversity,
                        onChanged: (value) {
                          setState(() => selectedUniversity = value ?? 'kbtu');
                        },
                      ),
                      CustomDropDownMenu(
                        title: "Course",
                        dropDownMenuEntries: COURSES_DROP_DOWN_MENU_ENTRIES,
                        value: selectedCourse,
                        onChanged: (value) {
                          setState(() => selectedCourse = value ?? '1');
                        },
                      ),
                      CustomTextField(
                        controller: specializationController,
                        hint: "Computer Science",
                        title: "Specialization",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // About yourself
                BaseCard(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: CustomTextField(
                    controller: aboutController,
                    hint: "Расскажи о себе...",
                    title: "📝 About yourself",
                    maxLength: 500,
                    maxLines: 5,
                  ),
                ),
                SizedBox(height: 24),

                // Contacts
                BaseCard(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "📝 Contacts",
                        style: AppTextStyles.headingMedium.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 24),
                      CustomTextField(
                        controller: emailController,
                        hint: "a@a.com",
                        title: "Email",
                      ),
                      CustomTextField(
                        controller: telegramController,
                        hint: "@yourname or your telegram ID",
                        title: "Telegram",
                      ),
                      CustomTextField(
                        controller: githubController,
                        hint: "",
                        title: "GitHub",
                      ),
                      CustomTextField(
                        controller: linkedinController,
                        hint: "",
                        title: "LinkedIn",
                      ),
                      CustomTextField(
                        controller: cityController,
                        hint: "Алматы, Казахстан",
                        title: "City",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Hard Skills
                BaseCard(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🛠️ Hard Skills",
                        style: AppTextStyles.headingMedium.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: AVAILABLE_SKILLS.map((skill) {
                          final isSelected = selectedSkills.contains(skill);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedSkills.remove(skill);
                                } else {
                                  selectedSkills.add(skill);
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Color(0xFF7C3AED)
                                    : (isDarkMode
                                          ? AppColors.darkSurfaceVariant
                                          : AppColors.surface),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Color(0xFF7C3AED)
                                      : (isDarkMode
                                            ? Colors.white.withValues(
                                                alpha: 0.1,
                                              )
                                            : Colors.grey.withValues(
                                                alpha: 0.3,
                                              )),
                                ),
                              ),
                              child: Text(
                                skill,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : (isDarkMode
                                            ? AppColors.darkTextPrimary
                                            : AppColors.textPrimary),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Availability card
                AvailabilityCard(
                  selectedIndex: _getAvailabilityIndex(selectedAvailability),
                  onTap: (int index) {
                    setState(() {
                      selectedAvailability = _getAvailabilityValue(index);
                    });
                  },
                ),
                SizedBox(height: 24),

                // Save button
                PrimaryButton(
                  text: "Save the changes",
                  isLoading: _isSaving,
                  onPressed: _isSaving ? null : _saveProfile,
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getAvailabilityIndex(String value) {
    switch (value) {
      case 'available':
        return 0;
      case 'busy':
        return 1;
      case 'unavailable':
        return 2;
      default:
        return 0;
    }
  }

  String _getAvailabilityValue(int index) {
    switch (index) {
      case 0:
        return 'available';
      case 1:
        return 'busy';
      case 2:
        return 'unavailable';
      default:
        return 'available';
    }
  }
}
