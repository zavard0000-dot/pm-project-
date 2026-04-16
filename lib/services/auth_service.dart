import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:teamup/interfaces/interfaces.dart';
import 'package:teamup/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class AuthService implements AuthInterface {
  const AuthService({required this.firebaseAuth, required this.firestore});
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  //getCurrentUser и onAuthStateChanged Возвращают одно и тоже, но один из них стрим другой снимок
  User? get getCurrentUser => firebaseAuth.currentUser;
  @override
  Stream<MyUser?> get onAuthStateChanged {
    return firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        // Fetch user data from Firestore
        final userDoc = await firestore.collection('users').doc(user.uid).get();
        final data = userDoc.data();

        if (data == null) {
          // User document doesn't exist yet, return basic user
          return MyUser(
            uid: user.uid,
            fullName: user.displayName ?? "User",
            username: user.email ?? "username",
            avatarLink: user.photoURL ?? "avatarLink",
            universityName: "universityName",
            currentCourse: 1,
            professionName: "professionName",
            projectsCount: 0,
            connectionsCount: 0,
            achievementsCount: 0,
            aboutMySelf: "",
            email: user.email ?? "",
            github: "",
            linkedin: "",
            location: "",
            telegram: "",
            hardSkills: [],
            currentProjects: [],
            availability: 'available',
          );
        }

        // Parse data from Firestore
        return MyUser(
          uid: user.uid,
          fullName: data['fullName'] ?? "User",
          username: data['username'] ?? user.email ?? "username",
          avatarLink: data['avatarLink'] ?? "avatarLink",
          universityName: data['universityName'] ?? "universityName",
          currentCourse: data['currentCourse'] ?? 1,
          professionName: data['professionName'] ?? "professionName",
          projectsCount: data['projectsCount'] ?? 0,
          connectionsCount: data['connectionsCount'] ?? 0,
          achievementsCount: data['achievementsCount'] ?? 0,
          aboutMySelf: data['aboutMySelf'] ?? "",
          email: user.email ?? "",
          github: data['github'] ?? "",
          linkedin: data['linkedin'] ?? "",
          location: data['location'] ?? "",
          telegram: data['telegram'] ?? "",
          hardSkills: List<String>.from(data['hardSkills'] ?? []),
          currentProjects: [],
          availability: data['availability'] ?? 'available',
        );
      } catch (e) {
        print('[AuthService] Error fetching user data: $e');
        // Return basic user data if Firestore fetch fails
        return MyUser(
          uid: user.uid,
          fullName: user.displayName ?? "User",
          username: user.email ?? "username",
          avatarLink: user.photoURL ?? "avatarLink",
          universityName: "universityName",
          currentCourse: 1,
          professionName: "professionName",
          projectsCount: 0,
          connectionsCount: 0,
          achievementsCount: 0,
          aboutMySelf: "",
          email: user.email ?? "",
          github: "",
          linkedin: "",
          location: "",
          telegram: "",
          hardSkills: [],
          currentProjects: [],
          availability: 'available',
        );
      }
    });
  }

  @override
  Future<UserCredential> signIn(String email, String password) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> createUser(String email, String password) async {
    try {
      final UserCredential _credential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _credential;
    } catch (e) {
      print('Error in createUser: $e');
      rethrow;
    }
  }

  Future<void> saveUserData({
    required String userId,
    required String fullName,
    required String university,
    required String email,
    required String telegram,
  }) async {
    try {
      final username = '@${_generateRandomUsername()}';

      print('[AuthService] Attempting to save user data for userId: $userId');

      // Set user data with all fields
      await firestore.collection('users').doc(userId).set({
        'fullName': fullName,
        'universityName': university,
        'email': email,
        'username': username,
        'isCommittee': false,
        'projectsCount': 0,
        'connectionsCount': 0,
        'achievementsCount': 0,
        'aboutMySelf': '',
        'avatarLink': '',
        'currentCourse': 1,
        'professionName': '',
        'github': '',
        'linkedin': '',
        'location': '',
        'telegram': telegram,
        'hardSkills': [],
        'currentProjects': [],
        'availability': 'available',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('[AuthService] User data saved successfully for userId: $userId');
    } on FirebaseException catch (e) {
      print(
        '[AuthService] Firebase error in saveUserData - Code: ${e.code}, Message: ${e.message}',
      );
      rethrow;
    } catch (e) {
      print('[AuthService] Error in saveUserData: $e');
      rethrow;
    }
  }

  Future<void> updateUsername({required String newname}) async {
    await getCurrentUser!.updateDisplayName(newname);
  }

  Future<void> updateUserProfile({
    required String userId,
    required String fullName,
    required String university,
    required int currentCourse,
    required String professionName,
    required String email,
    required String github,
    required String linkedin,
    required String location,
    required String telegram,
    required String aboutMySelf,
    required List<String> hardSkills,
    required String availability,
  }) async {
    try {
      print(
        '[AuthService] Attempting to update user profile for userId: $userId',
      );

      await firestore.collection('users').doc(userId).set({
        'fullName': fullName,
        'universityName': university,
        'currentCourse': currentCourse,
        'professionName': professionName,
        'email': email,
        'github': github,
        'linkedin': linkedin,
        'location': location,
        'telegram': telegram,
        'aboutMySelf': aboutMySelf,
        'hardSkills': hardSkills,
        'availability': availability,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print(
        '[AuthService] User profile updated successfully for userId: $userId',
      );
    } on FirebaseException catch (e) {
      print(
        '[AuthService] Firebase error in updateUserProfile - Code: ${e.code}, Message: ${e.message}',
      );
      rethrow;
    } catch (e) {
      print('[AuthService] Error in updateUserProfile: $e');
      rethrow;
    }
  }

  // Загрузить пользователя по ID (для просмотра профиля другого пользователя)
  Future<MyUser?> getUserById({required String userId}) async {
    try {
      final userDoc = await firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return null;

      final data = userDoc.data()!;
      return MyUser(
        uid: userId,
        fullName: data['fullName'] ?? "User",
        username: data['username'] ?? "username",
        avatarLink: data['avatarLink'] ?? "avatarLink",
        universityName: data['universityName'] ?? "universityName",
        currentCourse: data['currentCourse'] ?? 1,
        professionName: data['professionName'] ?? "professionName",
        projectsCount: data['projectsCount'] ?? 0,
        connectionsCount: data['connectionsCount'] ?? 0,
        achievementsCount: data['achievementsCount'] ?? 0,
        aboutMySelf: data['aboutMySelf'] ?? "",
        email: data['email'] ?? "",
        github: data['github'] ?? "",
        linkedin: data['linkedin'] ?? "",
        location: data['location'] ?? "",
        telegram: data['telegram'] ?? "",
        hardSkills: List<String>.from(data['hardSkills'] ?? []),
        currentProjects: [],
        availability: data['availability'] ?? 'available',
      );
    } catch (e) {
      print('[AuthService] Error in getUserById: $e');
      return null;
    }
  }

  // Явное обновление данных пользователя из Firestore
  // используется после обновления профиля, так как onAuthStateChanged не срабатывает при изменении данных в Firestore
  Future<MyUser?> refreshUserData({required String userId}) async {
    try {
      return getUserById(userId: userId);
    } catch (e) {
      print('[AuthService] Error in refreshUserData: $e');
      return null;
    }
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> deleteUser({
    required String email,
    required String password,
  }) async {}

  Future<void> resetPasswordFromCurrentPassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {}

  // Сохранить/обновить избранные объявления пользователя
  Future<void> saveFavorites({
    required String userId,
    required List<String> favoriteIds,
  }) async {
    try {
      print(
        '[AuthService] Saving ${favoriteIds.length} favorites for userId: $userId',
      );

      await firestore.collection('users').doc(userId).update({
        'favoriteAnnouncements': favoriteIds,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('[AuthService] Favorites saved successfully');
    } on FirebaseException catch (e) {
      print(
        '[AuthService] Firebase error in saveFavorites - Code: ${e.code}, Message: ${e.message}',
      );
      rethrow;
    } catch (e) {
      print('[AuthService] Error in saveFavorites: $e');
      rethrow;
    }
  }

  // Получить избранные объявления пользователя
  Future<List<String>> getFavorites({required String userId}) async {
    try {
      final userDoc = await firestore.collection('users').doc(userId).get();
      final data = userDoc.data();

      if (data == null) return [];

      final favorites = List<String>.from(data['favoriteAnnouncements'] ?? []);
      print(
        '[AuthService] Loaded ${favorites.length} favorites for userId: $userId',
      );
      return favorites;
    } catch (e) {
      print('[AuthService] Error in getFavorites: $e');
      return [];
    }
  }

  Future<String> saveAnnouncement({required Announcement announcement}) async {
    try {
      print('[AuthService] Attempting to save announcement');

      final docRef = await firestore.collection('announcements').add({
        'type': announcement.type,
        'title': announcement.title,
        'description': announcement.description,
        'university': announcement.university,
        'eventType': announcement.eventType,
        'requiredSkills': announcement.requiredSkills,
        'telegramLink': announcement.telegramLink,
        'eventDateStart': announcement.eventDateStart?.toIso8601String(),
        'eventDateEnd': announcement.eventDateEnd?.toIso8601String(),
        'eventLocation': announcement.eventLocation,
        'requiredTeamSize': announcement.requiredTeamSize,
        'userId': announcement.userId,
        'userName': announcement.userName,
        'userCourse': announcement.userCourse,
        'userUniversity': announcement.userUniversity,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print(
        '[AuthService] Announcement saved successfully with id: ${docRef.id}',
      );
      return docRef.id;
    } on FirebaseException catch (e) {
      print(
        '[AuthService] Firebase error in saveAnnouncement - Code: ${e.code}, Message: ${e.message}',
      );
      rethrow;
    } catch (e) {
      print('[AuthService] Error in saveAnnouncement: $e');
      rethrow;
    }
  }

  String _generateRandomUsername({int length = 12}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    final random = Random();
    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  // Получить список объявлений с фильтрацией
  Future<List<Announcement>> getAnnouncements({
    List<String> types = const [],
    List<String> skills = const [],
    List<String> eventTypes = const [],
    String searchQuery = '',
    String? excludeUserId,
    int limit = 30,
  }) async {
    try {
      print('[AuthService] Fetching announcements');
      Talker().debug(types.toString());
      print(
        '[AuthService] Filters - Types: $types, Skills: $skills, Events: $eventTypes, Search: "$searchQuery", ExcludeUserId: $excludeUserId',
      );

      // Если типы пусты - не показываем ничего
      if (types.isEmpty) {
        print('[AuthService] Types is empty, returning empty list');
        return [];
      }

      Query<Map<String, dynamic>> query = firestore.collection('announcements');

      // ⚠️ ВАЖНО: НЕ применяем where('type') потому что в комбинации с orderBy('createdAt')
      // требуется составной индекс. Вместо этого фильтруем на клиенте.
      // This avoids requiring a composite index for where('type') + orderBy('createdAt')

      // Фильтр по skills - не применяем для оптимизации (требует индекса)
      // if (skills.isNotEmpty) {
      //   query = query.where('requiredSkills', arrayContainsAny: skills);
      // }

      // Фильтр по типу события - не применяем для оптимизации (требует индекса)
      // if (eventTypes.isNotEmpty) {
      //   query = query.where('eventType', whereIn: eventTypes);
      // }

      // Сортируем по новым (самые свежие первыми) - БЕЗ where фильтров
      query = query.orderBy('createdAt', descending: true);

      // Лимит 30 объявлений
      query = query.limit(limit);

      final snapshot = await query.get();

      Talker().debug(
        '[AuthService] Firestore returned ${snapshot.docs.length} documents',
      );

      var announcements = snapshot.docs.map((doc) {
        return Announcement.fromJson(doc.data(), doc.id);
      }).toList();

      // Исключаем объявления текущего пользователя
      if (excludeUserId != null) {
        print(
          '[AuthService] Excluding announcements from user: $excludeUserId',
        );
        announcements = announcements
            .where((a) => a.userId != excludeUserId)
            .toList();
      }

      // Фильтрация на клиенте по типам (person, project, team)
      // Применяем фильтр только если выбраны не все 3 типа
      if (types.isNotEmpty && types.length < 3) {
        print('[AuthService] Filtering by types on client: $types');
        announcements = announcements
            .where((a) => types.contains(a.type))
            .toList();
      }

      // Фильтрация на клиенте для skills и eventTypes
      if (skills.isNotEmpty) {
        print('[AuthService] Filtering by skills on client: $skills');
        announcements = announcements
            .where(
              (a) => a.requiredSkills.any((skill) => skills.contains(skill)),
            )
            .toList();
      }

      if (eventTypes.isNotEmpty) {
        print('[AuthService] Filtering by eventTypes on client: $eventTypes');
        announcements = announcements
            .where((a) => eventTypes.contains(a.eventType))
            .toList();
      }

      // Фильтрация по поисковому запросу (название и описание)
      if (searchQuery.isNotEmpty) {
        print('[AuthService] Filtering by search query: "$searchQuery"');
        final query = searchQuery.toLowerCase();
        announcements = announcements
            .where(
              (a) =>
                  a.title.toLowerCase().contains(query) ||
                  a.description.toLowerCase().contains(query),
            )
            .toList();
      }

      print(
        '[AuthService] Successfully fetched ${announcements.length} announcements',
      );
      return announcements;
    } catch (e) {
      print('[AuthService] Error fetching announcements: $e');
      return [];
    }
  }
}
