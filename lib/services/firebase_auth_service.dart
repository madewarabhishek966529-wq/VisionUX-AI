import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'mock_data_service.dart';

class FirebaseAuthService {
  final fb.FirebaseAuth? _auth;

  FirebaseAuthService() : _auth = _tryGetFirebaseAuth();

  static fb.FirebaseAuth? _tryGetFirebaseAuth() {
    try {
      return fb.FirebaseAuth.instance;
    } catch (e) {
      debugPrint('Firebase Auth not initialized, operating in Fallback Mock Mode: $e');
      return null;
    }
  }

  Stream<UserModel?> get authStateChanges {
    final auth = _auth;
    if (auth == null) {
      // Mock stream for offline / fallback mode
      return Stream.value(MockDataService.instance.sampleUser);
    }
    return auth.authStateChanges().map((fbUser) {
      if (fbUser == null) return null;
      return UserModel(
        id: fbUser.uid,
        email: fbUser.email ?? '',
        displayName: fbUser.displayName ?? 'User',
        photoUrl: fbUser.photoURL,
        createdAt: DateTime.now(),
      );
    });
  }

  UserModel? get currentUser {
    final u = _auth?.currentUser;
    if (u != null) {
      return UserModel(
        id: u.uid,
        email: u.email ?? '',
        displayName: u.displayName ?? 'User',
        photoUrl: u.photoURL,
        createdAt: DateTime.now(),
      );
    }
    return MockDataService.instance.sampleUser;
  }

  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    final auth = _auth;
    if (auth == null) {
      await Future.delayed(const Duration(milliseconds: 600));
      return MockDataService.instance.sampleUser;
    }
    final credential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final u = credential.user!;
    return UserModel(
      id: u.uid,
      email: u.email ?? email,
      displayName: u.displayName ?? 'User',
      photoUrl: u.photoURL,
      createdAt: DateTime.now(),
    );
  }

  Future<UserModel> signUpWithEmailAndPassword(String email, String password, String name) async {
    final auth = _auth;
    if (auth == null) {
      await Future.delayed(const Duration(milliseconds: 600));
      return UserModel(
        id: 'usr_new_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: name,
        createdAt: DateTime.now(),
      );
    }
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final u = credential.user!;
    await u.updateDisplayName(name);
    return UserModel(
      id: u.uid,
      email: email,
      displayName: name,
      photoUrl: u.photoURL,
      createdAt: DateTime.now(),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final auth = _auth;
    if (auth != null) {
      await auth.sendPasswordResetEmail(email: email);
    }
  }

  Future<void> signOut() async {
    final auth = _auth;
    if (auth != null) {
      await auth.signOut();
    }
  }
}
