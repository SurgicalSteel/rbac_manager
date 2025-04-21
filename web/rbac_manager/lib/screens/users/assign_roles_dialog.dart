import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbac_manager/models/user.dart';
import 'package:rbac_manager/providers/app_state.dart';

class AssignRolesDialog extends StatefulWidget {
  final User user;

  const AssignRolesDialog({super.key, required this.user});

  @override
  State<AssignRolesDialog> createState() => _AssignRolesDialogState();
}

class _AssignRolesDialogState extends State<AssignRolesDialog> {
  late Set<String> _selectedRoleIds;

  @override
  void initState() {
    super.initState();
    _selectedRoleIds = Set.from(widget.user.roleIds);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Assign Roles - ${widget.user.fullName}'),
      content: SizedBox(
        width: 400,
        height: 400,
        child: Consumer<AppState>(
          builder: (context, appState, child) {
            return Column(
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
                  child: ListView.builder(
                    itemCount: appState.roles.length,
                    itemBuilder: (context, index) {
                      final role = appState.roles[index];
                      return CheckboxListTile(
                        title: Text(role.name),
                        subtitle: Text(role.description),
                        value: _selectedRoleIds.contains(role.id),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedRoleIds.add(role.id);
                            } else {
                              _selectedRoleIds.remove(role.id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
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
            final updatedUser = User(
              id: widget.user.id,
              fullName: widget.user.fullName,
              email: widget.user.email,
              roleIds: _selectedRoleIds.toList(),
              isActive: widget.user.isActive,
            );
            Navigator.pop(context, updatedUser);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
