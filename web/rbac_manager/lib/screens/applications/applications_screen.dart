import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rbac_manager/models/application.dart';
import 'package:rbac_manager/models/module.dart';
import 'package:rbac_manager/providers/app_state.dart';
import 'package:rbac_manager/screens/modules/module_dialog.dart';
import 'package:rbac_manager/screens/applications/application_dialog.dart';
import 'package:rbac_manager/screens/modules/submodule_dialog.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications Management'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final application = await showDialog<Application>(
                context: context,
                builder: (context) => const ApplicationDialog(),
              );
              if (application != null) {
                if (!context.mounted) return;
                context.read<AppState>().addApplication(application);
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
                hintText: 'Search applications...',
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
                  return ListView.builder(
                    itemCount: appState.applications.length,
                    itemBuilder: (context, index) {
                      final application = appState.applications[index];
                      return ApplicationCard(application: application);
                    },
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

class ApplicationCard extends StatelessWidget {
  final Application application;

  const ApplicationCard({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(application.name),
        subtitle: Text(application.description),
        children: [
          ListTile(
            title: const Text('Modules'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final module = await showDialog<Module>(
                  context: context,
                  builder: (context) => const ModuleDialog(),
                );
                if (module != null) {
                  if (!context.mounted) return;
                  context.read<AppState>().addModuleToApplication(
                    application.id,
                    module,
                  );
                }
              },
            ),
          ),
          ...application.modules.map(
            (module) => ModuleListTile(appId: application.id, module: module),
          ),
        ],
      ),
    );
  }
}

class ModuleListTile extends StatelessWidget {
  final String appId;
  final Module module;

  const ModuleListTile({super.key, required this.appId, required this.module});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: ExpansionTile(
        title: Text(module.name),
        subtitle: Text(module.description),
        children: [
          ListTile(
            title: const Text('Sub-modules'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final submodule = await showDialog<SubModule>(
                  context: context,
                  builder: (context) => const SubmoduleDialog(),
                );
                if (submodule != null) {
                  if (!context.mounted) return;
                  context.read<AppState>().addSubModuleToModule(
                    appId,
                    module.id,
                    submodule,
                  );
                }
              },
            ),
          ),
          ...module.subModules.map(
            (subModule) => ListTile(
              title: Text(subModule.name),
              subtitle: Text(subModule.description),
            ),
          ),
        ],
      ),
    );
  }
}
