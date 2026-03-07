import '../entities/user_credentials.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(UserCredentials credentials);
  Future<UserEntity> signUp(UserCredentials credentials);
  Future<void> logout();
}
