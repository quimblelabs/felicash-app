part of 'app_router.dart';

/// Contains all route-related constants and names for the application.
class AppRoutes {
  // Base routes
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const overview = '/';
  static const personal = '/personal';
  static const wallets = '/wallets';
  static const aiAssistant = '/ai-assistant';

  // Transaction routes
  static const transactions = '/transactions';
  static const transactionListFilters = '/filters';
  static const transactionListFilterCategories = '/categories';
  static const transactionListFilterWallets = '/wallets';
  static const transactionListFilterTypes = '/types';
  static const transactionListFilterDate = '/date';
  static const transactionCreation = '/create-transaction';
  static const voiceTransaction = '/voice-transaction';

  // Wallet creation flow
  static const walletTypeSelector = '/select-type';
  static const walletCreation = '/create/:type';
  static const balanceUpdate = '/update-balance';
}

/// Contains all route names for the application.
class AppRouteNames {
  // Base routes
  static const login = 'login';
  static const onboarding = 'onboarding';
  static const overview = 'overview';
  static const personal = 'personal';
  static const wallets = 'wallets';
  static const aiAssistant = 'aiAssistant';

  // Transaction routes
  static const transactions = 'transactions';
  static const transactionListFilters = 'transactionListFilters';
  static const transactionListFilterCategories =
      'transactionListFilterCategories';
  static const transactionListFilterWallets = 'transactionListFilterWallets';
  static const transactionListFilterTypes = 'transactionListFilterTypes';
  static const transactionListFilterDate = 'transactionListFilterDate';
  static const transactionCreation = 'createTransaction';
  static const voiceTransaction = 'voiceTransaction';

  // Wallet creation flow
  static const walletTypeSelector = 'selectWalletType';
  static const walletCreation = 'createWallet';
  static const balanceUpdate = 'updateBalance';
}
