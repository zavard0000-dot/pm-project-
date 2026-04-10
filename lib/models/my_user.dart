import 'profile_stat_model.dart';
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
    required this.aboutMySelf,
    required this.email,
    required this.github,
    required this.linkedin,
    required this.location,
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
  final String aboutMySelf;
  final String email;
  final String github;
  final String linkedin;
  final String location;
  final List<String> hardSkills;
  final List<CurrentProjectModel> currentProjects;
}
