# Development Workflow Guide

## 🚀 完全な開発環境の起動と実行

### 1. 開発環境の起動

#### 自動起動（推奨）
```bash
cd devlop/laravel-prj

# すべてのサービスを一度に起動
chmod +x scripts/start-development.sh
./scripts/start-development.sh
```

このスクリプトが以下を自動実行します：
- ✅ Laravelバックエンドの起動（Dockerまたは手動）
- ✅ Next.jsフロントエンドの起動
- ✅ エミュレーターの起動
- ✅ Flutter環境の準備
- ✅ サービス状態の確認

#### 個別起動
```bash
# Laravelバックエンドのみ
docker-compose up -d app webserver db

# Next.jsフロントエンドのみ
cd frontend && npm run dev

# エミュレーターのみ
flutter emulators --launch flutter_emulator
```

### 2. 開発環境の状態確認

```bash
# すべてのサービスの状態を確認
chmod +x scripts/development-status.sh
./scripts/development-status.sh
```

このスクリプトが以下を確認します：
- ✅ Laravelバックエンドの動作状況
- ✅ Next.jsフロントエンドの動作状況
- ✅ phpMyAdminの動作状況
- ✅ Flutter環境の状態
- ✅ エミュレーターの利用可能性
- ✅ システムリソースの使用状況

### 3. モバイルアプリの実行

#### エミュレーターでの実行
```bash
# Androidエミュレーターで実行
cd mobile
flutter run -d android

# iOSシミュレーターで実行（macOSのみ）
flutter run -d ios
```

#### 実機での実行
```bash
# 接続されたデバイスで実行
flutter run

# 利用可能なデバイスを確認
flutter devices
```

### 4. 開発環境の停止

```bash
# すべてのサービスを停止
chmod +x scripts/stop-development.sh
./scripts/stop-development.sh
```

## 🔄 開発ワークフロー

### 1. 日常的な開発サイクル

#### 朝のセットアップ
```bash
# 1. 開発環境を起動
./scripts/start-development.sh

# 2. 状態を確認
./scripts/development-status.sh

# 3. エミュレーターを起動
flutter emulators --launch flutter_emulator

# 4. モバイルアプリを実行
cd mobile && flutter run
```

#### 開発中の作業
```bash
# コード変更後、ホットリロード
# Flutter: アプリ実行中に 'r' キーを押す
# Next.js: 自動的にホットリロード

# 新しい依存関係を追加した場合
cd mobile && flutter pub get
cd frontend && npm install

# コード生成が必要な場合
cd mobile && flutter packages pub run build_runner build
```

#### 夜のクリーンアップ
```bash
# すべてのサービスを停止
./scripts/stop-development.sh
```

### 2. 機能開発ワークフロー

#### バックエンド機能の追加
```bash
# 1. Laravelコントローラーを作成
docker-compose exec app php artisan make:controller NewFeatureController

# 2. ルートを追加
# routes/api.php に新しいルートを追加

# 3. マイグレーションを作成
docker-compose exec app php artisan make:migration create_new_feature_table

# 4. マイグレーションを実行
docker-compose exec app php artisan migrate

# 5. APIをテスト
curl http://localhost:8000/api/new-feature
```

#### フロントエンド機能の追加
```bash
# 1. Next.jsコンポーネントを作成
cd frontend/src/components
touch NewFeature.tsx

# 2. APIクライアントを更新
# src/lib/api.ts に新しいAPI関数を追加

# 3. ページを作成
cd frontend/src/app
mkdir new-feature
touch new-feature/page.tsx
```

#### モバイル機能の追加
```bash
# 1. Flutterページを作成
cd mobile/lib/features
mkdir new_feature
mkdir new_feature/presentation/pages
touch new_feature/presentation/pages/new_feature_page.dart

# 2. ルートを追加
# lib/core/router/app_router.dart に新しいルートを追加

# 3. APIサービスを更新
# lib/core/services/api_service.dart に新しいAPI関数を追加

# 4. コードを生成
flutter packages pub run build_runner build
```

### 3. テストワークフロー

#### バックエンドテスト
```bash
# Laravelテストを実行
docker-compose exec app php artisan test

# 特定のテストを実行
docker-compose exec app php artisan test --filter=UserTest
```

#### フロントエンドテスト
```bash
# Next.jsテストを実行
cd frontend
npm test

# 特定のテストを実行
npm test -- --testNamePattern="NewFeature"
```

#### モバイルテスト
```bash
# Flutterテストを実行
cd mobile
flutter test

# 特定のテストを実行
flutter test test/new_feature_test.dart

# 統合テストを実行
flutter test integration_test/
```

### 4. デバッグワークフロー

