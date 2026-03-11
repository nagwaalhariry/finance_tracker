import 'package:firebase_auth/firebase_auth.dart';

import '../domain/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<void> registerWithEmail({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;
    await user.delete();
  }

  @override
  bool isLoggedIn() => _firebaseAuth.currentUser != null;

  @override
  String? currentUserId() => _firebaseAuth.currentUser?.uid;
}
