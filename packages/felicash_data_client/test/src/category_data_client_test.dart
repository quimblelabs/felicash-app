import 'package:brick_offline_first_with_rest/offline_queue.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:felicash_data_client/src/enums/transaction_type.enum.dart';
import 'package:felicash_data_client/src/models/category.model.dart';
import 'package:felicash_data_client/src/models/profile.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactory, databaseFactoryFfi, sqfliteFfiInit;
import 'package:supabase_flutter/supabase_flutter.dart';

import '_keys.dart';
import 'mock_shared_preferences_plugin.dart';

void main() {
  late RestOfflineQueueClient client;
  late RestOfflineRequestQueue queue;
  late FelicashDataClient dataClient;
  late SupabaseClient supabaseClient;
  late Category testCategory;
  Category? savedCategory;

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Register the mock shared preferences plugin
    SharedPreferencesStorePlatform.instance = MockSharedPreferencesPlugin();

    // Initialize FFI
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;

    (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactory,
      ignorePaths: {'/auth/v1', '/storage/v1', '/functions/v1'},
    );

    const url = KeyForTest.SUPABASE_URL;
    const anonKey = KeyForTest.SUPABASE_ANON_KEY;

    final supabase = await Supabase.initialize(
      url: url,
      anonKey: anonKey,
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

    testCategory = Category(
      profile: Profile(id: KeyForTest.TEST_USER_ID),
      transactionType: TransactionType.expense,
      name: 'Food & Beverage',
      enabled: true,
      icon: '🍔',
      color: '#FF5733',
      description: 'Expenses for food and drinks',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  });

  group('Category CRUD operations', () {
    test('Create category', () async {
      savedCategory = await dataClient.upsert<Category>(testCategory);
      expect(savedCategory, isNotNull);
      expect(savedCategory?.name, 'Food & Beverage');
      expect(savedCategory?.transactionType, TransactionType.expense);
    });

    test('Read category', () async {
      final category = await dataClient.get<Category>(
        query: Query(
          action: QueryAction.get,
          where: [Where('id', value: savedCategory!.id)],
        ),
      );
      expect(category, isNotNull);
      expect(category.length, 1);
      expect(category.first.name, 'Food & Beverage');
    });

    test('Update category', () async {
      final updatedCategory = Category(
        profile: Profile(id: KeyForTest.TEST_USER_ID),
        id: savedCategory!.id,
        transactionType: TransactionType.expense,
        name: 'Dining Out',
        enabled: true,
        icon: '🍽️',
        color: savedCategory!.color,
        description: 'Restaurant expenses only',
        createdAt: savedCategory!.createdAt,
        updatedAt: DateTime.now(),
      );

      final result = await dataClient.upsert<Category>(
        updatedCategory,
        query: Query(where: [Where('id', value: savedCategory!.id)]),
      );

      final categories = await dataClient.get<Category>(
        query: Query(where: [Where('id', value: result.id)]),
      );

      expect(categories.length, 1);
      expect(categories.first.name, 'Dining Out');
      expect(categories.first.description, 'Restaurant expenses only');
    });

    test('Delete category', () async {
      final result = await dataClient.delete<Category>(
        savedCategory!,
        query: Query(where: [Where('id', value: savedCategory!.id)]),
      );
      expect(result, true);

      final categories = await dataClient.get<Category>(
        query: Query(where: [Where('id', value: savedCategory!.id)]),
      );
      expect(categories.isEmpty, true);
    });
  });

  group('Specific Case', () {
    test(
      'Create category with transaction type 2 word or more and then delete it',
      () async {
        final category = Category(
          profile: Profile(id: KeyForTest.TEST_USER_ID),
          transactionType: TransactionType.debtCollecting,
          name: 'Debt Collection',
          enabled: true,
          icon: '💰',
          color: '#4CAF50',
          description: 'Track money others owe you',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Create the category
        final savedCategory = await dataClient.upsert<Category>(category);
        expect(savedCategory, isNotNull);
        expect(savedCategory.transactionType, TransactionType.debtCollecting);
        expect(savedCategory.name, 'Debt Collection');

        // Verify the category was saved correctly
        final fetchedCategories = await dataClient.get<Category>(
          query: Query(
            action: QueryAction.get,
            where: [Where('id', value: savedCategory.id)],
          ),
        );
        expect(fetchedCategories.length, 1);
        expect(
          fetchedCategories.first.transactionType,
          TransactionType.debtCollecting,
        );

        // Delete the category
        final deleteResult = await dataClient.delete<Category>(
          savedCategory,
          query: Query(where: [Where('id', value: savedCategory.id)]),
        );
        expect(deleteResult, true);

        // Verify the category was deleted
        final deletedCategories = await dataClient.get<Category>(
          query: Query(where: [Where('id', value: savedCategory.id)]),
        );
        expect(deletedCategories.isEmpty, true);
      },
    );
  });
}
