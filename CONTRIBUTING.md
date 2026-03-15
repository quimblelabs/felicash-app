# Contributing to FeliCash

First off, thank you for considering contributing to FeliCash! It's people like you that make FeliCash such a great tool.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Project Structure](#project-structure)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Reporting Bugs](#reporting-bugs)
- [Feature Requests](#feature-requests)
- [Community](#community)

## 📜 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code:

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive feedback
- Respect different viewpoints and experiences

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ^3.5.0
- Dart SDK ^3.5.0
- Melos (`dart pub global activate melos`)
- Git

### Setting Up Your Development Environment

1. **Fork the repository** on GitHub

2. **Clone your fork locally**
   ```bash
   git clone https://github.com/YOUR_USERNAME/felicash-app.git
   cd felicash-app
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/quimblelabs/felicash-app.git
   ```

4. **Bootstrap the monorepo**
   ```bash
   melos bootstrap
   ```

5. **Set Up Supabase**
   
   You'll need a Supabase project for local development:
   
   1. Create a free account at [supabase.com](https://supabase.com)
   2. Create a new project (e.g., `felicash-dev`)
   3. Set up the database schema - see [Self-Hosting Guide](docs/SELF_HOSTING.md#database-schema) for SQL scripts
   4. Get your Project URL and Anon Key from Project Settings > API
   5. Enable Authentication providers (Email, Google, Apple) as needed

6. **Configure Environment Variables**
   
   Copy the example configuration and set up your development environment:
   ```bash
   cp configurations.example.json configurations.dev.json
   ```
   
   Edit `configurations.dev.json` with your API keys. At minimum, you need:
   - `SUPABASE_URL` and `SUPABASE_ANON_KEY` (from your Supabase project)
   - `FELICASH_LOCAL_DB_NAME` (e.g., `felicash_dev.db`)
   
   Optional for specific features:
   - `N8N_BASE_URL` (if testing AI features)
   - `POWERSYNC_URL` (if testing offline sync)
   - `IOS_CLIENT_ID` and `WEB_CLIENT_ID` (for Google Sign-In)
   
   > **Note:** Never commit configuration files with real API keys! They are automatically gitignored.

7. **Configure Firebase (Optional)**
   
   For push notifications and analytics:
   ```bash
   ./flutterfire-config.sh
   ```

8. **Verify your setup**
   ```bash
   flutter doctor
   flutter analyze
   ```
   
   Run the app with your configuration:
   ```bash
   flutter run --flavor development --target lib/main/main_development.dart --dart-define-from-file configurations.dev.json
   ```

## 🔄 Development Workflow

### Branch Naming Convention

- `feature/description` - New features
- `bugfix/description` - Bug fixes
- `docs/description` - Documentation changes
- `refactor/description` - Code refactoring
- `test/description` - Test additions or updates
- `chore/description` - Maintenance tasks

Example: `feature/voice-transaction-improvements`

### Making Changes

1. **Create a new branch from `main`**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write clean, maintainable code
   - Follow our coding standards (see below)
   - Add tests for new functionality
   - Update documentation as needed

3. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add voice transaction improvements"
   ```

   We follow [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` - New features
   - `fix:` - Bug fixes
   - `docs:` - Documentation changes
   - `style:` - Code style changes (formatting, semicolons, etc.)
   - `refactor:` - Code refactoring
   - `test:` - Test additions or updates
   - `chore:` - Build process or auxiliary tool changes

4. **Keep your branch up to date**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request** on GitHub

## 🏗️ Project Structure

Understanding the project structure is crucial for effective contributions:

```
felicash/
├── lib/                      # Main application
│   ├── app/                  # App configuration, routing
│   │   ├── app.dart         # App exports
│   │   ├── bloc/            # Global BLoCs
│   │   ├── routes/          # go_router configuration
│   │   └── view/            # App view
│   ├── ai_assistant/         # AI chatbot features
│   ├── category/             # Category management
│   ├── currency/             # Currency handling
│   ├── home/                 # Home screen
│   ├── login/                # Authentication
│   ├── navigation/           # Bottom navigation
│   ├── onboarding/           # Onboarding flow
│   ├── overview/             # Dashboard & analytics
│   ├── personal/             # User profile
│   ├── transaction/          # Transaction management
│   ├── user_setting/         # User settings
│   ├── voice_transaction/    # Voice input features
│   ├── wallet/               # Wallet management
│   ├── wallet_creation/      # Wallet creation
│   ├── l10n/                 # Localization
│   └── main/                 # Entry points
│
├── packages/                 # Modular packages
│   ├── app_ui/              # UI components
│   ├── app_utils/           # Utilities
│   ├── form_inputs/         # Form validation
│   ├── shared_models/       # Shared models
│   ├── clients/             # External service clients
│   │   ├── ai_client/
│   │   │   ├── ai_client/
│   │   │   └── n8n_ai_client/
│   │   ├── authentication_client/
│   │   │   ├── authentication_client/
│   │   │   ├── supabase_authentication_client/
│   │   │   └── token_storage/
│   │   ├── dio_client/
│   │   ├── felicash_data_client/
│   │   ├── felicash_storage_client/
│   │   ├── permission_client/
│   │   ├── speech_to_text_client/
│   │   └── text_to_speech_client/
│   └── repositories/        # Data repositories
│       ├── category_repository/
│       ├── currency_repository/
│       ├── recurrence_repository/
│       ├── transaction_repository/
│       ├── user_repository/
│       ├── user_setting_repository/
│       └── wallet_repository/
│
├── test/                    # Main app tests
└── docs/                    # Documentation
```

### Package Development

When working on packages in the `packages/` directory:

1. Navigate to the package directory
2. Run `flutter pub get`
3. Make your changes
4. Run tests: `flutter test --coverage`
5. Update the package's README if needed

## 📝 Coding Standards

We use [Very Good Analysis](https://pub.dev/packages/very_good_analysis) for linting. Key principles:

### Dart Style Guide

- Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `very_good_analysis` rules (configured in `analysis_options.yaml`)
- Line length: 80 characters
- Use trailing commas for better diffs

### Code Organization

```dart
// Good: Organize imports
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_ui/app_ui.dart';
import 'package:felicash/l10n/l10n.dart';

part 'my_bloc.freezed.dart';

// Class documentation
/// A BLoC that manages transaction state.
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  // ...
}
```

### State Management (BLoC Pattern)

```dart
// Events
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class TransactionCreated extends TransactionEvent {
  const TransactionCreated(this.transaction);
  
  final TransactionModel transaction;
  
  @override
  List<Object> get props => [transaction];
}

// States
class TransactionState extends Equatable {
  const TransactionState({
    this.status = TransactionStatus.initial,
    this.transactions = const [],
  });
  
  final TransactionStatus status;
  final List<TransactionModel> transactions;
  
  TransactionState copyWith({
    TransactionStatus? status,
    List<TransactionModel>? transactions,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
    );
  }
  
  @override
  List<Object> get props => [status, transactions];
}
```

### Widget Structure

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myPageTitle),
      ),
      body: BlocBuilder<MyBloc, MyState>(
        builder: (context, state) {
          return switch (state.status) {
            MyStatus.loading => const LoadingWidget(),
            MyStatus.success => const SuccessWidget(),
            MyStatus.failure => const ErrorWidget(),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
```

### Internationalization

Always use localized strings:

```dart
// Good
Text(context.l10n.helloWorld)

// Bad
Text('Hello World')
```

Add new strings to `lib/l10n/arb/app_en.arb`:

```json
{
  "helloWorld": "Hello World",
  "@helloWorld": {
    "description": "Greeting shown on home screen"
  }
}
```

## 🧪 Testing

### Writing Tests

We use `flutter_test` and `bloc_test` for testing:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransactionRepository extends Mock 
    implements TransactionRepository {}

void main() {
  group('TransactionBloc', () {
    late TransactionRepository repository;
    late TransactionBloc bloc;

    setUp(() {
      repository = MockTransactionRepository();
      bloc = TransactionBloc(repository: repository);
    });

    blocTest<TransactionBloc, TransactionState>(
      'emits [loading, success] when transaction is created',
      build: () => bloc,
      act: (bloc) => bloc.add(const TransactionCreated(mockTransaction)),
      expect: () => [
        const TransactionState(status: TransactionStatus.loading),
        const TransactionState(
          status: TransactionStatus.success,
          transactions: [mockTransaction],
        ),
      ],
    );
  });
}
```

### Running Tests

```bash
# All tests
flutter test --coverage

# Specific package
cd packages/app_ui && flutter test --coverage

# With random ordering
flutter test --test-randomize-ordering-seed random
```

### Test Coverage

- Aim for >80% code coverage
- Test all public APIs
- Include edge cases and error scenarios
- Use `mocktail` for mocking

## 🔀 Pull Request Process

1. **Before Submitting**
   - [ ] Code follows style guidelines
   - [ ] All tests pass
   - [ ] New tests added for new functionality
   - [ ] Documentation updated
   - [ ] CHANGELOG.md updated (if applicable)

2. **PR Description Template**
   ```markdown
   ## Description
   Brief description of changes

   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Breaking change
   - [ ] Documentation update

   ## Testing
   Describe the tests you ran

   ## Screenshots (if applicable)
   Add screenshots for UI changes

   ## Checklist
   - [ ] My code follows the style guidelines
   - [ ] I have performed a self-review
   - [ ] I have commented my code, particularly in hard-to-understand areas
   - [ ] I have made corresponding changes to the documentation
   - [ ] My changes generate no new warnings
   - [ ] I have added tests that prove my fix is effective or feature works
   - [ ] New and existing unit tests pass locally
   ```

3. **Review Process**
   - At least one maintainer approval required
   - Address review comments promptly
   - Keep discussions constructive

4. **After Merge**
   - Delete your branch
   - Update related issues

## 🐛 Reporting Bugs

### Before Reporting

- Check if the bug is already reported in [Issues](https://github.com/quimblelabs/felicash-app/issues)
- Try the latest development version
- Verify it's not a configuration issue

### Bug Report Template

```markdown
**Description**
A clear description of the bug

**Steps to Reproduce**
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

**Expected Behavior**
What you expected to happen

**Actual Behavior**
What actually happened

**Screenshots**
If applicable, add screenshots

**Environment**
- OS: [e.g., iOS 16, Android 13]
- App Version: [e.g., 1.0.0]
- Flutter Version: [e.g., 3.16.0]
- Device: [e.g., iPhone 14 Pro]

**Additional Context**
Add any other context about the problem
```

## 💡 Feature Requests

### Feature Request Template

```markdown
**Is your feature request related to a problem?**
A clear description of what the problem is

**Describe the solution you'd like**
A clear description of what you want to happen

**Describe alternatives you've considered**
Any alternative solutions or features

**Additional context**
Add any other context or screenshots
```

## 👥 Community

- **Discussions**: [GitHub Discussions](https://github.com/quimblelabs/felicash-app/discussions)
- **Issues**: [GitHub Issues](https://github.com/quimblelabs/felicash-app/issues)

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [BLoC Library](https://bloclibrary.dev)
- [Very Good Ventures Blog](https://verygood.ventures/blog)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

## ❓ Questions?

Feel free to:
- Open a [Discussion](https://github.com/quimblelabs/felicash-app/discussions)
- Create an [Issue](https://github.com/quimblelabs/felicash-app/issues)

---

Thank you for contributing to FeliCash! 🎉
