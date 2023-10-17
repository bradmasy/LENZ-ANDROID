abstract class AuthService {
  Future<Map<String, dynamic>> signIn(String email, String password);

  Future<void> signOut();

  Future<Map<String, dynamic>> signUp(String email, String password);
}
