import 'package:bg4102_software/service/auth/auth_user.dart';


//Creation of abtract class
abstract class AuthProvider {
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<AuthUser> sendPasswordResetEmail({
    required String email,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
