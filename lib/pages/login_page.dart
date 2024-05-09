import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Login anonymously'),
              onPressed: () async {
                await FirebaseAuth.instance.signInAnonymously();
              },
            ),
          ],
        ),
      ),
    );
  }
}