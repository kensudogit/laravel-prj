// Flutterアプリケーションのメインエントリーポイント
// Laravelバックエンドと連携するモバイルアプリケーションの起動処理
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laravel_mobile_app/core/theme/app_theme.dart';
import 'package:laravel_mobile_app/core/router/app_router.dart';
import 'package:laravel_mobile_app/core/providers/providers.dart';

/// アプリケーションのメイン関数
/// Flutterアプリケーションの初期化と起動処理を実行
void main() async {
  // Flutterエンジンの初期化を確実に行う
  WidgetsFlutterBinding.ensureInitialized();
  
  // Hiveローカルストレージの初期化
  // オフライン時のデータ永続化に使用
  await Hive.initFlutter();
  
  // アプリケーションを起動
  // ProviderScopeでRiverpodの状態管理を有効化
  runApp(
    const ProviderScope(
      child: LaravelMobileApp(),
    ),
  );
}

/// Laravelモバイルアプリケーションのルートウィジェット
/// テーマ設定、ルーティング、状態管理を統合してアプリケーションを構築
class LaravelMobileApp extends ConsumerWidget {
  const LaravelMobileApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Riverpodからルーターとテーマモードを取得
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    
    // MaterialApp.routerを使用してGo Routerによるナビゲーションを設定
    return MaterialApp.router(
      title: 'Laravel Mobile App', // アプリケーションタイトル
      debugShowCheckedModeBanner: false, // デバッグバナーを非表示
      theme: AppTheme.lightTheme, // ライトテーマ
      darkTheme: AppTheme.darkTheme, // ダークテーマ
      themeMode: themeMode, // 現在のテーマモード（ライト/ダーク/システム）
      routerConfig: router, // Go Routerの設定
    );
  }
} 