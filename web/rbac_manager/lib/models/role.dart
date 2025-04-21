class RolePermission {
  final String applicationId;
  final Map<String, List<String>> modulePermissions; // moduleId -> submoduleIds

  RolePermission({
    required this.applicationId,
    required this.modulePermissions,
  });
}

class Role {
  final String id;
  final String name;
  final String description;
  final List<RolePermission> permissions;

  Role({
    required this.id,
    required this.name,
    required this.description,
    this.permissions = const [],
  });

  Role copyWith({
    String? id,
    String? name,
    String? description,
    List<RolePermission>? permissions,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      permissions: permissions ?? this.permissions,
    );
  }
}
