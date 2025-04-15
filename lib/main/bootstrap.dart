import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:felicash_data_client/felicash_data_client.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef AppBuilder = FutureOr<Widget> Function(
  FelicashDataClient dataClient,
);

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(AppBuilder builder) async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final supabase = await Supabase.initialize(
      url: const String.fromEnvironment('SUPABASE_URL'),
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
    );

    final dataClient = await FelicashDataClient.create(
      dbName: const String.fromEnvironment('FELICASH_LOCAL_DB_NAME'),
      endpoint: const String.fromEnvironment('POWERSYNC_URL'),
      supabaseClient: supabase.client,
    );

    FlutterError.onError = (details) {
      log(details.exceptionAsString(), stackTrace: details.stack);
    };

    Bloc.observer = const AppBlocObserver();

    // Add cross-flavor configuration here

    runApp(await builder(dataClient));
  }, (error, stackTrace) {
    log(
      error.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  });
}
