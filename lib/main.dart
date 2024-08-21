import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/registration_page.dart';
import 'screens/user_profile_page.dart';
import 'screens/home_page.dart'; // Import HomePage if you want to use it

void main() {
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
      // Set the initial route if you want to show HomePage by default
      initialRoute: '/login',
      routes: {
        '/home': (context) => const HomePage(isLoggedIn: true), // Replace with true if logged in
        '/login': (context) => const LoginPage(),
        '/registration': (context) => const RegistrationPage(),
        '/profile': (context) => const UserProfilePage(email: ''), // Pass the email if needed
      },
    );
  }
}
