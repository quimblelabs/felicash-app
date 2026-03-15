# FeliCash Architecture

This document provides a comprehensive overview of FeliCash's architecture, design patterns, and technical decisions.

## 📑 Table of Contents

- [Overview](#overview)
- [Architecture Patterns](#architecture-patterns)
- [Project Structure](#project-structure)
- [Data Flow](#data-flow)
- [State Management](#state-management)
- [Dependency Injection](#dependency-injection)
- [Package Architecture](#package-architecture)
- [External Services](#external-services)
- [Security](#security)
- [Performance Considerations](#performance-considerations)

## 🎯 Overview

FeliCash is built using a **modular monorepo architecture** that emphasizes:

- **Separation of Concerns**: Clear boundaries between UI, business logic, and data
- **Testability**: Dependency injection and interface-based design
- **Scalability**: Modular packages that can evolve independently
- **Maintainability**: Consistent patterns and code organization

## 🏗️ Architecture Patterns

### Clean Architecture

We follow a layered architecture inspired by Clean Architecture principles:

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  (Widgets, Pages, BLoCs, Cubits)       │
├─────────────────────────────────────────┤
│           Domain Layer                  │
│  (Models, Entities, Repository Interfaces)
├─────────────────────────────────────────┤
│           Data Layer                    │
│  (Repositories, Data Sources, Clients)  │
└─────────────────────────────────────────┘
```

### BLoC Pattern (Business Logic Component)

State management follows the BLoC pattern using `flutter_bloc`:

```
UI Widget → Event → BLoC → State → UI Widget
                ↓
            Repository
                ↓
            Data Source
```

Example:

```dart
// Event
class LoadTransactions extends TransactionEvent {}

// BLoC
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc({required this.repository}) : super(const TransactionState()) {
    on<LoadTransactions>(_onLoadTransactions);
  }
  
  final TransactionRepository repository;
  
  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));
    try {
      final transactions = await repository.getTransactions();
      emit(state.copyWith(
        status: TransactionStatus.success,
        transactions: transactions,
      ));
    } catch (e) {
      emit(state.copyWith(status: TransactionStatus.failure));
    }
  }
}
```

### Repository Pattern

Abstract data access through repository interfaces:

```dart
// Interface
abstract class TransactionRepository {
  Future<List<TransactionModel>> getTransactions();
  Future<void> createTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
}

// Implementation
class SupabaseTransactionRepository implements TransactionRepository {
  SupabaseTransactionRepository({required this.client});
  
  final FelicashDataClient client;
  
  @override
  Future<List<TransactionModel>> getTransactions() async {
    return client.transactions.getAll();
  }
  // ...
}
```

## 📁 Project Structure

### Monorepo Organization

```
felicash/
├── lib/                          # Main application
│   ├── app/                      # App-level configuration
│   │   ├── app.dart             # App widget exports
│   │   ├── bloc/                # Global BLoCs (AppBloc)
│   │   ├── routes/              # Routing configuration (go_router)
│   │   │   ├── app_router.dart
│   │   │   ├── app_routes.dart
│   │   │   └── app_routes_names.dart
│   │   └── view/                # App view
│   │       └── app.dart
│   │
│   ├── ai_assistant/            # AI chatbot and voice features
│   ├── category/                # Category management
│   │   ├── categories/          # Category list and selection
│   │   └── creation/            # Category creation
│   ├── currency/                # Currency selection and management
│   ├── home/                    # Home screen with bottom navigation
│   ├── login/                   # Authentication screens
│   ├── navigation/              # Bottom navigation bar
│   ├── onboarding/              # Onboarding flow
│   ├── overview/                # Dashboard and analytics
│   │   ├── overview/            # Main overview page
│   │   ├── spending_by_category/# Spending analytics
│   │   └── summary_trending/    # Trending charts
│   ├── personal/                # User profile and settings
│   ├── transaction/             # Transaction CRUD operations
│   │   ├── transaction_form/    # Transaction creation/editing
│   │   ├── transaction_list/    # Transaction list view
│   │   └── transaction_list_filter/ # Filter modals
│   ├── user_setting/            # User settings management
│   ├── voice_transaction/       # Voice-based transaction creation
│   ├── wallet/                  # Wallet management
│   ├── wallet_creation/         # Wallet creation flows
│   ├── l10n/                    # Localization
│   └── main/                    # Entry points
│       ├── bootstrap.dart
│       ├── main_development.dart
│       ├── main_staging.dart
│       └── main_production.dart
│
├── packages/                     # Modular packages
│   ├── app_ui/                  # UI components and themes
│   ├── app_utils/               # Utility functions and extensions
│   ├── form_inputs/             # Form validation and input handling
│   ├── shared_models/           # Shared data models and enums
│   ├── clients/                 # External service clients
│   │   ├── ai_client/           # AI client abstractions
│   │   │   └── ai_client/       # Base AI client package
│   │   │   └── n8n_ai_client/   # n8n workflow AI client
│   │   ├── authentication_client/
│   │   │   ├── authentication_client/  # Auth client interface
│   │   │   ├── supabase_authentication_client/
│   │   │   └── token_storage/         # Token storage implementations
│   │   ├── dio_client/          # HTTP client configuration
│   │   ├── felicash_data_client/ # Data layer client (PowerSync + Supabase)
│   │   ├── felicash_storage_client/ # File storage client
│   │   ├── permission_client/   # Device permissions
│   │   ├── speech_to_text_client/ # Speech recognition
│   │   └── text_to_speech_client/ # Text-to-speech
│   └── repositories/            # Data repositories
│       ├── category_repository/
│       ├── currency_repository/
│       ├── recurrence_repository/
│       ├── transaction_repository/
│       ├── user_repository/
│       ├── user_setting_repository/
│       └── wallet_repository/
│
├── test/                        # Integration tests
└── docs/                        # Documentation
```

### Feature Module Structure

Each feature follows a consistent structure:

```
lib/transaction/transaction_form/
├── bloc/
│   ├── transaction_form_bloc.dart
│   ├── transaction_form_event.dart
│   └── transaction_form_state.dart
├── view/
│   └── transaction_form_modal.dart
└── widgets/
    ├── transaction_form.dart
    └── wallet_selector.dart
```

## 🔄 Data Flow

### Transaction Creation Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   User      │────▶│  Voice/     │────▶│  AI Client  │
│   Input     │     │  Manual     │     │  (n8n)      │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                               │
                                               ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Wallet    │◀────│ Transaction │◀────│  Parsed     │
│   Updated   │     │  Repository │     │  Data       │
└─────────────┘     └─────────────┘     └─────────────┘
        │
        ▼
┌─────────────┐
│   UI        │
│   Updated   │
└─────────────┘
```

### Data Synchronization

The app uses PowerSync for offline-first data synchronization with Supabase:

```dart
// Real-time updates via PowerSync
class TransactionRepository {
  Stream<List<TransactionModel>> watchTransactions() {
    return dataClient.watchQuery(
      'SELECT * FROM transactions WHERE user_id = ?',
      [userId],
    ).map((data) => data.map(TransactionModel.fromJson).toList());
  }
}
```

## 🎛️ State Management

### Global State

Managed at the app level:

```dart
// app/bloc/app_bloc.dart
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required UserRepository userRepository,
    required User user,
  }) : super(const AppState()) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
  }
}
```

### Feature State

Local to each feature:

```dart
// transaction/bloc/transactions_bloc.dart
class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  // Feature-specific state management
}
```

### UI State

Managed with Cubits for simple UI state:

```dart
// home/cubit/home_cubit.dart
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());
  
  void setTab(int index) => emit(state.copyWith(selectedTab: index));
}
```

## 💉 Dependency Injection

We use `flutter_bloc`'s `RepositoryProvider` and `BlocProvider` for dependency injection:

```dart
// main/bootstrap.dart
Future<void> bootstrap(AppBuilder builder) async {
  final supabase = await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  final dataClient = await FelicashDataClient.create(
    dbName: const String.fromEnvironment('FELICASH_LOCAL_DB_NAME'),
    endpoint: const String.fromEnvironment('POWERSYNC_URL'),
    supabaseClient: supabase.client,
  );
  
  // Repositories are provided via RepositoryProvider in app/view/app.dart
  runApp(await builder(dataClient));
}
```

Repository injection in [`lib/app/view/app.dart`](lib/app/view/app.dart):

```dart
return MultiRepositoryProvider(
  providers: [
    RepositoryProvider<UserRepository>.value(value: _userRepository),
    RepositoryProvider<WalletRepository>.value(value: _walletRepository),
    RepositoryProvider<TransactionRepository>.value(value: _transactionRepository),
    // ... other repositories
  ],
  child: MultiBlocProvider(...),
);
```

## 📦 Package Architecture

### Package Dependencies

```
app (main)
├── app_ui
├── app_utils
├── form_inputs
├── shared_models
├── repositories/*
│   └── depend on clients/*
└── clients/*
    ├── ai_client/* (nested: ai_client/, n8n_ai_client/)
    ├── authentication_client/* (nested packages)
    └── ...
```

### Package Guidelines

1. **No circular dependencies** between packages
2. **Shared models** in `shared_models` package
3. **UI components** in `app_ui` package
4. **Client interfaces** abstract external services
5. **Nested client packages** under `packages/clients/ai_client/` and `packages/clients/authentication_client/`

### Creating a New Package

```bash
# In packages/ directory
flutter create --template=package my_package

# Add to melos.yaml
# Run melos bootstrap
melos bootstrap
```

## 🔌 External Services

### Supabase Integration

```dart
// clients/felicash_data_client
class FelicashDataClient {
  FelicashDataClient({required SupabaseClient client}) : _client = client;
  
  final SupabaseClient _client;
  
  SupabaseQueryBuilder get transactions => _client.from('transactions');
  SupabaseQueryBuilder get wallets => _client.from('wallets');
  SupabaseQueryBuilder get categories => _client.from('categories');
}
```

### PowerSync Integration

PowerSync is used as the app-local sync layer for finance-domain data.

- Local schema source:
  `packages/clients/felicash_data_client/lib/src/models/schema.dart`
- Synced tables include:
  `wallets`, `transactions`, `categories`, `credit_wallets`,
  `savings_wallets`, `recurrences`, `exchange_rates`, `user_settings`,
  `budgets`, `budget_trackings`, `merchants`, `payback_links`,
  `lending_borrowing_transactions`, and `profiles`
- AI query/log/document tables are backend-only and are not part of the
  current local schema.
- In local storage, boolean-like values are normalized as integer columns
  (for example `wallet_archived`, `wallet_exclude_from_total`,
  `category_enabled`).

### AI/n8n Integration

```dart
// clients/ai_client/n8n_ai_client
class N8nAiClient implements AiClient {
  N8nAiClient({required Dio dio}) : _dio = dio;
  
  final Dio _dio;
  
  @override
  Future<ExtractedTransaction> extractTransactionFromText(String text) async {
    // Implementation
  }
}
```

### Speech-to-Text

```dart
// clients/speech_to_text_client
class SpeechToTextClient {
  Future<bool> initialize();
  Future<void> listen({required Function(String) onResult});
  Future<void> stop();
}
```

## 🔒 Security

### Authentication Flow

```
User → Google/Apple Sign-In → Supabase Auth → JWT Token → Token Storage
```

### Data Protection

- **Row Level Security (RLS)** in Supabase
- **Token storage** via `token_storage` package (includes in-memory storage for development)
- **Environment-based configuration** for API keys

```sql
-- Example RLS policy
CREATE POLICY "Users can only access their own transactions"
ON transactions FOR ALL
USING (auth.uid() = user_id);
```

> **Note:** The development environment uses in-memory token storage. Production deployments should configure secure token storage appropriate for their platform.

## ⚡ Performance Considerations

### Optimization Strategies

1. **Lazy Loading**
   ```dart
   ListView.builder(
     itemBuilder: (context, index) {
       return TransactionItem(transaction: transactions[index]);
     },
   )
   ```

2. **Image Caching**
   ```dart
   CachedNetworkImage(
     imageUrl: transaction.imageUrl,
     placeholder: (context, url) => const CircularProgressIndicator(),
   )
   ```

3. **Debounced Search**
   ```dart
   Timer? _debounce;
   
   void onSearchChanged(String query) {
     _debounce?.cancel();
     _debounce = Timer(const Duration(milliseconds: 500), () {
       context.read<SearchBloc>().add(SearchQueryChanged(query));
     });
   }
   ```

4. **Pagination**
   ```dart
   class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
     static const _limit = 20;
     
     Future<void> _onLoadMore(
       LoadMoreTransactions event,
       Emitter<TransactionsState> emit,
     ) async {
       final offset = state.transactions.length;
       final newTransactions = await repository.getTransactions(
         limit: _limit,
         offset: offset,
       );
       // ...
     }
   }
   ```

## 🧪 Testing Architecture

### Unit Tests

```dart
// Test BLoCs in isolation
blocTest<TransactionBloc, TransactionState>(
  'emits success when transaction is created',
  build: () => TransactionBloc(repository: mockRepository),
  act: (bloc) => bloc.add(const CreateTransaction(mockTransaction)),
  expect: () => [
    const TransactionState(status: TransactionStatus.loading),
    const TransactionState(status: TransactionStatus.success),
  ],
);
```

### Widget Tests

```dart
testWidgets('displays transaction list', (tester) async {
  await tester.pumpApp(
    RepositoryProvider.value(
      value: mockRepository,
      child: const TransactionsPage(),
    ),
  );
  
  expect(find.byType(TransactionList), findsOneWidget);
});
```

### Integration Tests

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('full transaction flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    
    // Navigate and create transaction
    await tester.tap(find.byIcon(Icons.add));
    // ...
  });
}
```

## 📚 Additional Resources

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [BLoC Library Documentation](https://bloclibrary.dev)
- [Supabase Documentation](https://supabase.com/docs)
- [Very Good Architecture](https://verygood.ventures/blog/very-good-architecture)

---

For questions about architecture decisions, please open a [Discussion](https://github.com/quimblelabs/felicash-app/discussions).
