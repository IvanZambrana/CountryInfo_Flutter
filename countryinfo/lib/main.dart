import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:f1info/constants/routes.dart';
import 'package:f1info/services/auth/auth_service.dart';
import 'package:f1info/views/login_view.dart';
import 'package:f1info/views/home_view.dart';
import 'package:f1info/views/register_view.dart';
import 'package:f1info/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'NationFi',
    theme: ThemeData(
      primarySwatch: Colors.amber,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      homeRoute: (context) => const HomeView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
  } catch (e) {
    throw('Error initializing Firebase: $e');
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const HomeView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }


 
}