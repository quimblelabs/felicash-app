import 'dart:async';
import 'dart:math';

import 'package:category_repository/category_repository.dart';
import 'package:shared_models/shared_models.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:wallet_repository/wallet_repository.dart';

class MockTransactionRepository {
  MockTransactionRepository() {
    // Generate mock data (random 1-5 transactions per day for last 100 days)
    final now = DateTime.now();
    final random = Random();

    // Create mock wallets
    final wallets = [
      BasicWalletModel.empty.copyWith(
        id: const Uuid().v4(),
        name: 'Cash',
        balance: 1000,
      ),
      BasicWalletModel.empty.copyWith(
        id: const Uuid().v4(),
        name: 'Bank Account',
        balance: 5000,
      ),
      BasicWalletModel.empty.copyWith(
        id: const Uuid().v4(),
        name: 'Credit Card',
        balance: -500,
      ),
    ];

    for (int day = 0; day < 100; day++) {
      final currentDate = now.subtract(Duration(days: day));
      // Generate 1-5 random transactions for this day
      final transactionsCount = random.nextInt(5) + 1;

      for (int i = 0; i < transactionsCount; i++) {
        final expenseNotesSeed = [
          'Groceries',
          'Dining out',
          'Shopping',
          'Transportation',
          'Entertainment',
          'Utilities',
          'Healthcare',
          'Education',
        ];
        final incomeNotesSeed = [
          'Salary',
          'Freelance work',
          'Investment returns',
          'Gift',
          'Refund',
          'Side hustle',
          'Bonus',
          'Rental income',
        ];
        final transferNotesSeed = [
          'Transfer to savings',
          'Transfer to checking',
          'Transfer to investment',
          'Transfer to emergency fund',
          'Transfer to travel fund',
          'Transfer to education fund',
          'Transfer to retirement',
          'Transfer to other account',
        ];
        final categoryNameSeed = [
          'Food',
          'Transportation',
          'Entertainment',
          'Bills',
          'Shopping',
          'Healthcare',
          'Education',
          'Miscellaneous',
        ];

        // Randomly select transaction type
        final transactionType = TransactionTypeEnum
            .values[random.nextInt(TransactionTypeEnum.values.length)];

        // Select appropriate notes based on transaction type
        String randomNote;
        switch (transactionType) {
          case TransactionTypeEnum.expense:
            randomNote =
                expenseNotesSeed[random.nextInt(expenseNotesSeed.length)];
            break;
          case TransactionTypeEnum.income:
            randomNote =
                incomeNotesSeed[random.nextInt(incomeNotesSeed.length)];
            break;
          case TransactionTypeEnum.transfer:
            randomNote =
                transferNotesSeed[random.nextInt(transferNotesSeed.length)];
            break;
          case TransactionTypeEnum.unknown:
            randomNote = 'Unknown transaction';
            break;
        }

        final randomCategoryName =
            categoryNameSeed[random.nextInt(categoryNameSeed.length)];
        double randomAmount;
        switch (transactionType) {
          case TransactionTypeEnum.expense:
            randomAmount = -(random.nextDouble() * 1000)
                .roundToDouble(); // Negative for expenses
          case TransactionTypeEnum.income:
            randomAmount = (random.nextDouble() * 1000)
                .roundToDouble(); // Positive for income
          case TransactionTypeEnum.transfer:
            // For transfers, randomly decide if it's positive or negative
            randomAmount = (random.nextBool() ? 1 : -1) *
                (random.nextDouble() * 1000).roundToDouble();
          case TransactionTypeEnum.unknown:
            randomAmount = (random.nextDouble() * 1000).roundToDouble();
        }

        // Randomly select a wallet
        final randomWallet = wallets[random.nextInt(wallets.length)];

        _allTransactions.add(
          TransactionModel(
            id: const Uuid().v4(),
            wallet: randomWallet,
            category: CategoryModel.empty.copyWith(
              name: randomCategoryName,
            ), // Mocked for simplicity
            transactionType: transactionType,
            amount: randomAmount,
            notes: randomNote,
            transactionDate: currentDate,
            createdAt: currentDate,
            updatedAt: currentDate,
          ),
        );
      }
    }

    // Sort transactions by date in descending order
    _allTransactions
        .sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
  }
  static const int pageSize = 20;

  final List<TransactionModel> _allTransactions = [];
  final Map<int, StreamController<List<TransactionModel>>> _pageControllers =
      {};

  /// Simulate a paginated query with reactive updates per page
  Stream<List<TransactionModel>> fetchPage({
    required int pageIndex,
    DateTime? before,
  }) {
    // Page index helps us uniquely ID the stream
    _pageControllers[pageIndex]?.close(); // clean up if already exists
    final controller = StreamController<List<TransactionModel>>.broadcast();
    _pageControllers[pageIndex] = controller;

    // Get the slice
    List<TransactionModel> pageItems;
    if (before != null) {
      pageItems = _allTransactions
          .where((transaction) => transaction.transactionDate.isBefore(before))
          .take(pageSize)
          .toList();
    } else {
      pageItems = _allTransactions.take(pageSize).toList();
    }

    // Emit initial
    Future.delayed(Duration.zero, () {
      controller.add(List.from(pageItems));
    });

    return controller.stream;
  }

