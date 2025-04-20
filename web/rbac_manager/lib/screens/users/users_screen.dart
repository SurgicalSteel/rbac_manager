import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbac_manager/models/user.dart';
import 'package:rbac_manager/providers/app_state.dart';
import 'package:rbac_manager/screens/users/user_dialog.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Users Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final user = await showDialog<User>(
                context: context,
                builder: (context) => const UserDialog(),
              );
              if (user != null) {
                if (!context.mounted) return;
                context.read<AppState>().addUser(user);
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
                hintText: 'Search users by full name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<AppState>(
                builder: (context, appState, child) {
                  final filteredUsers =
                      appState.users
                          .where(
                            (user) => user.fullName.toLowerCase().contains(
                              _searchQuery,
                            ),
                          )
                          .toList();

                  return DataTable(
                    columns: const [
                      DataColumn(label: Text('Id')),
                      DataColumn(label: Text('Full Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows:
                        filteredUsers.map((user) {
                          return DataRow(
                            cells: [
                              DataCell(Text(user.id)),
                              DataCell(Text(user.fullName)),
                              DataCell(Text(user.email)),
                              DataCell(
                                Text(user.isActive ? 'Active' : 'Inactive'),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.assignment_ind),
                                      tooltip: 'Assign Role',
                                      onPressed: () {
                                        // TODO: Implement role assignment dialog
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        user.isActive
                                            ? Icons.block
                                            : Icons.check_circle,
                                      ),
                                      tooltip:
                                          user.isActive
                                              ? 'Deactivate User'
                                              : 'Activate User',
                                      onPressed: () {
                                        context
                                            .read<AppState>()
                                            .toggleUserStatus(user.id);
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
