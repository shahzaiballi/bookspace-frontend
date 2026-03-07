import '../../domain/entities/user_credentials.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<UserEntity> login(UserCredentials credentials) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate basic validation
    if (credentials.email.isEmpty || credentials.password.isEmpty) {
      throw Exception('Email and password are required');
    }
    
    return UserEntity(
      id: "usr_12345",
      name: "John Doe",
      email: credentials.email,
    );
  }

  @override
  Future<UserEntity> signUp(UserCredentials credentials) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (credentials.email.isEmpty || credentials.password.isEmpty || (credentials.fullName?.isEmpty ?? true)) {
       throw Exception('Please fill all required fields');
    }
    
    return UserEntity(
      id: "usr_67890",
      name: credentials.fullName!,
      email: credentials.email,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
