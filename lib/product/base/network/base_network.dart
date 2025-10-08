import 'package:base_project/product/utils/logger_utils.dart';
import 'package:dio/dio.dart';

import '../../cache/locale_manager.dart';
import '../../constants/enums/locale_keys_enum.dart';

class BaseNetwork {
  String? token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN);
  String testToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDk3ODM1OTcsImlhdCI6MTc0OTY5NzE5NywiaWQiOiJibXV0Mmh0aDEwcWY4NjRzZWR1IiwiaXNzIjoic2ZtIiwicm9sZSI6IlVTRVIifQ.mReW1hQsjSFh622jywFosb9NjkClNzlvP_zqbVd84sY";
  late Dio _dio;
  final String _baseUrl;
  static const int _connectTimeout = 30000; // 30s
  static const int _receiveTimeout = 30000; // 30s

  BaseNetwork({
    String baseUrl = 'https://sfm.smatec.com.vn',
    Map<String, String>? headers,
  }) : _baseUrl = baseUrl {
    _initializeDio(headers);
  }

  // Initialize Dio with base configurations
  void _initializeDio(Map<String, String>? headers) {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: Duration(milliseconds: _connectTimeout),
      receiveTimeout: Duration(milliseconds: _receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token,
        ...?headers,
      },
      followRedirects: true,
      maxRedirects: 5,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ));

    // Configure Dio for better SSL handling
    // (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
    //     (HttpClient client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };

    // Add interceptors for logging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          AppLoggerUtils.info(
              'REQUEST[${options.method}] => PATH: ${options.path}');
          // print('Headers: ${options.headers}');
          if (options.queryParameters.isNotEmpty) {
            AppLoggerUtils.info('Query: ${options.queryParameters}');
          }
          if (options.data != null) {
            AppLoggerUtils.info('Body: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          AppLoggerUtils.info(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          AppLoggerUtils.info('Data: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) {
          AppLoggerUtils.error(
              'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          AppLoggerUtils.error('Error Message: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw _handleGenericError(e);
    }
  }

  // GET with query parameters
  Future<Response> getWithParams(
    String path, {
    required Map<String, dynamic> params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw _handleGenericError(e);
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw _handleGenericError(e);
    }
  }

  // POST with FormData (for file uploads)
  Future<Response> postFormData(
    String path, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options ?? Options(contentType: 'multipart/form-data'),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw _handleGenericError(e);
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw _handleGenericError(e);
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw _handleGenericError(e);
    }
  }

  // Handle Dio errors
  Exception _handleDioError(DioException error) {
    String message = 'Network error occurred';
    if (error.response != null) {
      message = 'Request failed with status: ${error.response?.statusCode}';
      switch (error.response?.statusCode) {
        case 400:
          message = 'Bad request';
          break;
        case 401:
          message = 'Unauthorized';
          break;
        case 403:
          message = 'Forbidden';
          break;
        case 404:
          message = 'Resource not found';
          break;
        case 500:
          message = 'Server error';
          break;
      }
    } else if (error.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      message = 'Receive timeout';
    } else if (error.type == DioExceptionType.cancel) {
      message = 'Request cancelled';
    }
    return Exception('$message: ${error.message}');
  }

  // Handle generic errors
  Exception _handleGenericError(Object error) {
    return Exception('Unexpected error: $error');
  }

  // Add authentication token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Remove authentication token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Update base URL
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  // Add custom header
  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  // Remove header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  // Retry request
  Future<Response> retry(RequestOptions options, {int maxRetries = 3}) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        return await _dio.request(
          options.path,
          data: options.data,
          queryParameters: options.queryParameters,
          options: Options(
            method: options.method,
            headers: options.headers,
          ),
        );
      } catch (e) {
        attempts++;
        if (attempts == maxRetries) {
          rethrow;
        }
        await Future.delayed(Duration(milliseconds: 1000 * attempts));
      }
    }
    throw Exception('Max retry attempts reached');
  }
}
