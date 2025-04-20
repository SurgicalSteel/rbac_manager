import 'package:flutter/material.dart';
import 'package:rbac_manager/models/module.dart';

class SubmoduleDialog extends StatefulWidget {
  const SubmoduleDialog({super.key});

  @override
  State<SubmoduleDialog> createState() => _SubmoduleDialogState();
}

class _SubmoduleDialogState extends State<SubmoduleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<String> _permissions = [];
  final _permissionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Submodule'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Submodule Name',
                  hintText: 'Enter submodule name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter submodule name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter submodule description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _permissionController,
                      decoration: const InputDecoration(
                        labelText: 'Permission',
                        hintText: 'Enter permission',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_permissionController.text.isNotEmpty) {
                        setState(() {
                          _permissions.add(_permissionController.text);
                          _permissionController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_permissions.isNotEmpty) ...[
                const Text('Added Permissions:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      _permissions.map((permission) {
                        return Chip(
                          label: Text(permission),
                          onDeleted: () {
                            setState(() {
                              _permissions.remove(permission);
                            });
                          },
                        );
                      }).toList(),
                ),
              ],
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
              final submodule = SubModule(
                id: DateTime.now().toString(),
                name: _nameController.text,
                description: _descriptionController.text,
                permissions: _permissions,
              );
              Navigator.pop(context, submodule);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _permissionController.dispose();
    super.dispose();
  }
}
