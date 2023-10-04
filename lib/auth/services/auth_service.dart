import '../domain/app_user.dart';

abstract class AuthService {
  Future<AppUser> signIn(String email, String password);

  Future<void> signOut();

  Future<AppUser> signUp(String email, String password);
}
