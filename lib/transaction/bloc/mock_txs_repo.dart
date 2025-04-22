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

        final randomExpenseNote =
            expenseNotesSeed[random.nextInt(expenseNotesSeed.length)];
        final randomCategoryName =
            categoryNameSeed[random.nextInt(categoryNameSeed.length)];
        final randomAmount = (random.nextDouble() * 1000).roundToDouble();

        _allTransactions.add(
          TransactionModel(
            id: const Uuid().v4(),
            wallet: BasicWalletModel.empty, // Mocked for simplicity
            category: CategoryModel.empty.copyWith(
              name: randomCategoryName,
            ), // Mocked for simplicity
            transactionType: TransactionTypeEnum.expense,
            amount: randomAmount,
            notes: randomExpenseNote,
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
    final random = DateTime.now().millisecondsSinceEpoch % 1000;
    final randomExpenseNote =
        expenseNotesSeed[random % expenseNotesSeed.length];
    final randomCategoryName =
        categoryNameSeed[random % categoryNameSeed.length];
    final newTransaction = TransactionModel(
      id: const Uuid().v4(),
      wallet: BasicWalletModel.empty, // Mocked for simplicity
      category: CategoryModel.empty.copyWith(
        name: randomCategoryName,
      ), // Mocked for simplicity
      transactionType: TransactionTypeEnum.expense,
      amount: amount,
      notes: randomExpenseNote,
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
