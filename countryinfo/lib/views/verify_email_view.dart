import 'package:flutter/material.dart';
import 'package:f1info/constants/routes.dart';
import 'package:f1info/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF19222B),
      appBar: AppBar(
        title: const Text(
          'Verify email',
          style: TextStyle(
            color: Color(0xFFDDD6CC),
          ),
        ),
        backgroundColor: const Color(0xFFB84357),
        iconTheme: const IconThemeData(
          color: Color(0xFFDDD6CC),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          const Padding(
            padding: EdgeInsets.only(top: 30.0),
            child:
          Text(
            "We've sent you an email verification. Please check your inbox",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            "If you haven't received it yet, press the button below",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBD9240),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Send email verification',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          TextButton(
            onPressed: () async {
              AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFBD9240),
            ),
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
