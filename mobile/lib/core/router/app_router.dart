// アプリケーションのルーティング設定ファイル
// Go Routerを使用してページ間のナビゲーションを管理
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:laravel_mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:laravel_mobile_app/features/auth/presentation/pages/register_page.dart';
import 'package:laravel_mobile_app/features/home/presentation/pages/home_page.dart';
import 'package:laravel_mobile_app/features/profile/presentation/pages/profile_page.dart';
import 'package:laravel_mobile_app/features/splash/presentation/pages/splash_page.dart';

/// アプリケーションのルーティング設定プロバイダー
/// Go Routerを使用してページ間のナビゲーションを定義
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash', // アプリケーション起動時の初期ページ
    routes: [
      // ===== スプラッシュ画面 =====
      GoRoute(
        path: '/splash', // URLパス
        name: 'splash', // ルート名（context.goNamed()で使用）
        builder: (context, state) => const SplashPage(), // 表示するページ
      ),
      
      // ===== 認証関連ルート =====
      GoRoute(
        path: '/login', // ログインページのパス
        name: 'login', // ログインページのルート名
        builder: (context, state) => const LoginPage(), // ログインページ
      ),
      GoRoute(
        path: '/register', // ユーザー登録ページのパス
        name: 'register', // ユーザー登録ページのルート名
        builder: (context, state) => const RegisterPage(), // ユーザー登録ページ
      ),
      
      // ===== メインアプリケーションルート =====
      GoRoute(
        path: '/', // ホームページのパス（ルートパス）
        name: 'home', // ホームページのルート名
        builder: (context, state) => const HomePage(), // ホームページ
      ),
      GoRoute(
        path: '/profile', // プロフィールページのパス
        name: 'profile', // プロフィールページのルート名
        builder: (context, state) => const ProfilePage(), // プロフィールページ
      ),
    ],
    // ===== エラーハンドリング =====
    // 存在しないページにアクセスした場合のエラーページ
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline, // エラーアイコン
              size: 64,
              color: Colors.red, // 赤色でエラーを表現
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found', // エラーメッセージ
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.', // 詳細メッセージ
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'), // ホームページに戻るボタン
              child: const Text('Go Home'), // ボタンテキスト
            ),
          ],
        ),
      ),
    ),
  );
}); 