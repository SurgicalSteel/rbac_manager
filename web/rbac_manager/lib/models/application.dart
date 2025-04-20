import 'package:rbac_manager/models/module.dart';

class Application {
  final String id;
  final String name;
  final String description;
  final List<Module> modules;

  Application({
    required this.id,
    required this.name,
    required this.description,
    required this.modules,
  });
}
