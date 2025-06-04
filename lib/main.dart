import 'package:dashboard_pob/page/dashboard.dart';
import 'package:dashboard_pob/page/login.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard POB',
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (context) =>
            const DashboardPage(title: 'Dashboard POB PHE WMO'),
        '/login': (context) => LoginPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
