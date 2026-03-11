part of 'app_router.dart';

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
  static const transactionDetails = 'transactionDetails';
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

  // Category routes
  static const categoryList = 'categoryList';
  static const categoryCreation = 'createCategory';
}
