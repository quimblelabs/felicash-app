import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// Text shown when an unknown value
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Text shown when an unknown error occurs
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// Text shown when the current date is today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Text shown when the current date is yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Text shown when the from filter is selected
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// Text shown when the to filter is selected
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// Text shown when the update button is pressed
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Text shown when the day filter is selected
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// Text shown when the week filter is selected
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// Text shown when the month filter is selected
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// Text shown when the custom filter is selected
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// Text shown when AI is thinking
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get thinking;

  /// Text shown when copying a message
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Text shown when done
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Text shown when selecting all
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// Text shown when deselecting all
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get deselectAll;

  /// Error message shown when no source wallet is found
  ///
  /// In en, this message translates to:
  /// **'No source wallet found'**
  String get aiAssistantPageNoSourceWalletFoundErrorMessage;

  /// Title shown in AI assistant page app bar
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistantPageAppBarTitle;

  /// Error message shown when something goes wrong
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get chatBotErrorMessage;

  /// Text shown when chat bot says hello
  ///
  /// In en, this message translates to:
  /// **'Hello there !'**
  String get chatBotHelloText;

  /// Hint text shown when input box is listening
  ///
  /// In en, this message translates to:
  /// **'Listening'**
  String get inputBoxListeningHintText;

  /// Hint text shown when input box is describing a transaction
  ///
  /// In en, this message translates to:
  /// **'Describe your transaction'**
  String get inputBoxDescribeTransactionHintText;

  /// Title shown when selecting a wallet
  ///
  /// In en, this message translates to:
  /// **'Select a wallet'**
  String get inputBoxSelectorModalTitle;

  /// Error message shown when no wallet is found
  ///
  /// In en, this message translates to:
  /// **'No wallet found'**
  String get inputBoxNoWalletFoundErrorMessage;

  /// Error message shown when no source wallet is found
  ///
  /// In en, this message translates to:
  /// **'No source wallet found'**
  String get inputBoxNoSourceWalletFoundErrorMessage;

  /// Hint text shown when searching for a currency
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencySelectorTextFormFieldDefaultHintText;

  /// Title shown when picking a currency
  ///
  /// In en, this message translates to:
  /// **'Pick a currency'**
  String get currencySelectorModalTitle;

  /// Title shown when logging in
  ///
  /// In en, this message translates to:
  /// **'Login to FeliCash'**
  String get loginPageTitle;

  /// Subtitle shown when logging in
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Please enter your details'**
  String get loginPageSubtitle;

  /// Text shown when logging in
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get loginPageProvidersSeparatorText;

  /// Text shown when logging in with Google
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginPageContinueWithGoogleButtonText;

  /// Text shown when logging in with Apple
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get loginPageContinueWithAppleButtonText;

  /// Text shown when logging in
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginPageDontHaveAccountText;

  /// Text shown when signing up
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get loginPageSignUpButtonText;

  /// Label shown when logging in with email and password
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginWithEmailPasswordLoginFormEmailFieldLabel;

  /// Error text shown when logging in with email and password
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get loginWithEmailPasswordLoginFormEmailFieldErrorText;

  /// Label shown when logging in with email and password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginWithEmailPasswordLoginFormPasswordFieldLabel;

  /// Error text shown when logging in with email and password
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid password'**
  String get loginWithEmailPasswordLoginFormPasswordFieldErrorText;

  /// Text shown when logging in with email and password
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginWithEmailPasswordLoginFormLoginButtonText;

  /// Label shown when navigating to the overview page
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get bottomNavigationBarOverviewButtonLabel;

  /// Label shown when navigating to the transactions page
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get bottomNavigationBarTransactionsButtonLabel;

  /// Label shown when navigating to the wallets page
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get bottomNavigationBarWalletsButtonLabel;

  /// Label shown when navigating to the personal page
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get bottomNavigationBarPersonalButtonLabel;

  /// Title shown in with felicash text in onboarding page
  ///
  /// In en, this message translates to:
  /// **'With Felicash'**
  String get onboardingPageWithFelicashTitle;

  /// Subtitle shown in take control of your text in onboarding page
  ///
  /// In en, this message translates to:
  /// **'Take control of your'**
  String get onboardingPageTakeControlOfYourText;

  /// Subtitle shown in financial text in onboarding page
  ///
  /// In en, this message translates to:
  /// **'financial'**
  String get onboardingPageFinancialText;

  /// Subtitle shown in experience the text in onboarding page
  ///
  /// In en, this message translates to:
  /// **'Experience the'**
  String get onboardingPageExperienceTheText;

  /// Subtitle shown in AI text in onboarding page
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get onboardingPageAIText;

  /// Subtitle shown in assistant text in onboarding page
  ///
  /// In en, this message translates to:
  /// **'assistant'**
  String get onboardingPageAssistantText;

  /// Button label shown in get started button in onboarding page
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingPageGetStartedButtonLabel;

  /// Text shown in already have an account text in onboarding page
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get onboardingPageAlreadyHaveAccountText;

  /// Button label shown in login button in onboarding page
  ///
  /// In en, this message translates to:
  /// **'Login now'**
  String get onboardingPageLoginButtonLabel;

  /// Text shown in total balance in overview app bar
  ///
  /// In en, this message translates to:
  /// **'Total balance'**
  String get overviewAppBarTotalBalanceText;

  /// Label shown in overview tab bar in overview app bar
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewAppBarOverviewTabBarLabel;

  /// Label shown in income tab bar in overview app bar
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get overviewAppBarIncomeTabBarLabel;

  /// Label shown in expenses tab bar in overview app bar
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get overviewAppBarExpensesTabBarLabel;

  /// Title shown in spending by category section
  ///
  /// In en, this message translates to:
  /// **'No spending data available'**
  String get spendingByCategorySectionEmptyStateTitle;

  /// Subtitle shown in spending by category section
  ///
  /// In en, this message translates to:
  /// **'Add some transactions to see your spending by category'**
  String get spendingByCategorySectionEmptyStateSubtitle;

  /// Title shown in spending by category section
  ///
  /// In en, this message translates to:
  /// **'Spending by category'**
  String get spendingByCategorySectionTitle;

  /// Text shown in spending by category list when no category is selected
  ///
  /// In en, this message translates to:
  /// **'No Category'**
  String get spendingByCategoryListNoCategoryText;

  /// Text shown in spending by category pie chart when no categories are available
  ///
  /// In en, this message translates to:
  /// **'No categories'**
  String get spendingByCategoryPieChartEmptyCategoriesText;

  /// Title shown in summary trending section
  ///
  /// In en, this message translates to:
  /// **'Monthly Trending'**
  String get summaryTrendingSectionTitle;

  /// Label shown in summary trending section for expense type
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get summaryTrendingSectionExpenseTypeLabel;

  /// Label shown in summary trending section for income type
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get summaryTrendingSectionIncomeTypeLabel;

  /// Label shown in summary trending section for transfer type
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get summaryTrendingSectionTransferTypeLabel;

  /// Label shown in summary trending section for unknown type
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get summaryTrendingSectionUnknownTypeLabel;

  /// Text shown in summary trending section for total amount
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get summaryTrendingSectionTotalAmountText;

  /// Title shown in transaction creation modal
  ///
  /// In en, this message translates to:
  /// **'New Transaction'**
  String get transactionCreationModalTitle;

  /// Text shown in transaction creation modal for are you sure
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get transactionCreationModalAreYouSureText;

  /// Text shown in transaction creation modal for this action cannot be undone
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get transactionCreationModalThisActionCannotBeUndoneText;

  /// Text shown in transaction creation modal for cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get transactionCreationModalCancelButtonText;

  /// Text shown in transaction creation modal for yes button
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get transactionCreationModalYesButtonText;

  /// Text shown in transaction creation modal for add transaction button
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get transactionCreationModalAddTransactionButtonText;

  /// Text shown in add transaction menu button for receipt scanner button
  ///
  /// In en, this message translates to:
  /// **'Receipt Scanner'**
  String get addTransactionMenuButtonReceptScannerButtonText;

  /// Text shown in add transaction menu button for AI input button
  ///
  /// In en, this message translates to:
  /// **'AI Input'**
  String get addTransactionMenuButtonAIInputButtonText;

  /// Text shown in add transaction menu button for manual input button
  ///
  /// In en, this message translates to:
  /// **'Manual Input'**
  String get addTransactionMenuButtonManualInputButtonText;

  /// Label shown in transaction creation form for expense type
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get transactionCreationFormExpenseTypeLabel;

  /// Label shown in transaction creation form for income type
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get transactionCreationFormIncomeTypeLabel;

  /// Label shown in transaction creation form for transfer type
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transactionCreationFormTransferTypeLabel;

  /// Label shown in transaction creation form for unknown type
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get transactionCreationFormUnknownTypeLabel;

  /// Label shown in transaction creation form for transaction amount field
  ///
  /// In en, this message translates to:
  /// **'Transaction Amount'**
  String get transactionCreationFormTransactionAmountFieldLabel;

  /// Label shown in transaction creation form for category field
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get transactionCreationFormCategoryFieldLabel;

  /// Label shown in transaction creation form for date field
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get transactionCreationFormDateFieldLabel;

  /// Label shown in transaction creation form for notes field
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get transactionCreationFormNotesFieldLabel;

  /// Text shown in transaction creation form for type
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get transactionCreationFormTypeText;

  /// Hint text shown in transaction creation form for enter amount
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get transactionCreationFormEnterAmountHintText;

  /// Hint text shown in transaction creation form for enter date
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get transactionCreationFormEnterDateHintText;

  /// Hint text shown in transaction creation form for enter notes
  ///
  /// In en, this message translates to:
  /// **'Add notes'**
  String get transactionCreationFormEnterNotesHintText;

  /// No description provided for @transactionPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionPageTitle;

  /// No description provided for @transactionListSearchBarHintText.
  ///
  /// In en, this message translates to:
  /// **'Search transactions'**
  String get transactionListSearchBarHintText;

  /// Error message shown when failed to fetch transactions
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch transactions'**
  String get transactionListFailedToFetchTransactionsErrorMessage;

  /// Error message shown when no transactions are found
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get transactionListNoTransactionsFoundErrorMessage;

  /// Text shown when no transactions are found
  ///
  /// In en, this message translates to:
  /// **'Add a transaction to get started'**
  String get transactionListAddTransactionToGetStartedText;

  /// Title shown in transaction list all filters view
  ///
  /// In en, this message translates to:
  /// **'Transaction Filters'**
  String get transactionListAllFiltersViewTitle;

  /// Text shown in transaction list all filters view for clear all button
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get transactionListAllFiltersViewClearAllButtonText;

  /// Title shown in transaction list all filters view for categories filter
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get transactionListAllFiltersViewCategoriesFilterTitle;

  /// Title shown in transaction list all filters view for wallets filter
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get transactionListAllFiltersViewWalletsFilterTitle;

  /// Title shown in transaction list all filters view for transaction types filter
  ///
  /// In en, this message translates to:
  /// **'Transaction Types'**
  String get transactionListAllFiltersViewTransactionTypesFilterTitle;

  /// Title shown in transaction list all filters view for transaction date filter
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get transactionListAllFiltersViewTransactionDateFilterTitle;

  /// Text shown in transaction list all filters view for apply button
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get transactionListAllFiltersViewApplyButtonText;

  /// Error message shown when failed to fetch categories
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch categories'**
  String
      get transactionListCategoriesFilterViewFailedToFetchCategoriesErrorMessage;

  /// Title shown in transaction list categories filter view
  ///
  /// In en, this message translates to:
  /// **'Transaction Categories'**
  String get transactionListCategoriesFilterViewTitle;

  /// Hint text shown in transaction list categories filter view for search categories
  ///
  /// In en, this message translates to:
  /// **'Search categories'**
  String get transactionListCategoriesFilterViewSearchCategoriesHintText;

  /// Error message shown when no categories are found
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get transactionListCategoriesFilterViewNoCategoriesFoundErrorMessage;

  /// Text shown in transaction list categories filter view for cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get transactionListCategoriesFilterViewCancelButtonLabel;

  /// Title shown in transaction list date filter view
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get transactionListDateFilterViewTransactionDateAppBarTitle;

  /// Text shown in transaction list date filter view for select date button
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get transactionListDateFilterViewSelectDateButtonText;

  /// Text shown in transaction list date filter view for cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get transactionListDateFilterViewTodayCancelButtonText;

  /// Text shown in transaction list date filter view for apply button
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get transactionListDateFilterViewTodayApplyButtonText;

  /// Title shown in transaction list types filter view
  ///
  /// In en, this message translates to:
  /// **'Transaction Types'**
  String get transactionListTypesFilterViewTitle;

  /// Error message shown when no types are found
  ///
  /// In en, this message translates to:
  /// **'No types found'**
  String get transactionListTypesFilterViewNoTypesFoundErrorMessage;

  /// Text shown in transaction list types filter view for cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get transactionListTypesFilterViewCancelButtonLabel;

  /// Label shown in transaction list types filter view for expense type
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get transactionListTypesFilterViewExpenseTypeLabel;

  /// Label shown in transaction list types filter view for income type
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get transactionListTypesFilterViewIncomeTypeLabel;

  /// Label shown in transaction list types filter view for transfer type
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transactionListTypesFilterViewTransferTypeLabel;

  /// Label shown in transaction list types filter view for unknown type
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get transactionListTypesFilterViewUnknownTypeLabel;

  /// Title shown in transaction list wallets filter view
  ///
  /// In en, this message translates to:
  /// **'Transaction Wallets'**
  String get transactionListWalletsFilterViewTitle;

  /// Hint text shown in transaction list wallets filter view for search wallets
  ///
  /// In en, this message translates to:
  /// **'Search wallets'**
  String get transactionListWalletsFilterViewSearchWalletsHintText;

  /// Error message shown when failed to load wallets
  ///
  /// In en, this message translates to:
  /// **'Failed to load wallets'**
  String get transactionListWalletsFilterViewFailedToLoadWalletsErrorMessage;

  /// Error message shown when no wallets are found
  ///
  /// In en, this message translates to:
  /// **'No wallets found'**
  String get transactionListWalletsFilterViewNoWalletsFoundErrorMessage;

  /// Text shown in transaction list wallets filter view for cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get transactionListWalletsFilterViewCancelButtonLabel;

  /// Error message shown when no source wallet is found
  ///
  /// In en, this message translates to:
  /// **'No source wallet found'**
  String get voiceTransactionPageNoSourceWalletFoundErrorMessage;

  /// Text shown in transaction on processing view for edit transaction button
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get transactionOnProcessingViewEditTransactionButtonLabel;

  /// Text shown in transaction on processing view for create next transaction
  ///
  /// In en, this message translates to:
  /// **'Edit or keep talking to create next transaction'**
  String get transactionOnProcessingViewCreateNextTransactionText;

  /// Title shown in voice transaction on hold view
  ///
  /// In en, this message translates to:
  /// **'On Hold'**
  String get voiceTransactionOnHoldViewOnHoldTitle;

  /// Subtitle shown in voice transaction on hold view
  ///
  /// In en, this message translates to:
  /// **'To turn the mic on and continue, tap the play button.'**
  String get voiceTransactionOnHoldViewOnHoldSubtitle;

  /// Text shown in wallet selector for balance
  ///
  /// In en, this message translates to:
  /// **'Balance {balance}'**
  String walletSelectorBalanceText(String balance);

  /// Title shown in wallet page for wallets app bar
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get walletPageWalletsAppBarTitle;

  /// Label shown in wallet page for basic wallet type
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get walletPageBasicWalletTypeLabel;

  /// Label shown in wallet page for credit wallet type
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get walletPageCreditWalletTypeLabel;

  /// Label shown in wallet page for savings wallet type
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get walletPageSavingsWalletTypeLabel;

  /// Text shown in wallet card for current balance
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get walletCardCurrentBalanceText;

  /// Label shown in wallet creation modal for basic wallet type
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get walletCreationModalBasicWalletTypeLabel;

  /// Label shown in wallet creation modal for credit wallet type
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get walletCreationModalCreditWalletTypeLabel;

  /// Label shown in wallet creation modal for savings wallet type
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get walletCreationModalSavingsWalletTypeLabel;

  /// Text shown in wallet creation modal for wallet created successfully
  ///
  /// In en, this message translates to:
  /// **'Wallet created successfully'**
  String get walletCreationModalWalletCreatedSuccessfullyText;

  /// Text shown in wallet creation modal for are you sure
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get walletCreationModalAreYouSureText;

  /// Text shown in wallet creation modal for this action cannot be undone
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get walletCreationModalThisActionCannotBeUndoneText;

  /// Text shown in wallet creation modal for cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get walletCreationModalCancelButtonText;

  /// Text shown in wallet creation modal for yes button
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get walletCreationModalYesButtonText;

  /// Text shown in wallet creation modal for create with wallet type
  ///
  /// In en, this message translates to:
  /// **'Create {walletName} wallet'**
  String walletCreationModalCreateWithWalletTypeText(String walletName);

  /// Text shown in wallet creation modal for create wallet button
  ///
  /// In en, this message translates to:
  /// **'Create Wallet'**
  String get walletCreationModalCreateWalletButtonText;

  /// Title shown in wallet type selector modal
  ///
  /// In en, this message translates to:
  /// **'Select wallet type'**
  String get walletTypeSelectorModalTitle;

  /// Label shown in wallet type selector modal for basic wallet type
  ///
  /// In en, this message translates to:
  /// **'Basic wallet'**
  String get walletTypeSelectorModalBasicWalletTypeLabel;

  /// Subtitle shown in wallet type selector modal for basic wallet type
  ///
  /// In en, this message translates to:
  /// **'The wallet for your daily spending and payments.'**
  String get walletTypeSelectorModalBasicWalletTypeSubtitle;

  /// Label shown in wallet type selector modal for credit wallet type
  ///
  /// In en, this message translates to:
  /// **'Credit wallet'**
  String get walletTypeSelectorModalCreditWalletTypeLabel;

  /// Subtitle shown in wallet type selector modal for credit wallet type
  ///
  /// In en, this message translates to:
  /// **'The wallet for your credit card and other credit needs.'**
  String get walletTypeSelectorModalCreditWalletTypeSubtitle;

  /// Label shown in wallet type selector modal for savings wallet type
  ///
  /// In en, this message translates to:
  /// **'Savings wallet'**
  String get walletTypeSelectorModalSavingsWalletTypeLabel;

  /// Subtitle shown in wallet type selector modal for savings wallet type
  ///
  /// In en, this message translates to:
  /// **'The wallet for your savings and investments.'**
  String get walletTypeSelectorModalSavingsWalletTypeSubtitle;

  /// Label shown in wallet creation form for wallet name field
  ///
  /// In en, this message translates to:
  /// **'Wallet name'**
  String get walletCreationFormWalletNameFieldLabel;

  /// Label shown in wallet creation form for wallet description field
  ///
  /// In en, this message translates to:
  /// **'Wallet description'**
  String get walletCreationFormWalletDescriptionFieldLabel;

  /// Label shown in wallet creation form for wallet currency field
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get walletCreationFormWalletCurrencyFieldLabel;

  /// Label shown in wallet creation form for wallet balance field
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get walletCreationFormWalletBalanceFieldLabel;

  /// Label shown in wallet creation form for wallet credit limit field
  ///
  /// In en, this message translates to:
  /// **'Credit limit'**
  String get walletCreationFormWalletCreditLimitFieldLabel;

  /// Label shown in wallet creation form for wallet savings goal field
  ///
  /// In en, this message translates to:
  /// **'Savings goal'**
  String get walletCreationFormWalletSavingsGoalFieldLabel;

  /// Text shown in wallet creation form for wallet pick an icon
  ///
  /// In en, this message translates to:
  /// **'Pick an icon'**
  String get walletCreationFormWalletPickAnIconText;

  /// Error message shown in wallet creation form for wallet name is required
  ///
  /// In en, this message translates to:
  /// **'Wallet name is required'**
  String get walletCreationFormWalletWalletNameIsRequiredErrorMessage;

  /// Error message shown in wallet creation form for wallet name is too long
  ///
  /// In en, this message translates to:
  /// **'Wallet name is too long'**
  String get walletCreationFormWalletWalletNameIsTooLongErrorMessage;

  /// Hint text shown in wallet creation form for wallet name field
  ///
  /// In en, this message translates to:
  /// **'Name your wallet'**
  String get walletCreationFormWalletNameFieldHintText;

  /// Error message shown in wallet creation form for wallet description is too long
  ///
  /// In en, this message translates to:
  /// **'Description is too long'**
  String get walletCreationFormWalletDescriptionIsTooLongErrorMessage;

  /// Hint text shown in wallet creation form for wallet description field
  ///
  /// In en, this message translates to:
  /// **'Describe your wallet for easier identification'**
  String get walletCreationFormWalletDescriptionFieldHintText;

  /// Error message shown in wallet creation form for wallet balance must be less than max
  ///
  /// In en, this message translates to:
  /// **'Balance must be less than \${maxAcceptedBalance}'**
  String walletCreationFormWalletBalanceMustBeLessThanMaxErrorMessage(
      double maxAcceptedBalance);

  /// Error message shown in wallet creation form for wallet balance must be greater than min
  ///
  /// In en, this message translates to:
  /// **'Balance must be greater than \${minAcceptedBalance}'**
  String walletCreationFormWalletBalanceMustBeGreaterThanMinErrorMessage(
      double minAcceptedBalance);

  /// Hint text shown in wallet creation form for wallet balance field
  ///
  /// In en, this message translates to:
  /// **'Set the current balance'**
  String get walletCreationFormWalletBalanceFieldHintText;

  /// Label shown in wallet creation form for wallet exclude from total checkbox
  ///
  /// In en, this message translates to:
  /// **'Exclude from total'**
  String get walletCreationFormWalletExcludeFromTotalCheckboxLabel;

  /// Error message shown in wallet creation form for wallet credit limit must be less than max
  ///
  /// In en, this message translates to:
  /// **'Credit limit must be less than \${maxAcceptedCreditLimit}'**
  String walletCreationFormCreditLimitMustBeLessThanMaxErrorMessage(
      double maxAcceptedCreditLimit);

  /// Error message shown in wallet creation form for wallet credit limit must be greater than min
  ///
  /// In en, this message translates to:
  /// **'Credit limit must be greater than \${minAcceptedCreditLimit}'**
  String walletCreationFormCreditLimitMustBeGreaterThanMinErrorMessage(
      double minAcceptedCreditLimit);

  /// Error message shown in wallet creation form for wallet credit limit must be greater than zero
  ///
  /// In en, this message translates to:
  /// **'Credit limit must be greater than 0'**
  String get walletCreationFormCreditLimitMustBeGreaterThanZeroErrorMessage;

  /// Hint text shown in wallet creation form for wallet credit limit field
  ///
  /// In en, this message translates to:
  /// **'Set the credit limit'**
  String get walletCreationFormCreditLimitFieldHintText;

  /// Text shown in wallet creation form for wallet credit wallet day of month
  ///
  /// In en, this message translates to:
  /// **'Day of month'**
  String get walletCreationFormCreditWalletDayOfMonthText;

  /// Text shown in wallet creation form for wallet credit wallet payment day of month
  ///
  /// In en, this message translates to:
  /// **'Payment day of month'**
  String get walletCreationFormCreditWalletPaymentDayOfMonthText;

  /// Error message shown in wallet creation form for wallet savings goal must be greater than zero
  ///
  /// In en, this message translates to:
  /// **'Savings goal must be greater than 0'**
  String get walletCreationFormSavingsGoalMustBeGreaterThanZeroErrorMessage;

  /// Error message shown in wallet creation form for wallet savings goal must be less than max
  ///
  /// In en, this message translates to:
  /// **'Savings goal must be less than \${maxAcceptedSavingsGoal}'**
  String walletCreationFormSavingsGoalMustBeLessThanMaxErrorMessage(
      double maxAcceptedSavingsGoal);

  /// Error message shown in wallet creation form for wallet savings goal must be greater than min
  ///
  /// In en, this message translates to:
  /// **'Savings goal must be greater than \${minAcceptedSavingsGoal}'**
  String walletCreationFormSavingsGoalMustBeGreaterThanMinErrorMessage(
      double minAcceptedSavingsGoal);

  /// Hint text shown in wallet creation form for wallet savings goal field
  ///
  /// In en, this message translates to:
  /// **'Set the savings goal'**
  String get walletCreationFormSavingsGoalFieldHintText;

  /// Title shown in personal page app bar
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personalPageAppBarTitle;

  /// Text shown in personal page for logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get personalPageLogoutButtonLabel;

  /// Hint text shown in wallet selector modal for search wallets
  ///
  /// In en, this message translates to:
  /// **'Search wallets'**
  String get walletSelectorModalSearchWalletsHintText;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
