import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbac_manager/models/role.dart';
import 'package:rbac_manager/providers/app_state.dart';

class RoleDialog extends StatefulWidget {
  final Role? existingRole;

  const RoleDialog({super.key, this.existingRole});

  @override
  State<RoleDialog> createState() => _RoleDialogState();
}

class _RoleDialogState extends State<RoleDialog> {
  @override
  void initState() {
    super.initState();
    if (widget.existingRole != null) {
      _nameController.text = widget.existingRole!.name;
      _descriptionController.text = widget.existingRole!.description;

      // Initialize selected permissions from existing role
      for (var permission in widget.existingRole!.permissions) {
        _selectedPermissions[permission.applicationId] = Map.fromEntries(
          permission.modulePermissions.entries.map(
            (entry) => MapEntry(entry.key, entry.value.toSet()),
          ),
        );
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Map<String, Map<String, Set<String>>> _selectedPermissions = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existingRole != null ? 'Edit Role' : 'Create New Role',
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Role Name',
                  hintText: 'Enter role name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter role name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter role description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<AppState>(
                  builder: (context, appState, child) {
                    return ListView.builder(
                      itemCount: appState.applications.length,
                      itemBuilder: (context, index) {
                        final app = appState.applications[index];
                        return ExpansionTile(
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
                                          _selectedPermissions[app.id]
                                              ?.containsKey(module.id) ??
                                          false,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedPermissions[app.id] ??= {};
                                            _selectedPermissions[app.id]![module
                                                    .id] =
                                                {};
                                          } else {
                                            _selectedPermissions[app.id]
                                                ?.remove(module.id);
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
                                                        ?.contains(
                                                          subModule.id,
                                                        ) ??
                                                    false,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    if (value == true) {
                                                      _selectedPermissions[app
                                                              .id] ??=
                                                          {};
                                                      _selectedPermissions[app
                                                              .id]![module
                                                              .id] ??=
                                                          {};
                                                      _selectedPermissions[app
                                                              .id]![module.id]!
                                                          .add(subModule.id);
                                                    } else {
                                                      _selectedPermissions[app
                                                              .id]?[module.id]
                                                          ?.remove(
                                                            subModule.id,
                                                          );
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
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
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

              final role = Role(
                id: widget.existingRole?.id ?? DateTime.now().toString(),
                name: _nameController.text,
                description: _descriptionController.text,
                permissions: permissions,
              );
              Navigator.pop(context, role);
            }
          },
          child: Text(widget.existingRole != null ? 'Save' : 'Create'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
