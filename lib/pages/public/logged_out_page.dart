import 'package:flutter/material.dart';

class LoggedOutPage extends StatelessWidget {
  const LoggedOutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return // inside your LoggedOutPage build:
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Sign in to shop faster'),
          const SizedBox(height: 16),
          SizedBox(
            width: 240,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('LOG IN'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            child: const Text('Join now'),
          ),
        ],
      ),
    );
  }
}
