import 'package:felicash/app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Onboarding'),
            FilledButton(onPressed: () {}, child: const Text('Get started')),
            TextButton(
              onPressed: () {
                context.go(AppRouter.login);
              },
              child: const Text('Login now'),
            ),
          ],
        ),
      ),
    );
  }
}
