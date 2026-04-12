import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teamup/models/models.dart';
import 'package:teamup/services/auth_service.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class MyAuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthStatus _status = AuthStatus.loading;
  MyUser? _user;
  String? _error;
  StreamSubscription<MyUser?>? _streamSubscription;

  // Список объявлений для feed
  List<Announcement> _announcements = [];
  bool _isLoadingAnnouncements = false;

  // Избранные объявления
  List<String> _favoriteAnnouncementIds = [];

  // Фильтры для объявлений
  List<String> selectedTypes = ['person', 'team', 'project'];
  List<String> selectedSkills = [];
  List<String> selectedEventTypes = [];

  MyAuthProvider({required AuthService authService})
    : _authService = authService {
    // Подписываемся на стрим один раз при инициализации
    _streamSubscription = _authService.onAuthStateChanged.listen(
      (user) {
        _user = user;

        // 2. Логика смены статуса
        if (user != null) {
          _status = AuthStatus.authenticated;
          // Загружаем избранные объявления при входе пользователя
          _loadFavorites(user.uid);
        } else {
          _status = AuthStatus.unauthenticated;
          _favoriteAnnouncementIds = [];
        }

        _error = null;
        notifyListeners();
      },
      onError: (e) {
        print('[MyAuthProvider] Stream error: $e');
        _error = 'Auth error: $e';
        _status = AuthStatus.unauthenticated;
        notifyListeners();
      },
    );

    // Загружаем объявления при инициализации
    loadAnnouncements();
  }

  // Загрузить избранные объявления из Firestore
  Future<void> _loadFavorites(String userId) async {
    try {
      _favoriteAnnouncementIds = await _authService.getFavorites(
        userId: userId,
      );
      notifyListeners();
    } catch (e) {
      print('[MyAuthProvider] Error loading favorites: $e');
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  // Геттеры для UI
  AuthStatus get status => _status;
  MyUser? get user => _user;
  String? get error => _error;

  // Геттеры для объявлений
  List<Announcement> get announcements => _announcements;
  bool get isLoadingAnnouncements => _isLoadingAnnouncements;
  bool get hasAnnouncements => _announcements.isNotEmpty;

  // Удобные хелперы, чтобы не писать проверки через Enum в UI
  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Проверить, находится ли объявление в избранном
  bool isFavorite(String announcementId) =>
      _favoriteAnnouncementIds.contains(announcementId);

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Загрузить объявления с фильтрацией
  Future<void> loadAnnouncements({
    List<String>? types,
    List<String>? skills,
    List<String>? eventTypes,
  }) async {
    try {
      _isLoadingAnnouncements = true;
      notifyListeners();

      _announcements = await _authService.getAnnouncements(
        types: types ?? selectedTypes,
        skills: skills ?? selectedSkills,
        eventTypes: eventTypes ?? selectedEventTypes,
        limit: 30,
      );

      // Сохраняем фильтры если они переданы
      if (types != null) selectedTypes = types;
      if (skills != null) selectedSkills = skills;
      if (eventTypes != null) selectedEventTypes = eventTypes;

      _isLoadingAnnouncements = false;
      notifyListeners();

      print('[MyAuthProvider] Loaded ${_announcements.length} announcements');
    } catch (e) {
      print('[MyAuthProvider] Error loading announcements: $e');
      _isLoadingAnnouncements = false;
      notifyListeners();
    }
  }

  // Обновить фильтры и перезагрузить объявления
  Future<void> applyFilters({
    required List<String> types,
    required List<String> skills,
    required List<String> eventTypes,
  }) async {
    await loadAnnouncements(
      types: types,
      skills: skills,
      eventTypes: eventTypes,
    );
  }

  // Переключить избранное объявление
  Future<void> toggleFavorite(String announcementId) async {
    try {
      if (_favoriteAnnouncementIds.contains(announcementId)) {
        _favoriteAnnouncementIds.remove(announcementId);
        print('[MyAuthProvider] Removed from favorites: $announcementId');
      } else {
        _favoriteAnnouncementIds.add(announcementId);
        print('[MyAuthProvider] Added to favorites: $announcementId');
      }

      notifyListeners();

      // Сохраняем в Firestore
      final firebaseUser = _authService.getCurrentUser;
      if (firebaseUser != null) {
        await _authService.saveFavorites(
          userId: firebaseUser.uid,
          favoriteIds: _favoriteAnnouncementIds,
        );
      }
    } catch (e) {
      print('[MyAuthProvider] Error toggling favorite: $e');
      rethrow;
    }
  }

  // Sign In
  Future<bool> signIn(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      _error = null;
      notifyListeners();

      await _authService.signIn(email, password);

      return true;
    } catch (e) {
      _error = _parseError(e.toString());
      _status = AuthStatus.unauthenticated;
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
    required String telegram,
  }) async {
    try {
      _status = AuthStatus.loading;
      _error = null;
      notifyListeners();

      final credential = await _authService.createUser(email, password);
      final firebaseUser = credential.user;

      if (firebaseUser != null) {
        await _authService.saveUserData(
          userId: firebaseUser.uid,
          fullName: fullName,
          university: university,
          email: email,
          telegram: telegram,
        );
      }

      return true;
    } catch (e) {
      _error = _parseError(e.toString());
      _status = AuthStatus.unauthenticated;
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
    required String telegram,
    required String aboutMySelf,
    required List<String> hardSkills,
    required String availability,
  }) async {
    try {
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
        telegram: telegram,
        aboutMySelf: aboutMySelf,
        hardSkills: hardSkills,
        availability: availability,
      );

      // После успешного обновления явно загружаем свежие данные из Firestore
      // так как onAuthStateChanged не срабатывает при изменении данных в Firestore
      final refreshedUser = await _authService.refreshUserData(
        userId: firebaseUser.uid,
      );

      if (refreshedUser != null) {
        _user = refreshedUser;
      }

      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e.toString());
      notifyListeners();
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      await _authService.signOut();
      // НЕ устанавливаем _user = null вручную!
      // Стрим onAuthStateChanged вернёт null автоматически
    } catch (e) {
      _error = _parseError(e.toString());
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  // Save Announcement
  Future<bool> saveAnnouncement(Announcement announcement) async {
    try {
      // _status = AuthStatus.loading;
      _error = null;
      notifyListeners();

      await _authService.saveAnnouncement(announcement: announcement);

      // _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e.toString());
      // _status = AuthStatus.authenticated;
      notifyListeners();
      return false;
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
