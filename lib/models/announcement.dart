import 'package:cloud_firestore/cloud_firestore.dart';

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
  final String? userAvatarLink;
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
    this.userAvatarLink,
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
      'userAvatarLink': userAvatarLink,
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
      eventDateStart: _parseDateTime(json['eventDateStart']),
      eventDateEnd: _parseDateTime(json['eventDateEnd']),
      eventLocation: json['eventLocation'],
      requiredTeamSize: json['requiredTeamSize'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatarLink: json['userAvatarLink'],
      userCourse: json['userCourse'],
      userUniversity: json['userUniversity'],
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  // Helper method to parse DateTime from Firestore (handles both Timestamp and String)
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is String) {
      return DateTime.parse(value);
    }
    return null;
  }
}
