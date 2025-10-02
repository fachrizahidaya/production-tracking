class User {
  final String? id;
  final String username;
  final String? type;
  final String? status;
  final String? token;
  final String? role;

  User(
      {this.id,
      required this.username,
      this.type,
      this.status,
      this.token,
      this.role});
}
