import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/sampling_form_screen.dart';
import 'screens/replanting_form_screen.dart';
import 'screens/notifications_screen.dart';
import 'services/api_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<NotificationService>.value(value: notificationService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intención de Siembra',
      theme: ThemeData(
        primaryColor: const Color(0xFF2C5F2D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2C5F2D),
          primary: const Color(0xFF2C5F2D),
          secondary: const Color(0xFF97BC62),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/sampling-form': (context) => const SamplingFormScreen(),
        '/replanting-form': (context) => const ReplantingFormScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
    );
  }
}
