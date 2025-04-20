class Module {
  final String id;
  final String name;
  final String description;
  final List<SubModule> subModules;

  Module({
    required this.id,
    required this.name,
    required this.description,
    required this.subModules,
  });
}

class SubModule {
  final String id;
  final String name;
  final String description;
  final List<String> permissions;

  SubModule({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
  });
}