#### バックエンドデバッグ
```bash
# Laravelログを確認
docker-compose exec app tail -f storage/logs/laravel.log

# デバッグモードで実行
docker-compose exec app php artisan serve --host=0.0.0.0 --port=8000
```

#### フロントエンドデバッグ
```bash
# Next.jsログを確認
cd frontend
npm run dev

# ブラウザの開発者ツールでデバッグ
# Network tab でAPI呼び出しを確認
```

#### モバイルデバッグ
```bash
# Flutterデバッグモードで実行
cd mobile
flutter run --debug

# ホットリロードでデバッグ
# アプリ実行中に 'r' キーでホットリロード
# 'R' キーでホットリスタート
```

## 🛠️ トラブルシューティング

### よくある問題と解決方法

#### 1. ポート競合
```bash
# 使用中のポートを確認
lsof -i :8000
lsof -i :3000

# プロセスを強制終了
kill -9 <PID>
```

#### 2. Dockerコンテナの問題
```bash
# コンテナを再起動
docker-compose restart

# コンテナを再作成
docker-compose down
docker-compose up -d
```

#### 3. Flutterの問題
```bash
# Flutter環境をクリーンアップ
cd mobile
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### 4. 依存関係の問題
```bash
# フロントエンド依存関係を再インストール
cd frontend
rm -rf node_modules package-lock.json
npm install

# モバイル依存関係を再インストール
cd mobile
flutter pub get
```

## 📱 モバイル開発のベストプラクティス

### 1. エミュレーターの管理
```bash
# 利用可能なエミュレーターを確認
flutter emulators

# 新しいエミュレーターを作成
flutter emulators --create --name my_emulator

# エミュレーターを起動
flutter emulators --launch my_emulator
```

### 2. デバイス管理
```bash
# 接続されたデバイスを確認
flutter devices

# 特定のデバイスで実行
flutter run -d <device-id>
```

### 3. パフォーマンス最適化
```bash
# リリースモードで実行
flutter run --release

# プロファイリングモードで実行
flutter run --profile
```

## 🔧 開発ツールの活用

### 1. IDE設定

#### VS Code推奨拡張機能
- Flutter
- Dart
- Laravel Extension Pack
- PHP Intelephense
- ES7+ React/Redux/React-Native snippets

#### Android Studio推奨設定
- Flutterプラグイン
- Dartプラグイン
- Laravel Plugin

### 2. デバッグツール

#### Laravel Debugbar
```bash
# 開発環境でデバッグバーを有効化
composer require barryvdh/laravel-debugbar --dev
```

#### Flutter Inspector
```bash
# Flutter Inspectorを起動
flutter run --debug
# ブラウザで http://localhost:8080 にアクセス
```

### 3. コード品質ツール

#### バックエンド
```bash
# PHPStanで静的解析
composer require phpstan/phpstan --dev
./vendor/bin/phpstan analyse

# PHP CS Fixerでコード整形
composer require friendsofphp/php-cs-fixer --dev
./vendor/bin/php-cs-fixer fix
```

#### フロントエンド
```bash
# ESLintでコード解析
cd frontend
npm run lint

# Prettierでコード整形
npm run format
```

#### モバイル
```bash
# Flutter Analyzeでコード解析
cd mobile
flutter analyze

# Dart Formatでコード整形
dart format .
```

## 📊 パフォーマンス監視

### 1. システムリソース監視
```bash
# リアルタイムでシステムリソースを監視
./scripts/development-status.sh

# 定期的に状態を確認
watch -n 30 ./scripts/development-status.sh
```

### 2. アプリケーションパフォーマンス
```bash
# Laravelパフォーマンス監視
docker-compose exec app php artisan route:cache
docker-compose exec app php artisan config:cache

# Next.jsパフォーマンス監視
cd frontend
npm run build
npm run start
```

### 3. モバイルパフォーマンス
```bash
# Flutterパフォーマンスプロファイリング
flutter run --profile
flutter run --trace-startup
```

## 🚀 本番環境への準備

### 1. ビルドとテスト
```bash
# バックエンドテスト
docker-compose exec app php artisan test

# フロントエンドビルド
cd frontend && npm run build

# モバイルビルド
cd mobile
flutter build apk --release
flutter build ios --release
```

### 2. セキュリティチェック
```bash
# 依存関係の脆弱性チェック
composer audit
npm audit
flutter pub deps
```

### 3. パフォーマンステスト
```bash
# APIパフォーマンステスト
ab -n 1000 -c 10 http://localhost:8000/api/health

# フロントエンドパフォーマンステスト
lighthouse http://localhost:3000
```

このワークフローガイドに従うことで、効率的で一貫性のある開発環境を維持できます。 