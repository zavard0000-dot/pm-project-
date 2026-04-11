import 'package:flutter/material.dart';
import 'package:teamup/constances.dart';
import 'package:teamup/features/edit_profile/widgets/availability_card.dart';
import 'package:teamup/theme.dart';
import 'package:teamup/widgets/widgets.dart';
import '../widgets/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  int selectedAvailability = 0;

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
                //base information
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
                        hint: "Ivan Ivanovich",
                        title: "Full name",
                      ),
                      CustomTextField(hint: "aigerim_dev", title: "Nickname"),
                      CustomDropDownMenu(
                        title: "University",
                        dropDownMenuEntries:
                            UNIVERSITIES_DROP_DOWN_MENU_ENTRIES,
                      ),
                      CustomDropDownMenu(
                        title: "Course",
                        dropDownMenuEntries: COURSES_DROP_DOWN_MENU_ENTRIES,
                      ),
                      CustomTextField(
                        hint: "Computer Science",
                        title: "Specialization",
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),
                //about your self
                BaseCard(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: CustomTextField(
                    hint: "Расскажи о себе...",
                    title: "📝 About yourself",
                    maxLength: 500,
                    maxLines: 5,
                  ),
                ),

                SizedBox(height: 24),
                //contacts
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

                      CustomTextField(hint: "a@a.com", title: "Email"),
                      CustomTextField(hint: "", title: "GitHub"),
                      CustomTextField(hint: "", title: "LinkedIn"),
                      CustomTextField(hint: "Алматы, Казахстан", title: "City"),
                    ],
                  ),
                ),

                //Availability card
                SizedBox(height: 24),
                AvailabilityCard(
                  selectedIndex: selectedAvailability,
                  onTap: (int index) {
                    setState(() {
                      selectedAvailability = index;
                    });
                  },
                ),

                //
                SizedBox(height: 24),
                PrimaryButton(
                  text: "Save the changes",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),

                SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
