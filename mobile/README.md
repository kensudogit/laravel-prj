# Flutter Mobile App

## 🚀 概要

このプロジェクトは、Laravelバックエンドと連携するFlutterモバイルアプリケーションです。クロスプラットフォーム（iOS/Android）対応のモダンなモバイルアプリを提供します。

## 📋 技術スタック

- **Flutter**: 3.16.0+
- **Dart**: 3.2.0+
- **Riverpod**: 2.4.9 (状態管理)
- **Go Router**: 12.1.3 (ナビゲーション)
- **Dio**: 5.3.2 (HTTP通信)
- **Hive**: 2.2.3 (ローカルストレージ)
- **Material 3**: モダンなUIデザイン

## 🛠️ セットアップ

### 前提条件
- Flutter 3.16.0以上
- Dart 3.2.0以上
- Android Studio / Xcode
- Laravelバックエンドが動作していること

### インストール
```bash
# プロジェクトルートから実行
cd devlop/laravel-prj

# モバイルアプリのセットアップ
chmod +x scripts/setup-mobile.sh
./scripts/setup-mobile.sh
```

### 手動セットアップ
```bash
# モバイルディレクトリに移動
cd mobile

# 依存関係のインストール
flutter pub get

# コード生成
flutter packages pub run build_runner build --delete-conflicting-outputs

# アプリの実行
flutter run
```

## 📁 プロジェクト構造

```
mobile/
├── lib/
│   ├── main.dart                 # アプリケーションエントリーポイント
│   ├── core/                     # コア機能
│   │   ├── theme/               # テーマ設定
│   │   │   └── app_theme.dart
│   │   ├── router/              # ルーティング
│   │   │   └── app_router.dart
│   │   ├── providers/           # プロバイダー
│   │   │   └── providers.dart
│   │   └── services/            # サービス
│   │       └── api_service.dart
│   └── features/                # 機能別モジュール
│       ├── auth/                # 認証機能
│       │   └── presentation/
│       │       └── pages/
│       │           ├── login_page.dart
│       │           └── register_page.dart
│       ├── home/                # ホーム機能
│       │   └── presentation/
│       │       └── pages/
│       │           └── home_page.dart
│       ├── profile/             # プロフィール機能
│       │   └── presentation/
│       │       └── pages/
│       │           └── profile_page.dart
│       └── splash/              # スプラッシュ画面
│           └── presentation/
│               └── pages/
│                   └── splash_page.dart
├── assets/                      # アセット
│   ├── images/
│   ├── icons/
│   └── fonts/
├── pubspec.yaml                 # 依存関係
└── README.md                    # このファイル
```

## 🔧 設定

### API設定
```dart
// lib/core/providers/providers.dart
final apiBaseUrlProvider = Provider<String>((ref) {
  return 'http://10.0.2.2:8000/api'; // Android emulator
  // return 'http://localhost:8000/api'; // iOS simulator
  // return 'https://your-api-domain.com/api'; // Production
});
```

### テーマ設定
- **Material 3**: 有効
- **ダークモード**: 対応
- **カスタムカラー**: primary/secondary colors
- **レスポンシブ**: 対応

## 🎨 UI/UX機能

### デザインシステム
- **Material 3**: 最新のMaterial Design
- **ダークモード**: システム設定に応じた自動切り替え
- **カスタムテーマ**: ブランドカラーに合わせたカスタマイズ
- **アニメーション**: スムーズなトランジション

### コンポーネント
- **カスタムボタン**: プライマリ、セカンダリ、アウトライン
- **フォームフィールド**: バリデーション対応
- **カード**: モダンなカードデザイン
- **ローディング**: スケルトンローディング

## 🔌 API統合

### Laravelバックエンド連携
```dart
// API通信例
final apiService = ref.read(apiServiceProvider);

// ログイン
final response = await apiService.login(email, password);

// ユーザー取得
final users = await apiService.getUsers();

// ヘルスチェック
final health = await apiService.healthCheck();
```

### エラーハンドリング
- **ネットワークエラー**: 自動リトライ
- **認証エラー**: 自動ログアウト
- **バリデーションエラー**: ユーザーフレンドリーな表示

## 📱 プラットフォーム対応

### Android
- **最小SDK**: API 21 (Android 5.0)
- **ターゲットSDK**: API 34 (Android 14)
- **権限**: インターネット、ストレージ

### iOS
- **最小バージョン**: iOS 12.0
- **ターゲットバージョン**: iOS 17.0
- **権限**: ネットワークアクセス

## 🧪 テスト

```bash
# ユニットテスト
flutter test

# ウィジェットテスト
flutter test test/widget_test.dart

# 統合テスト
flutter test integration_test/

# コード分析
flutter analyze
```

## 🚀 ビルドとデプロイ

### Android
```bash
# APKビルド
flutter build apk

# App Bundleビルド（Google Play用）
flutter build appbundle

# リリースビルド
flutter build apk --release
```

### iOS
```bash
# iOSビルド
flutter build ios

# リリースビルド
flutter build ios --release
```

## 🔄 開発ワークフロー

1. **機能開発**
   ```bash
   # 新しい機能ブランチを作成
   git checkout -b feature/new-feature
   
   # 開発サーバー起動
   flutter run
   ```

2. **コード品質**
   ```bash
   # リンター実行
   flutter analyze
   
   # コードフォーマット
   dart format .
   
   # テスト実行
   flutter test
   ```

3. **コード生成**
   ```bash
   # モデル生成
   flutter packages pub run build_runner build
   
   # 継続的生成
   flutter packages pub run build_runner watch
   ```

## 📚 参考資料

- [Flutter公式ドキュメント](https://flutter.dev/docs)
- [Dart公式ドキュメント](https://dart.dev/guides)
- [Riverpod公式ドキュメント](https://riverpod.dev/)
- [Go Router公式ドキュメント](https://pub.dev/packages/go_router)

## 🤝 コントリビューション

1. フォークを作成
2. 機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 🆘 トラブルシューティング

### よくある問題

1. **Flutter doctor エラー**
   ```bash
   flutter doctor
   # 表示された問題を解決してください
   ```

2. **依存関係エラー**
   ```bash
   flutter clean
   flutter pub get
   ```

3. **ビルドエラー**
   ```bash
   flutter clean
   flutter pub get
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **API接続エラー**
   - Laravelバックエンドが起動していることを確認
   - エミュレータ/シミュレータのIPアドレスを確認
   - ファイアウォール設定を確認 