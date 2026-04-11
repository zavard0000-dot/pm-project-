import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamup/models/models.dart';

abstract class AuthInterface {
  Stream<MyUser?> get onAuthStateChanged;
  Future<void> signOut();
  Future<UserCredential> signIn(String email, String password);
  Future<UserCredential> createUser(String email, String password);
  Future<void> resetPassword({required String email});
  // Другие методы: signIn, signUp...
}
