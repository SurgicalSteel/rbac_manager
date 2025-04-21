import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbac_manager/models/role.dart';
import 'package:rbac_manager/providers/app_state.dart';
import 'package:rbac_manager/screens/roles/role_dialog.dart';
import 'package:rbac_manager/screens/roles/role_permissions_dialog.dart';

class RolesScreen extends StatelessWidget {
  const RolesScreen({super.key});

  Future<bool> _confirmDeletion(BuildContext context, String roleName) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: Text(
                'Are you sure you want to delete the role "$roleName"?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  String _getPermissionSummary(Role role, AppState appState) {
    final summaries = role.permissions
        .map((permission) {
          final app = appState.applications.firstWhere(
            (app) => app.id == permission.applicationId,
          );
          final moduleCount = permission.modulePermissions.length;
          final submoduleCount =
              permission.modulePermissions.values
                  .expand((submodules) => submodules)
                  .length;
          return '${app.name} ($moduleCount modules, $submoduleCount submodules)';
        })
        .join(', ');
    return summaries.isEmpty ? 'No permissions' : summaries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Roles Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final role = await showDialog<Role>(
                context: context,
                builder: (context) => const RoleDialog(),
              );
              if (role != null) {
                if (!context.mounted) return;
                context.read<AppState>().addRole(role);
              }
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search roles...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<AppState>(
                builder: (context, appState, child) {
                  return DataTable(
                    columns: const [
                      DataColumn(label: Text('Role Name')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Permissions')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows:
                        appState.roles.map((role) {
                          return DataRow(
                            cells: [
                              DataCell(Text(role.name)),
                              DataCell(Text(role.description)),
                              DataCell(
                                Text(_getPermissionSummary(role, appState)),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.security),
                                      tooltip: 'Manage Permissions',
                                      onPressed: () async {
                                        final updatedRole =
                                            await showDialog<Role>(
                                              context: context,
                                              builder:
                                                  (context) =>
                                                      RolePermissionsDialog(
                                                        role: role,
                                                      ),
                                            );
                                        if (updatedRole != null) {
                                          if (!context.mounted) return;
                                          context.read<AppState>().updateRole(
                                            updatedRole,
                                          );
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      tooltip: 'Edit Role',
                                      onPressed: () async {
                                        final updatedRole =
                                            await showDialog<Role>(
                                              context: context,
                                              builder:
                                                  (context) => RoleDialog(
                                                    existingRole: role,
                                                  ),
                                            );
                                        if (updatedRole != null) {
                                          if (!context.mounted) return;
                                          context.read<AppState>().updateRole(
                                            updatedRole,
                                          );
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      tooltip: 'Delete Role',
                                      onPressed: () async {
                                        final shouldDelete =
                                            await _confirmDeletion(
                                              context,
                                              role.name,
                                            );
                                        if (shouldDelete) {
                                          if (!context.mounted) return;
                                          context.read<AppState>().deleteRole(
                                            role.id,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
