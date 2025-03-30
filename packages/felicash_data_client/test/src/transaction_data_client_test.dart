import 'package:brick_offline_first_with_rest/offline_queue.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:felicash_data_client/src/enums/transaction_type.enum.dart';
import 'package:felicash_data_client/src/enums/wallet_type.enum.dart';
import 'package:felicash_data_client/src/models/category.model.dart';
import 'package:felicash_data_client/src/models/profile.model.dart';
import 'package:felicash_data_client/src/models/transaction.model.dart';
import 'package:felicash_data_client/src/models/wallet.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:felicash_data_client/src/models/transaction.model.dart'
    as model;

import '_keys.dart';
import 'mock_shared_preferences_plugin.dart';

void main() {
  late RestOfflineQueueClient client;
  late RestOfflineRequestQueue queue;
  late FelicashDataClient dataClient;
  late SupabaseClient supabaseClient;

  // Test data holders
  late Wallet wallet;
  late Category category;
  late model.Transaction testTransaction;
  model.Transaction? savedTransaction;

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferencesStorePlatform.instance = MockSharedPreferencesPlugin();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactory,
      ignorePaths: {'/auth/v1', '/storage/v1', '/functions/v1'},
    );

    final supabase = await Supabase.initialize(
      url: KeyForTest.SUPABASE_URL,
      anonKey: KeyForTest.SUPABASE_ANON_KEY,
      httpClient: client,
    );

    supabaseClient = supabase.client;
    dataClient = FelicashDataClient(
      supabaseClient: supabaseClient,
      queue: queue,
      dbName: 'test_felicash.sqlite',
    );

    await dataClient.reset();
    await dataClient.initialize();

    // Create necessary test data
    wallet = await _createTestWallet(dataClient, KeyForTest.TEST_USER_ID);
    category = await _createTestCategory(dataClient, KeyForTest.TEST_USER_ID);

    testTransaction = model.Transaction(
      profile: Profile(id: KeyForTest.TEST_USER_ID),
      wallet: wallet,
      category: category,
      transactionType: TransactionType.expense,
      amount: 100000,
      transactionDate: DateTime.now(),
      notes: 'Test transaction',
      imageAttachment: 'test_image.jpg',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  });

  tearDownAll(() async {
    await _deleteTestData(dataClient, wallet, category);
    await dataClient.reset();
  });

  group('Transaction CRUD operations', () {
    test('Create transaction', () async {
      savedTransaction = await dataClient.upsert<model.Transaction>(
        testTransaction,
      );
      expect(savedTransaction, isNotNull);
      expect(savedTransaction!.userId, equals(KeyForTest.TEST_USER_ID));
      expect(savedTransaction!.amount, equals(100000));
    });

    test('Read transaction', () async {
      final transaction = await dataClient.get<model.Transaction>(
        query: Query.where('id', savedTransaction!.id),
      );
      expect(transaction, isNotNull);
      expect(transaction.length, 1);
      expect(transaction.first.id, equals(savedTransaction!.id));
    });

    test('Update transaction', () async {
      final updatedTransaction = model.Transaction(
        id: savedTransaction!.id,
        profile: savedTransaction!.profile,
        wallet: savedTransaction!.wallet,
        category: savedTransaction!.category,
        transactionType: TransactionType.income,
        amount: 200000,
        transactionDate: savedTransaction!.transactionDate,
        notes: 'Updated test transaction',
        imageAttachment: 'updated_test_image.jpg',
        createdAt: savedTransaction!.createdAt,
        updatedAt: DateTime.now(),
      );

      final result = await dataClient.upsert<model.Transaction>(
        updatedTransaction,
      );
      expect(result.amount, equals(200000));
      expect(result.notes, equals('Updated test transaction'));
    });

    test('Delete transaction', () async {
      final result = await dataClient.delete<model.Transaction>(
        savedTransaction!,
        query: Query.where('id', savedTransaction!.id),
      );
      expect(result, true);

      final transactions = await dataClient.get<model.Transaction>(
        query: Query.where('id', savedTransaction!.id),
      );
      expect(transactions.isEmpty, true);
    });
  });
}

Future<Wallet> _createTestWallet(
  FelicashDataClient client,
  String userId,
) async {
  final wallet = Wallet(
    profile: Profile(id: KeyForTest.TEST_USER_ID),
    walletType: WalletType.basic,
    name: 'Ví tiền mặt',
    description: 'Ví tiền mặt của tôi',
    baseCurrency: 'VND',
    balance: 1000000,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  final result = await client.upsert<Wallet>(wallet);
  return result;
}

Future<Category> _createTestCategory(
  FelicashDataClient client,
  String userId,
) async {
  final category = Category(
    profile: Profile(id: KeyForTest.TEST_USER_ID),
    transactionType: TransactionType.expense,
    name: 'Ăn uống',
    enabled: true,
    icon: '🍔',
    color: '#FF5733',
    description: 'Chi tiêu cho ăn uống',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  final result = await client.upsert<Category>(category);
  return result;
}

Future<void> _deleteTestData(
  FelicashDataClient client,
  Wallet wallet,
  Category category,
) async {
  final result = await client.delete<Wallet>(wallet);
  expect(result, true);

  final result2 = await client.delete<Category>(category);
  expect(result2, true);
}
