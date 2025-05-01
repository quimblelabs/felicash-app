import 'package:felicash/app/bloc/app_bloc.dart';
import 'package:felicash/l10n/l10n.dart';
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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.personalPageAppBarTitle),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AppBloc>().add(const AppLogOutRequested());
          },
          child: Text(l10n.personalPageLogoutButtonLabel),
        ),
      ),
    );
  }
}
