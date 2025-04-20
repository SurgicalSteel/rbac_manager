import 'package:flutter/material.dart';
import 'package:rbac_manager/screens/dashboard.dart';
import 'package:rbac_manager/providers/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const RBACManagerApp(),
    ),
  );
}

class RBACManagerApp extends StatelessWidget {
  const RBACManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RBAC Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
