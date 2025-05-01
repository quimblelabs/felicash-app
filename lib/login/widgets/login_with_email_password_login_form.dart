import 'package:app_ui/app_ui.dart';
import 'package:felicash/l10n/l10n.dart';
import 'package:felicash/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';

class LoginWithEmailPasswordLoginForm extends StatelessWidget {
  const LoginWithEmailPasswordLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _EmailInput(),
        SizedBox(height: AppSpacing.md),
        _PasswordInput(),
        SizedBox(height: AppSpacing.xlg),
        _LoginButton(),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final displayError = context.select(
      (LoginBloc bloc) => bloc.state.email.displayError,
    );
    final status = context.select((LoginBloc bloc) => bloc.state.status);
    return TextFormField(
      readOnly: status.isInProgress,
      onChanged: (value) => context
          .read<LoginBloc>() //
          .add(LoginEmailChanged(value)),
      decoration: InputDecoration(
        hintText: l10n.loginWithEmailPasswordLoginFormEmailFieldLabel,
        errorText: displayError != null
            ? l10n.loginWithEmailPasswordLoginFormEmailFieldErrorText
            : null,
      ),
      textInputAction: TextInputAction.next,
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final displayError = context.select(
      (LoginBloc bloc) => bloc.state.password.displayError,
    );
    final status = context.select((LoginBloc bloc) => bloc.state.status);
    final valid = context.select((LoginBloc bloc) => bloc.state.valid);
    return TextFormField(
      readOnly: status.isInProgress,
      onChanged: (value) => context
          .read<LoginBloc>() //
          .add(LoginPasswordChanged(value)),
      decoration: InputDecoration(
        hintText: l10n.loginWithEmailPasswordLoginFormPasswordFieldLabel,
        errorText: displayError != null
            ? l10n.loginWithEmailPasswordLoginFormPasswordFieldErrorText
            : null,
      ),
      onFieldSubmitted: valid
          ? (_) =>
              context.read<LoginBloc>().add(LoginWithEmailPasswordSubmitted())
          : null,
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.select((LoginBloc bloc) => bloc.state);
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: state.valid
            ? () =>
                context.read<LoginBloc>().add(LoginWithEmailPasswordSubmitted())
            : null,
        child: state.status.isInProgress
            ? Builder(
                builder: (context) {
                  return SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(
                      color: DefaultTextStyle.of(context).style.color,
                    ),
                  );
                },
              )
            : Text(l10n.loginWithEmailPasswordLoginFormLoginButtonText),
      ),
    );
  }
}
