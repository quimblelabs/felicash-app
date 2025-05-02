part of 'app_router.dart';

/// Contains all route-related constants and names for the application.
class AppRoutes {
  // ==================== MAIN NAVIGATION ROUTES ====================
  /// Onboarding screen for new users
  static const onboarding = '/onboarding';

  /// Login screen
  static const login = '/login';

  /// Main overview/dashboard screen (app home)
  static const overview = '/';

  /// Personal profile and settings
  static const personal = '/personal';

  /// Wallets management screen
  static const wallets = '/wallets';

  /// AI assistant feature
  static const aiAssistant = '/ai-assistant';

  // ==================== TRANSACTION ROUTES ====================
  /// Main transactions list screen
  static const transactions = '/transactions';

  /// Transaction voice input screen
  static const voiceTransaction = '/voice-transaction';

  /// Transaction creation modal
  static const transactionCreation = '/transactions';

  // Transaction filters
  /// Main filters screen
  static const transactionListFilters = '/transactions/filters';

  /// Category filter selection
  static const transactionListFilterCategories =
      '/transactions/filters/categories';

  /// Wallet filter selection
  static const transactionListFilterWallets = '/transactions/filters/wallets';

  /// Transaction type filter selection
  static const transactionListFilterTypes = '/transactions/filters/types';

  /// Date range filter selection
  static const transactionListFilterDate = '/transactions/filters/date';

  // ==================== WALLET ROUTES ====================
  /// Wallet type selection screen
  static const walletTypeSelector = '/wallets/select-type';

  /// Wallet creation screen with type parameter
  static const walletCreation = '/wallets/create/:type';

  /// Balance update screen for wallet creation
  static const balanceUpdate = '/wallets/create/:type/update-balance';

  // ==================== CATEGORY ROUTES ====================
  /// Category list management screen
  static const categoryList = '/categories';

  /// Category creation screen
  static const categoryCreation = '/categories/create';
}
