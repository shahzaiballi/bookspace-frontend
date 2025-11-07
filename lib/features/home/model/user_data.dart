
class DummyUser {
  final String name;
  final String avatarUrl;

  DummyUser({required this.name, required this.avatarUrl});
}

// Currently using a single dummy user
final DummyUser currentUser = DummyUser(
  name: "Aru",
  avatarUrl: "assets/images/girl.jpg",
);
