import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_routine/core/theme.dart';
import 'package:my_routine/features/tasks/controllers/task_controller.dart';
import 'package:my_routine/features/tasks/models/task_model.dart';
import 'package:my_routine/main_screen.dart';
import 'package:my_routine/services/notification_service.dart';
import 'package:my_routine/features/summary/summary_model.dart';
import 'package:my_routine/features/diary/diary_model.dart';
import 'package:my_routine/features/summary/summary_controller.dart';
import 'package:my_routine/features/diary/diary_controller.dart';
import 'package:my_routine/features/auth/auth_controller.dart';
import 'package:my_routine/features/goals/goal_model.dart';
import 'package:my_routine/features/progress/progress_model.dart';
import 'package:my_routine/features/goals/goal_controller.dart';
import 'package:my_routine/features/progress/progress_controller.dart';
import 'package:my_routine/features/notes/note_controller.dart';
import 'package:my_routine/features/notifications/notification_controller.dart';
import 'package:my_routine/features/onboarding/onboarding_screen.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // 1. Initialize Supabase
      try {
        await Supabase.initialize(
          url: 'https://nhlisovfqwyjkrddqdhj.supabase.co',
          anonKey:
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5obGlzb3ZmcXd5amtyZGRxZGhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ0OTE5MTEsImV4cCI6MjA4MDA2NzkxMX0.E__J95Uoi-srHO8TawgJ7C73r8Kp2Tsd1EbQw60IRRQ',
        );
        debugPrint('✓ Supabase initialized successfully');
      } catch (e, stackTrace) {
        debugPrint('✗ Supabase init failed: $e');
        debugPrint('Stack trace: $stackTrace');
        // Continue anyway - app can work in offline mode
      }

      // 2. Initialize Hive
      try {
        await Hive.initFlutter();
        Hive.registerAdapter(TaskAdapter());
        Hive.registerAdapter(SummaryModelAdapter());
        Hive.registerAdapter(DiaryModelAdapter());
        Hive.registerAdapter(GoalModelAdapter());
        Hive.registerAdapter(ProgressModelAdapter());
        debugPrint('✓ Hive initialized successfully with all adapters');
      } catch (e, stackTrace) {
        debugPrint('✗ Hive init failed: $e');
        debugPrint('Stack trace: $stackTrace');
        // Critical error - rethrow to show error screen
        throw Exception('Failed to initialize local database: $e');
      }

      // 3. Initialize Notifications
      try {
        final notificationService = NotificationService();
        await notificationService.init();
        debugPrint('✓ Notification service initialized successfully');
      } catch (e, stackTrace) {
        debugPrint('✗ Notification init failed: $e');
        debugPrint('Stack trace: $stackTrace');
        // Non-critical - app can work without notifications
      }

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
      };

      runApp(const MyApp());
    },
    (error, stack) {
      runApp(ErrorApp(error: error, stackTrace: stack));
    },
  );
}

class ErrorApp extends StatelessWidget {
  final Object error;
  final StackTrace stackTrace;

  const ErrorApp({super.key, required this.error, required this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Oops! Something went wrong.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    stackTrace.toString(),
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => TaskController()),
        ChangeNotifierProvider(create: (_) => SummaryController()..init()),
        ChangeNotifierProvider(create: (_) => DiaryController()..init()),
        ChangeNotifierProvider(create: (_) => GoalController()),
        ChangeNotifierProvider(create: (_) => ProgressController()),
        ChangeNotifierProvider(create: (_) => NoteController()..init()),
        ChangeNotifierProvider(create: (_) => NotificationController()..init()),
        ChangeNotifierProvider(
          create: (_) => ThemeManager(),
        ), // Register ThemeManager
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MaterialApp(
            title: 'AI Routine',
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light, // Force light mode
            theme: AppTheme.getTheme(
              themeManager.currentMode,
              customColors: themeManager.customColors,
            ), // Dynamic Theme
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if onboarding is seen
    // For now, we'll just show it once per session or use a Hive box later.
    // To force show it for testing:
    // return const OnboardingScreen();

    // Proper logic:
    return FutureBuilder<Box>(
      future: Hive.openBox('settings'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final box = snapshot.data;
        final bool seenOnboarding =
            box?.get('seen_onboarding', defaultValue: false) ?? false;

        if (!seenOnboarding) {
          // Mark as seen when they complete it (handled in OnboardingScreen)
          // For this implementation, we just return OnboardingScreen and let it navigate to Login
          // Ideally, OnboardingScreen should update the Hive box.
          return OnboardingScreen();
        }

        // Check authentication state
        final authController = Provider.of<AuthController>(context);
        if (authController.isGuest) {
          return const MainScreen();
        }

        return StreamBuilder<AuthState>(
          stream: Supabase.instance.client.auth.onAuthStateChange,
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            final session = authSnapshot.data?.session;
            if (session != null) {
              return const MainScreen();
            }
            // Return MainScreen directly (Guest mode by default)
            // User can access login from settings if needed
            return const MainScreen();
          },
        );
      },
    );
  }
}
