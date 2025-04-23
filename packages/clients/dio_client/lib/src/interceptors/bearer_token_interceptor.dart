import 'package:dio/dio.dart';

/// TokenProvider is a function that returns a token.
typedef TokenProvider = Future<String?> Function();

/// RefreshTokenProvider is a function that returns a refresh token.
typedef RefreshTokenProvider = Future<String?> Function();

/// {@template bearer_token_interceptor}
/// BearerTokenInterceptor is a [Dio] interceptor that adds a bearer token to
/// the request headers.
///
/// Also handles refresh token.
///
/// {@endtemplate}
class BearerTokenInterceptor extends Interceptor {
  /// {@macro bearer_token_interceptor}
  BearerTokenInterceptor({
    required TokenProvider tokenProvider,
    required RefreshTokenProvider refreshTokenProvider,
  })  : _tokenProvider = tokenProvider,
        _refreshTokenProvider = refreshTokenProvider;

  final TokenProvider _tokenProvider;
  final RefreshTokenProvider _refreshTokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenProvider();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final opts = Options(
      method: err.requestOptions.method,
      headers: err.requestOptions.headers,
      contentType: err.requestOptions.contentType,
    );
    if (err.response != null) {
      final dioClient = Dio(
        BaseOptions(
          baseUrl: err.requestOptions.baseUrl,
          connectTimeout: err.requestOptions.connectTimeout,
          receiveTimeout: err.requestOptions.receiveTimeout,
          sendTimeout: err.requestOptions.sendTimeout,
        ),
      );
      if (err.response!.statusCode == 401) {
        try {
          final newToken = await _refreshTokenProvider();
          if (newToken == null) return handler.next(err);
          final response = await _retryRequest(dioClient, err, opts);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }
    return handler.next(err);
  }

  Future<Response<dynamic>> _retryRequest(
    Dio dioClient,
    DioException err,
    Options opts,
  ) async {
    return dioClient.request<dynamic>(
      err.requestOptions.baseUrl + err.requestOptions.path,
      options: opts,
      cancelToken: err.requestOptions.cancelToken,
      onReceiveProgress: err.requestOptions.onReceiveProgress,
      data: err.requestOptions.data,
      queryParameters: err.requestOptions.queryParameters,
    );
  }
}
