import 'package:career_bridge/not%20use%20page/profile_page.dart';
import 'package:career_bridge/screens/job_seeker/message_view_page.dart';
import 'package:career_bridge/screens/job_seeker/skill_test_page.dart';
import 'package:flutter/material.dart';
import 'not use page/image_see.dart';
import 'screens/job_provider/job_applications_page.dart';
import 'screens/login_page.dart';
import 'screens/registration_page.dart';
import 'screens/user_profile_page.dart';
import 'screens/home_page.dart';
import 'screens/job_provider_dashboard.dart';
import 'utils/posting_helper.dart';
import 'screens/create_job_posting_form.dart';

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
      initialRoute: '/login',
      routes: {
        '/home': (context) {
          final args = ModalRoute
              .of(context)!
              .settings
              .arguments as Map<String, dynamic>?;
          return HomePage(
            isLoggedIn: args?['isLoggedIn'] ?? false,
            userEmail: args?['userEmail'] ?? 'User',
          );
        },
        '/jobs': (context) {
          // Extract the provider email from ModalRoute
          final providerEmail = ModalRoute.of(context)?.settings.arguments as String? ?? '';
          return JobApplicationsPage(providerEmail: providerEmail);  // Pass the extracted or empty email
        },

        '/img' :  (context) => ImageSeePage(),
        '/message_view' :  (context) => MessageViewPage(userEmail: '',),
        '/skill_test' :  (context) => SkillTestPage(),
        '/profile_pic' :  (context) => const ProfilePage(),
        '/login': (context) => const LoginPage(),
        '/registration': (context) => const RegistrationPage(),
        '/profile': (context) {
          final args = ModalRoute
              .of(context)!
              .settings
              .arguments as Map<String, dynamic>?;
          return UserProfilePage(email: args?['email'] ?? '');
        },
        '/dashboard': (context) {
          // Get the provider email from context or authentication logic
          final providerEmail = ModalRoute
              .of(context)!
              .settings
              .arguments as String;
          return JobProviderDashboard(providerEmail: providerEmail);
        },
        '/job_posting': (context) {
          final args = ModalRoute
              .of(context)!
              .settings
              .arguments as Map?;
          final providerEmail = args?['providerEmail'] ??
              ''; // Default to empty if not provided
          return CreateJobPostingForm(providerEmail: providerEmail);
        },

      },
      );
  }
}