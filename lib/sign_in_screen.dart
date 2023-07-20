// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_calendar/auth_service.dart';
import 'package:google_calendar/home_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final user = await AuthService().signInWithGoogleRequested();
            if (user != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(user: user),
                ),
              );
            }
          },
          child: const Text('Sign in with google'),
        ),
      ),
    );
  }
}
