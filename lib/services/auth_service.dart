import 'package:cloud_firestore/cloud_firestore.dart';
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
            hardSkills: [],
            currentProjects: [],
            availability: 'available',
          );
        }

        // Parse data from Firestore
        return MyUser(
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
          hardSkills: List<String>.from(data['hardSkills'] ?? []),
          currentProjects:
              (data['currentProjects'] as List?)
                  ?.map(
                    (p) => CurrentProjectModel(
                      title: p['title'] ?? "",
                      subtitle: p['subtitle'] ?? "",
                    ),
                  )
                  .toList() ??
              [],
          availability: data['availability'] ?? 'available',
        );
      } catch (e) {
        print('[AuthService] Error fetching user data: $e');
        // Return basic user data if Firestore fetch fails
        return MyUser(
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

  String _generateRandomUsername({int length = 12}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    final random = Random();
    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
