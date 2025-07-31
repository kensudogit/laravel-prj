// LaravelバックエンドとのAPI通信を管理するサービス
// Dio HTTPクライアントを使用してRESTful APIとの通信を実装
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laravel_mobile_app/core/providers/providers.dart';
import 'package:logger/logger.dart';

/// LaravelバックエンドAPIとの通信を管理するサービスクラス
/// 認証、ユーザー管理、ヘルスチェックなどのAPIエンドポイントを提供
class ApiService {
  /// Dio HTTPクライアントのインスタンス
  final Dio _dio;
  /// ログ出力用のLoggerインスタンス
  final Logger _logger;

  /// ApiServiceのコンストラクタ
  /// RiverpodのWidgetRefを使用してAPIベースURLを取得し、Dioクライアントを初期化
  ApiService(WidgetRef ref) : _logger = Logger() {
    // プロバイダーからAPIベースURLを取得
    final baseUrl = ref.read(apiBaseUrlProvider);
    
    // Dioクライアントの基本設定を構成
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl, // APIのベースURL
      connectTimeout: const Duration(seconds: 30), // 接続タイムアウト
      receiveTimeout: const Duration(seconds: 30), // 受信タイムアウト
      headers: {
        'Content-Type': 'application/json', // JSONコンテンツタイプ
        'Accept': 'application/json', // JSONレスポンスを受け入れ
      },
    ));

    // リクエストとレスポンスのログ出力用インターセプターを追加
    _dio.interceptors.add(LogInterceptor(
      requestBody: true, // リクエストボディをログ出力
      responseBody: true, // レスポンスボディをログ出力
      logPrint: (obj) => _logger.d(obj), // デバッグレベルでログ出力
    ));

    // リクエストとエラーハンドリング用のインターセプターを追加
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 認証トークンが利用可能な場合に追加（現在はコメントアウト）
        // final token = await _getAuthToken();
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        handler.next(options); // リクエストを次のインターセプターに渡す
      },
      onError: (error, handler) {
        // APIエラーをログ出力
        _logger.e('API Error: ${error.message}');
        handler.next(error); // エラーを次のインターセプターに渡す
      },
    ));
  }

  /// 汎用GETリクエストメソッド
  /// 指定されたパスにGETリクエストを送信し、レスポンスを返す
  /// [path] APIエンドポイントのパス
  /// [queryParameters] クエリパラメータ（オプション）
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      _logger.e('GET request failed: $e'); // エラーをログ出力
      rethrow; // エラーを再スロー
    }
  }

  /// 汎用POSTリクエストメソッド
  /// 指定されたパスにPOSTリクエストを送信し、レスポンスを返す
  /// [path] APIエンドポイントのパス
  /// [data] 送信するデータ（オプション）
  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      _logger.e('POST request failed: $e'); // エラーをログ出力
      rethrow; // エラーを再スロー
    }
  }

  /// 汎用PUTリクエストメソッド
  /// 指定されたパスにPUTリクエストを送信し、レスポンスを返す
  /// [path] APIエンドポイントのパス
  /// [data] 送信するデータ（オプション）
  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } catch (e) {
      _logger.e('PUT request failed: $e'); // エラーをログ出力
      rethrow; // エラーを再スロー
    }
  }

  /// 汎用DELETEリクエストメソッド
  /// 指定されたパスにDELETEリクエストを送信し、レスポンスを返す
  /// [path] APIエンドポイントのパス
  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } catch (e) {
      _logger.e('DELETE request failed: $e'); // エラーをログ出力
      rethrow; // エラーを再スロー
    }
  }

  // ===== 認証関連エンドポイント =====
  
  /// ユーザーログイン
  /// [email] ユーザーのメールアドレス
  /// [password] ユーザーのパスワード
  Future<Response> login(String email, String password) async {
    return await post('/auth/login', data: {
      'email': email,
      'password': password,
    });
  }

  /// ユーザー登録
  /// [name] ユーザー名
  /// [email] メールアドレス
  /// [password] パスワード
  /// [passwordConfirmation] パスワード確認
  Future<Response> register(String name, String email, String password, String passwordConfirmation) async {
    return await post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }

  /// ユーザーログアウト
  Future<Response> logout() async {
    return await post('/auth/logout');
  }

  /// 現在のユーザー情報を取得
  Future<Response> getUser() async {
    return await get('/auth/user');
  }

  // ===== ユーザー管理エンドポイント =====
  
  /// ユーザー一覧を取得
  /// [params] クエリパラメータ（ページネーション、フィルタリングなど）
  Future<Response> getUsers({Map<String, dynamic>? params}) async {
    return await get('/users', queryParameters: params);
  }

  /// 指定されたIDのユーザー情報を取得
  /// [id] ユーザーID
  Future<Response> getUserById(int id) async {
    return await get('/users/$id');
  }

  // ===== システムエンドポイント =====
  
  /// APIヘルスチェック
  /// バックエンドの動作状況を確認するために使用
  Future<Response> healthCheck() async {
    return await get('/health');
  }
}

// ===== Riverpodプロバイダー =====

/// ApiServiceのRiverpodプロバイダー
/// アプリケーション全体でApiServiceのインスタンスを共有するために使用
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(ref);
}); 