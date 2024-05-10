import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: Text(_auth.currentUser == null ? 'Login anonymously' : 'Logout'),
              onPressed: () async {
                if (_auth.currentUser == null) {
                  // Pokud uživatel není přihlášen, provede se přihlášení
                  await _auth.signInAnonymously();
                } else {
                  // Pokud uživatel je přihlášen, provede se odhlášení
                  await _auth.signOut();
                }
                // Po přihlášení nebo odhlášení se přesměruje zpět na úvodní stránku
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