  /// Simulate insert at the top (new transaction)
  void addTransaction(double amount, DateTime transactionDate) {
    final expenseNotesSeed = [
      'Groceries',
      'Dining out',
      'Shopping',
      'Transportation',
      'Entertainment',
      'Utilities',
      'Healthcare',
      'Education',
    ];
    final incomeNotesSeed = [
      'Salary',
      'Freelance work',
      'Investment returns',
      'Gift',
      'Refund',
      'Side hustle',
      'Bonus',
      'Rental income',
    ];
    final transferNotesSeed = [
      'Transfer to savings',
      'Transfer to checking',
      'Transfer to investment',
      'Transfer to emergency fund',
      'Transfer to travel fund',
      'Transfer to education fund',
      'Transfer to retirement',
      'Transfer to other account',
    ];
    final categoryNameSeed = [
      'Food',
      'Transportation',
      'Entertainment',
      'Bills',
      'Shopping',
      'Healthcare',
      'Education',
      'Miscellaneous',
    ];

    // Create mock wallets
    final wallets = [
      BasicWalletModel.empty.copyWith(
        id: const Uuid().v4(),
        name: 'Cash',
        balance: 1000,
      ),
      BasicWalletModel.empty.copyWith(
        id: const Uuid().v4(),
        name: 'Bank Account',
        balance: 5000,
      ),
      BasicWalletModel.empty.copyWith(
        id: const Uuid().v4(),
        name: 'Credit Card',
        balance: -500,
      ),
    ];

    final random = DateTime.now().millisecondsSinceEpoch % 1000;

    // Randomly select transaction type
    final transactionType =
        TransactionTypeEnum.values[random % TransactionTypeEnum.values.length];

    // Select appropriate notes based on transaction type
    String randomNote;
    switch (transactionType) {
      case TransactionTypeEnum.expense:
        randomNote = expenseNotesSeed[random % expenseNotesSeed.length];
        break;
      case TransactionTypeEnum.income:
        randomNote = incomeNotesSeed[random % incomeNotesSeed.length];
        break;
      case TransactionTypeEnum.transfer:
        randomNote = transferNotesSeed[random % transferNotesSeed.length];
        break;
      case TransactionTypeEnum.unknown:
        randomNote = 'Unknown transaction';
        break;
    }

    final randomCategoryName =
        categoryNameSeed[random % categoryNameSeed.length];
    double finalAmount;
    switch (transactionType) {
      case TransactionTypeEnum.expense:
        finalAmount = -amount; // Negative for expenses
        break;
      case TransactionTypeEnum.income:
        finalAmount = amount; // Positive for income
        break;
      case TransactionTypeEnum.transfer:
        // For transfers, randomly decide if it's positive or negative
        finalAmount = (random % 2 == 0 ? 1 : -1) * amount;
        break;
      case TransactionTypeEnum.unknown:
        finalAmount = amount;
        break;
    }

    // Randomly select a wallet
    final randomWallet = wallets[random % wallets.length];

    final newTransaction = TransactionModel(
      id: const Uuid().v4(),
      wallet: randomWallet,
      category: CategoryModel.empty.copyWith(
        name: randomCategoryName,
      ), // Mocked for simplicity
      transactionType: transactionType,
      amount: finalAmount,
      notes: randomNote,
      transactionDate: transactionDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _allTransactions.insert(0, newTransaction);
    _refreshAllPages();
  }

  /// Simulate editing a transaction by ID
  void updateTransaction(String id, double newAmount, DateTime newDate) {
    final index =
        _allTransactions.indexWhere((transaction) => transaction.id == id);
    if (index != -1) {
      _allTransactions[index] = _allTransactions[index].copyWith(
        amount: newAmount,
        transactionDate: newDate,
        updatedAt: DateTime.now(),
      );
      _refreshAllPages();
    }
  }

  /// Simulate deletion
  void deleteTransaction(String id) {
    _allTransactions.removeWhere((transaction) => transaction.id == id);
    _refreshAllPages();
  }

  void _refreshAllPages() {
    for (final entry in _pageControllers.entries) {
      final pageIndex = entry.key;
      final controller = entry.value;

      final start = pageIndex * pageSize;
      final end = start + pageSize;
      final pageItems = _allTransactions.skip(start).take(pageSize).toList();

      controller.add(List.from(pageItems));
    }
  }

  void dispose() {
    for (final c in _pageControllers.values) {
      c.close();
    }
  }
}
