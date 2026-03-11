/// {@template token_storage}
/// Token storage interface. Provides methods to save, retrieve, and delete
/// {@endtemplate}
abstract interface class TokenStorage {
  /// Saves the token.
  Future<void> saveToken(String token);

  /// Retrieves the token.
  Future<String?> getToken();

  /// Deletes the token.
  Future<void> clearToken();
}
