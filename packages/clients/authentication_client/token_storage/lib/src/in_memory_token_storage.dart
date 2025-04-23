import 'package:token_storage/token_storage.dart';

/// {@template in_memory_token_storage}
/// In-memory token storage implementation. Saves the token in memory.
/// {@endtemplate}
class InMemoryTokenStorage implements TokenStorage {
  /// {@macro in_memory_token_storage}
  InMemoryTokenStorage();
  String? _token;
  @override
  Future<void> clearToken() async => _token = null;

  @override
  Future<String?> getToken() {
    return Future.value(_token);
  }

  @override
  Future<void> saveToken(String token) {
    _token = token;
    return Future.value();
  }
}
