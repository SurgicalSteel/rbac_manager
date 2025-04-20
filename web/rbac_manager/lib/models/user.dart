class User {
  final String id;
  final String fullName;
  final String email;
  final List<String> roleIds;
  final bool isActive;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.roleIds = const [],
    this.isActive = true,
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    List<String>? roleIds,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      fullName: username ?? this.fullName,
      email: email ?? this.email,
      roleIds: roleIds ?? this.roleIds,
      isActive: isActive ?? this.isActive,
    );
  }
}
