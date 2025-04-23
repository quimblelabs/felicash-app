import 'package:felicash/app/bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PersonalView();
  }
}

class PersonalView extends StatelessWidget {
  const PersonalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AppBloc>().add(const AppLogOutRequested());
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
