import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as path_package;
import 'package:supabase_flutter/supabase_flutter.dart';

/// {@template storage_client_exception}
/// Base failure class for storage client.
/// {@endtemplate}
abstract class FelicashStorageClientException
    with EquatableMixin
    implements Exception {
  /// {@macro storage_client_exception}
  const FelicashStorageClientException(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template upload_file_failure}
/// Failure when uploading a file.
/// {@endtemplate}
class UploadFileFailure extends FelicashStorageClientException {
  /// {@macro upload_file_failure}
  const UploadFileFailure(super.error);
}

/// {@template storage_client}
/// A client for the storage.
/// {@endtemplate}
class FelicashStorageClient {
  /// {@macro storage_client}
  const FelicashStorageClient({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  /// Upload a file to the storage.
  ///
  /// The [path] is the path to the file on the device.
  /// The [bucketName] is the name of the bucket to upload the file to.
  /// The [bucketFileName] is the name of the file in the bucket.
  /// if not provided, it will be the same as the file name in the path.
  ///
  /// Returns the path to the file in the bucket.
  /// {@macro upload_file_failure}
  Future<String> uploadFileFromPath({
    required String path,
    required String bucketName,
    String? bucketFileName,
  }) async {
    try {
      final file = File(path);
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Current user not found');
      }

      final fileName = bucketFileName ?? path_package.basename(path);
      final userBasedBucketPath = path_package.join(userId, fileName);

      await _supabaseClient.storage
          .from(bucketName)
          .upload(userBasedBucketPath, file);
      final publicUrl = _supabaseClient.storage
          .from(bucketName)
          .getPublicUrl(userBasedBucketPath);

      return publicUrl;
    } catch (e, stackTrace) {
      if (e is UploadFileFailure) rethrow;
      Error.throwWithStackTrace(UploadFileFailure(e), stackTrace);
    }
  }

  /// Upload a file to the storage.
  ///
  /// {@macro upload_file_failure}
  Future<String> uploadFileFromFile({required File file}) async {
    try {
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Current user not found');
      }
      final filePath = await _supabaseClient.storage
          .from(userId)
          .upload(file.path, file);
      return filePath;
    } catch (e, stackTrace) {
      if (e is UploadFileFailure) rethrow;
      Error.throwWithStackTrace(UploadFileFailure(e), stackTrace);
    }
  }
}
