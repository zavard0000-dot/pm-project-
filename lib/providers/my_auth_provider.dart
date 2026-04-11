import 'package:flutter/material.dart';
import 'package:teamup/models/models.dart';
import 'package:teamup/services/auth_service.dart';

class MyAuthProvider extends ChangeNotifier {
  final AuthService _authService;

  MyAuthProvider({required AuthService authService})
    : _authService = authService {
    _subscribeToAuthState();
  }

  bool _isLoading = false;
  String? _error;
  MyUser? _currentUser;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  MyUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  // Subscribe to auth state changes
  void _subscribeToAuthState() {
    _authService.onAuthStateChanged.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Sign In
  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.signIn(email, password);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = _parseError(e.toString());
      notifyListeners();
      return false;
    }
  }

  // Sign Up
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    required String university,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final credential = await _authService.createUser(email, password);
      final user = credential.user;

      if (user != null) {
        await _authService.saveUserData(
          userId: user.uid,
          fullName: fullName,
          university: university,
          email: email,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = _parseError(e.toString());
      notifyListeners();
      return false;
    }
  }

  // Update User Profile
  Future<bool> updateUserProfile({
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
      _isLoading = true;
      _error = null;
      notifyListeners();

      final firebaseUser = _authService.getCurrentUser;
      if (firebaseUser == null) {
        throw Exception('User not authenticated');
      }

      await _authService.updateUserProfile(
        userId: firebaseUser.uid,
        fullName: fullName,
        university: university,
        currentCourse: currentCourse,
        professionName: professionName,
        email: email,
        github: github,
        linkedin: linkedin,
        location: location,
        aboutMySelf: aboutMySelf,
        hardSkills: hardSkills,
        availability: availability,
      );

      // Update current user with new data
      if (_currentUser != null) {
        _currentUser = MyUser(
          fullName: fullName,
          username: _currentUser!.username,
          avatarLink: _currentUser!.avatarLink,
          universityName: university,
          currentCourse: currentCourse,
          professionName: professionName,
          projectsCount: _currentUser!.projectsCount,
          connectionsCount: _currentUser!.connectionsCount,
          achievementsCount: _currentUser!.achievementsCount,
          aboutMySelf: aboutMySelf,
          email: email,
          github: github,
          linkedin: linkedin,
          location: location,
          hardSkills: hardSkills,
          currentProjects: _currentUser!.currentProjects,
          availability: availability,
        );
      }

      _isLoading = false;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = _parseError(e.toString());
      notifyListeners();
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signOut();
      _currentUser = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = _parseError(e.toString());
      notifyListeners();
    }
  }

  // Parse Firebase errors
  String _parseError(String error) {
    if (error.contains('user-not-found') ||
        error.contains('invalid-credential')) {
      return 'Email or password is incorrect';
    } else if (error.contains('wrong-password')) {
      return 'Password is incorrect';
    } else if (error.contains('email-already-in-use')) {
      return 'This email is already in use';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email format';
    } else if (error.contains('user-disabled')) {
      return 'This user account has been disabled';
    } else if (error.contains('too-many-requests')) {
      return 'Too many login attempts. Please try again later';
    }
    return 'An error occurred. Please try again';
  }
}
