class Announcement {
  final String? id;
  final String type; // 'project', 'team', 'person'
  final String title;
  final String description;
  final String university;
  final String eventType;
  final List<String> requiredSkills;
  final String? telegramLink;
  final DateTime? eventDateStart;
  final DateTime? eventDateEnd;
  final String? eventLocation;
  final int? requiredTeamSize;

  // User data to display in the post
  final String? userId;
  final String? userName;
  final int? userCourse;
  final String? userUniversity;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Announcement({
    this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.university,
    required this.eventType,
    required this.requiredSkills,
    this.telegramLink,
    this.eventDateStart,
    this.eventDateEnd,
    this.eventLocation,
    this.requiredTeamSize,
    this.userId,
    this.userName,
    this.userCourse,
    this.userUniversity,
    this.createdAt,
    this.updatedAt,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'description': description,
      'university': university,
      'eventType': eventType,
      'requiredSkills': requiredSkills,
      'telegramLink': telegramLink,
      'eventDateStart': eventDateStart?.toIso8601String(),
      'eventDateEnd': eventDateEnd?.toIso8601String(),
      'eventLocation': eventLocation,
      'requiredTeamSize': requiredTeamSize,
      'userId': userId,
      'userName': userName,
      'userCourse': userCourse,
      'userUniversity': userUniversity,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create from JSON (from Firestore)
  factory Announcement.fromJson(Map<String, dynamic> json, String id) {
    return Announcement(
      id: id,
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      university: json['university'] ?? '',
      eventType: json['eventType'] ?? '',
      requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
      telegramLink: json['telegramLink'],
      eventDateStart: json['eventDateStart'] != null
          ? DateTime.parse(json['eventDateStart'])
          : null,
      eventDateEnd: json['eventDateEnd'] != null
          ? DateTime.parse(json['eventDateEnd'])
          : null,
      eventLocation: json['eventLocation'],
      requiredTeamSize: json['requiredTeamSize'],
      userId: json['userId'],
      userName: json['userName'],
      userCourse: json['userCourse'],
      userUniversity: json['userUniversity'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}
