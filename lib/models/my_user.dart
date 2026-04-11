import 'current_project_model.dart';

class MyUser {
  const MyUser({
    required this.fullName,
    required this.username,
    required this.avatarLink,
    required this.universityName,
    required this.currentCourse,
    required this.professionName,
    required this.projectsCount,
    required this.connectionsCount,
    required this.achievementsCount,
    required this.aboutMySelf,
    required this.email,
    required this.github,
    required this.linkedin,
    required this.location,
    required this.hardSkills,
    required this.currentProjects,
    this.availability = 'available',
  });

  final String fullName;
  final String username;
  final String avatarLink;
  final String universityName;
  final int currentCourse;
  final String professionName;
  final int projectsCount;
  final int connectionsCount;
  final int achievementsCount;
  final String aboutMySelf;
  final String email;
  final String github;
  final String linkedin;
  final String location;
  final List<String> hardSkills;
  final List<CurrentProjectModel> currentProjects;
  final String availability;
}
