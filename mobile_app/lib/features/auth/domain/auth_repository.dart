abstract class AuthRepository {
  Future<void> registerWithEmail({
    required String email,
    required String password,
  });
  Future<void> loginWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
  Future<void> deleteAccount();
  bool isLoggedIn();
  String? currentUserId();
}
