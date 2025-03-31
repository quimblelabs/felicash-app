import 'package:brick_offline_first_with_rest/offline_queue.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:felicash_data_client/src/enums/wallet_type.enum.dart';
import 'package:felicash_data_client/src/models/credit_wallet.model.dart';
import 'package:felicash_data_client/src/models/profile.model.dart';
import 'package:felicash_data_client/src/models/wallet.model.dart';
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
  late CreditWallet testWallet;
  CreditWallet? savedWallet;

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

    testWallet = CreditWallet(
      wallet: Wallet(
        profile: Profile(id: KeyForTest.TEST_USER_ID),
        walletType: WalletType.credit,
        name: 'Ví tín dụng',
        description: 'Ví tín dụng của tôi',
        baseCurrency: 'VND',
        balance: 1000000,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      creditLimit: 500000,
      paymentDueDayOfMonth: 28,
      stateDayOfMonth: 21,
    );
  });

  group('CreditWallet CRUD operations', () {
    test('Create credit wallet', () async {
      savedWallet = await dataClient.upsert<CreditWallet>(testWallet);
      expect(savedWallet, isNotNull);
    });

    test('Read credit wallet', () async {
      final wallet = await dataClient.get<CreditWallet>(
        query: Query(
          action: QueryAction.get,
          where: [Where('walletId', value: savedWallet!.walletId)],
        ),
      );
      expect(wallet, isNotNull);
    });

    test('Update credit wallet', () async {
      final wallet = CreditWallet(
        wallet: savedWallet!.wallet,
        creditLimit: 1000000,
        paymentDueDayOfMonth: 29,
        stateDayOfMonth: 21,
      );
      final updatedWallet = await dataClient.upsert<CreditWallet>(
        wallet,
        query: Query(where: [Where('walletId', value: savedWallet!.walletId)]),
      );
      final wallets2 = await dataClient.get<CreditWallet>(
        query: Query(where: [Where('walletId', value: updatedWallet.walletId)]),
      );
      expect(wallets2.length, 1);
      expect(wallets2.first.creditLimit, 1000000);
      expect(wallets2.first.paymentDueDayOfMonth, 29);
    });

    test('Delete credit wallet', () async {
      final result = await dataClient.delete<Wallet>(
        savedWallet!.wallet,
        query: Query(where: [Where('id', value: savedWallet!.walletId)]),
      );
      expect(result, true);
    });
  });
}
