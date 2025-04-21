import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbac_manager/models/role.dart';
import 'package:rbac_manager/providers/app_state.dart';

class RolePermissionsDialog extends StatefulWidget {
  final Role role;

  const RolePermissionsDialog({super.key, required this.role});

  @override
  State<RolePermissionsDialog> createState() => _RolePermissionsDialogState();
}

class _RolePermissionsDialogState extends State<RolePermissionsDialog> {
  late Map<String, Map<String, Set<String>>> _selectedPermissions;

  @override
  void initState() {
    super.initState();
    _selectedPermissions = {};
    for (var permission in widget.role.permissions) {
      _selectedPermissions[permission.applicationId] = Map.fromEntries(
        permission.modulePermissions.entries.map(
          (entry) => MapEntry(entry.key, entry.value.toSet()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Manage Permissions - ${widget.role.name}'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Consumer<AppState>(
          builder: (context, appState, child) {
            return ListView.builder(
              itemCount: appState.applications.length,
              itemBuilder: (context, index) {
                final app = appState.applications[index];
                return Card(
                  child: ExpansionTile(
                    title: Text(app.name),
                    leading: Checkbox(
                      value: _selectedPermissions.containsKey(app.id),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedPermissions[app.id] = {};
                          } else {
                            _selectedPermissions.remove(app.id);
                          }
                        });
                      },
                    ),
                    children:
                        app.modules.map((module) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: ExpansionTile(
                              title: Text(module.name),
                              leading: Checkbox(
                                value:
                                    _selectedPermissions[app.id]?.containsKey(
                                      module.id,
                                    ) ??
                                    false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedPermissions[app.id] ??= {};
                                      _selectedPermissions[app.id]![module.id] =
                                          {};
                                    } else {
                                      _selectedPermissions[app.id]?.remove(
                                        module.id,
                                      );
                                    }
                                  });
                                },
                              ),
                              children:
                                  module.subModules.map((subModule) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        left: 32.0,
                                      ),
                                      child: ListTile(
                                        title: Text(subModule.name),
                                        leading: Checkbox(
                                          value:
                                              _selectedPermissions[app
                                                      .id]?[module.id]
                                                  ?.contains(subModule.id) ??
                                              false,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              if (value == true) {
                                                _selectedPermissions[app.id] ??=
                                                    {};
                                                _selectedPermissions[app
                                                        .id]![module.id] ??=
                                                    {};
                                                _selectedPermissions[app
                                                        .id]![module.id]!
                                                    .add(subModule.id);
                                              } else {
                                                _selectedPermissions[app
                                                        .id]?[module.id]
                                                    ?.remove(subModule.id);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          );
                        }).toList(),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final permissions =
                _selectedPermissions.entries.map((appEntry) {
                  return RolePermission(
                    applicationId: appEntry.key,
                    modulePermissions: Map.fromEntries(
                      appEntry.value.entries.map(
                        (moduleEntry) => MapEntry(
                          moduleEntry.key,
                          moduleEntry.value.toList(),
                        ),
                      ),
                    ),
                  );
                }).toList();

            final updatedRole = Role(
              id: widget.role.id,
              name: widget.role.name,
              description: widget.role.description,
              permissions: permissions,
            );
            Navigator.pop(context, updatedRole);
          },
          child: const Text('Save Permissions'),
        ),
      ],
    );
  }
}
