import 'package:flutter/material.dart';
import 'screens/job_seeker/message_view_page.dart';
import 'screens/job_seeker/skill_test_page.dart';
import 'screens/job_provider/job_applications_page.dart';
import 'screens/admin_page/admin_page.dart';
import 'screens/login_page.dart';
import 'screens/registration_page.dart';
import 'screens/user_profile_page.dart';
import 'screens/home_page.dart';
import 'screens/job_provider_dashboard.dart';
import 'utils/posting_helper.dart';
import 'screens/create_job_posting_form.dart';
import 'splash_screen.dart'; // Import the new splash screen

Future<void> main() async {
  runApp(const CareerBridgeApp());
}

class CareerBridgeApp extends StatelessWidget {
  const CareerBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareerBridge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Set splash screen as the initial route
      routes: {
        '/': (context) => SplashScreen(), // Splash screen route
        '/login': (context) => const LoginPage(),
        '/home': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return HomePage(
            isLoggedIn: args?['isLoggedIn'] ?? false,
            userEmail: args?['userEmail'] ?? 'User',
          );
        },
        '/jobs': (context) {
          final providerEmail = ModalRoute.of(context)?.settings.arguments as String? ?? '';
          return JobApplicationsPage(providerEmail: providerEmail);
        },
        '/message_view': (context) => MessageViewPage(userEmail: ''),
        '/adminpage': (context) => AdminPage(),
        '/skill_test': (context) => SkillTestPage(),
        '/registration': (context) => const RegistrationPage(),
        '/profile': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return UserProfilePage(email: args?['email'] ?? '');
        },
        '/dashboard': (context) {
          final providerEmail = ModalRoute.of(context)?.settings.arguments as String;
          return JobProviderDashboard(providerEmail: providerEmail);
        },
        '/job_posting': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          final providerEmail = args?['providerEmail'] ?? '';
          return CreateJobPostingForm(providerEmail: providerEmail);
        },
      },
    );
  }
}
