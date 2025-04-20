import 'package:flutter/foundation.dart';
import 'package:rbac_manager/models/application.dart';
import 'package:rbac_manager/models/module.dart';
import 'package:rbac_manager/models/user.dart';

class AppState extends ChangeNotifier {
  List<Application> _applications = [];

  List<Application> get applications => _applications;

  List<User> _users = [];
  List<User> get users => _users;

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void updateUser(User user) {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
      notifyListeners();
    }
  }

  void toggleUserStatus(String userId) {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users[index] = _users[index].copyWith(isActive: !_users[index].isActive);
      notifyListeners();
    }
  }

  void assignRoleToUser(String userId, String roleId) {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      final currentRoles = List<String>.from(_users[index].roleIds);
      if (!currentRoles.contains(roleId)) {
        currentRoles.add(roleId);
        _users[index] = _users[index].copyWith(roleIds: currentRoles);
        notifyListeners();
      }
    }
  }

  void addApplication(Application application) {
    _applications.add(application);
    notifyListeners();
  }

  void addModuleToApplication(String appId, Module module) {
    final appIndex = _applications.indexWhere((app) => app.id == appId);
    if (appIndex != -1) {
      final updatedModules = [..._applications[appIndex].modules, module];
      _applications[appIndex] = Application(
        id: _applications[appIndex].id,
        name: _applications[appIndex].name,
        description: _applications[appIndex].description,
        modules: updatedModules,
      );
      notifyListeners();
    }
  }

  void addSubModuleToModule(
    String appId,
    String moduleId,
    SubModule subModule,
  ) {
    final appIndex = _applications.indexWhere((app) => app.id == appId);
    if (appIndex != -1) {
      final moduleIndex = _applications[appIndex].modules.indexWhere(
        (module) => module.id == moduleId,
      );
      if (moduleIndex != -1) {
        final updatedSubModules = [
          ..._applications[appIndex].modules[moduleIndex].subModules,
          subModule,
        ];
        final updatedModule = Module(
          id: _applications[appIndex].modules[moduleIndex].id,
          name: _applications[appIndex].modules[moduleIndex].name,
          description: _applications[appIndex].modules[moduleIndex].description,
          subModules: updatedSubModules,
        );
        final updatedModules = [..._applications[appIndex].modules];
        updatedModules[moduleIndex] = updatedModule;

        _applications[appIndex] = Application(
          id: _applications[appIndex].id,
          name: _applications[appIndex].name,
          description: _applications[appIndex].description,
          modules: updatedModules,
        );
        notifyListeners();
      }
    }
  }
}
