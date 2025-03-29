import 'package:app_ui/app_ui.dart';
import 'package:felicash/login/bloc/login_bloc.dart';
import 'package:felicash/login/widgets/login_with_email_password_login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(userRepository: context.read()),
      child: const LoginView(),
    );
  }
}

@visibleForTesting
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              _AppLogo(),
              SizedBox(height: AppSpacing.lg),
              _LoginTitle(),
              SizedBox(height: AppSpacing.sm),
              _LoginSubtitle(),
              SizedBox(height: AppSpacing.xxlg),
              LoginWithEmailPasswordLoginForm(),
              SizedBox(height: AppSpacing.xxlg),
              _ProvidersSeparator(),
              SizedBox(height: AppSpacing.xxlg),
              _ContinueWithAppleButton(),
              SizedBox(height: AppSpacing.sm),
              _ContinueWithGoogleButton(),
              SizedBox(height: AppSpacing.xxlg),
              _DontHaveAnAccount(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox.square(
      dimension: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(AppRadius.lg),
          ),
          color: theme.colorScheme.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Assets.images.logo.svg(
            colorFilter: ColorFilter.mode(
              theme.colorScheme.secondaryFixed,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginTitle extends StatelessWidget {
  const _LoginTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      'Login to FeliCash'.hardCoded,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _LoginSubtitle extends StatelessWidget {
  const _LoginSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Welcome back! Please enter your details'.hardCoded,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class _ProvidersSeparator extends StatelessWidget {
  const _ProvidersSeparator();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            'Or continue with'.hardCoded,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}

class _ContinueWithGoogleButton extends StatelessWidget {
  const _ContinueWithGoogleButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        context.read<LoginBloc>().add(LoginWithGoogleSubmitted());
      },
      icon: const Icon(FontAwesomeIcons.google),
      label: const Text('Continue with Google'),
    );
  }
}

class _ContinueWithAppleButton extends StatelessWidget {
  const _ContinueWithAppleButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        context.read<LoginBloc>().add(LoginWithAppleSubmitted());
      },
      icon: const Icon(FontAwesomeIcons.apple),
      label: const Text('Continue with Apple'),
    );
  }
}

//Section for Don't have an account? Sign up
class _DontHaveAnAccount extends StatelessWidget {
  const _DontHaveAnAccount();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          "Don't have an account?".hardCoded,
          style: theme.textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Sign up'.hardCoded,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
