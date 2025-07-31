// Riverpodプロバイダーの定義ファイル
// アプリケーション全体で使用する状態管理のプロバイダーを定義
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ===== テーマ関連プロバイダー =====

/// テーマモードの状態管理プロバイダー
/// ライトテーマ、ダークテーマ、システムテーマの切り替えを管理
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system; // デフォルトはシステム設定に従う
});

// ===== ローカルストレージ関連プロバイダー =====

/// SharedPreferencesのプロバイダー
/// アプリケーション設定やユーザー設定の永続化に使用
/// 現在は未実装（必要に応じて実装）
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// ===== API関連プロバイダー =====

/// APIベースURLのプロバイダー
/// 開発環境、本番環境に応じて適切なAPIエンドポイントを提供
final apiBaseUrlProvider = Provider<String>((ref) {
  // 開発環境ではlocalhostを使用
  // 本番環境では実際のAPI URLを使用
  return 'http://10.0.2.2:8000/api'; // Androidエミュレーター用localhost
  // return 'http://localhost:8000/api'; // iOSシミュレーター用localhost
  // return 'https://your-api-domain.com/api'; // 本番環境用
});

// ===== 認証関連プロバイダー =====

/// 認証状態の管理プロバイダー
/// ユーザーのログイン状態を管理（true: ログイン済み、false: 未ログイン）
final authStateProvider = StateProvider<bool>((ref) {
  return false; // デフォルトは未ログイン状態
});

/// ユーザー情報の管理プロバイダー
/// ログインしているユーザーの詳細情報を管理
final userProvider = StateProvider<Map<String, dynamic>?>((ref) {
  return null; // デフォルトはユーザー情報なし
});

// ===== UI状態管理プロバイダー =====

/// ローディング状態の管理プロバイダー
/// アプリケーション全体のローディング状態を管理
/// データ取得中や処理中の表示制御に使用
final loadingProvider = StateProvider<bool>((ref) {
  return false; // デフォルトはローディングなし
}); 