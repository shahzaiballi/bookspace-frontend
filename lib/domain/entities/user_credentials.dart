class UserCredentials {
  final String email;
  final String password;
  final String? fullName; // Optional, used for Sign Up

  const UserCredentials({
    required this.email,
    required this.password,
    this.fullName,
  });
}
