import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenue dans l’application !',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Exemple : naviguer vers SM Roster
                Navigator.pushNamed(context, '/sm/roster');
              },
              child: const Text('Aller à SM Roster'),
            ),
          ],
        ),
      ),
    );
  }
}
