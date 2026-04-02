import 'profile_stat_model.dart';
import 'profile_section_model.dart';
import 'current_project_model.dart';

class MyUser {
  const MyUser({
    required this.fullName,
    required this.username,
    required this.avatarLink,
    required this.universityName,
    required this.currentCourse,
    required this.professionName,
    required this.stats,
    required this.sections,
    required this.hardSkills,
    required this.currentProjects,
  });

  final String fullName;
  final String username;
  final String avatarLink;
  final String universityName;
  final int currentCourse;
  final String professionName;
  final List<ProfileStatModel> stats;
  final List<ProfileSectionModel> sections;
  final List<String> hardSkills;
  final List<CurrentProjectModel> currentProjects;
}
