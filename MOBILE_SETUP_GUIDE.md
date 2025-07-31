# Mobile Development Setup Guide

## 🚀 Flutter SDKのインストール

### 自動インストール（推奨）

```bash
# プロジェクトルートから実行
cd devlop/laravel-prj

# Flutter SDKのインストール
chmod +x scripts/install-flutter.sh
./scripts/install-flutter.sh
```

### 手動インストール

#### Windows
1. [Flutter公式サイト](https://flutter.dev/docs/get-started/install/windows)からFlutter SDKをダウンロード
2. ZIPファイルを解凍（例：`C:\flutter`）
3. 環境変数PATHに`C:\flutter\bin`を追加
4. コマンドプロンプトを再起動

#### macOS
```bash
# Homebrewを使用
brew install --cask flutter

# または手動インストール
cd ~
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:$HOME/flutter/bin"
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
```

#### Linux
```bash
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.9-stable.tar.xz
tar xf flutter_linux_3.16.9-stable.tar.xz
export PATH="$PATH:$HOME/flutter/bin"
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
```

### インストール確認
```bash
flutter --version
flutter doctor
```

## 🛠️ Android Studio / Xcodeの設定

### Android Studio（Android開発用）

#### 自動インストール
```bash
chmod +x scripts/setup-android-studio.sh
./scripts/setup-android-studio.sh
```

#### 手動インストール
1. [Android Studio公式サイト](https://developer.android.com/studio)からダウンロード
2. インストーラーを実行
3. 初期設定ウィザードを完了
4. Android SDKをインストール

#### Android Studio設定
1. **Flutterプラグインのインストール**
   - Android Studioを起動
   - `File` → `Settings` → `Plugins`
   - "Flutter"を検索してインストール
   - "Dart"プラグインも自動でインストールされる

2. **Android SDKの設定**
   - `File` → `Settings` → `Appearance & Behavior` → `System Settings` → `Android SDK`
   - 以下のSDKをインストール：
     - Android SDK Platform 34 (Android 14)
     - Android SDK Build-Tools 34.0.0
     - Android SDK Command-line Tools

### Xcode（iOS開発用、macOSのみ）

#### インストール
1. App StoreからXcodeをインストール
2. コマンドライン開発ツールをインストール：
   ```bash
   xcode-select --install
   ```

#### Xcode設定
1. **ライセンス同意**
   ```bash
   sudo xcodebuild -license accept
   ```

2. **iOSシミュレーターの確認**
   ```bash
   xcrun simctl list devices available
   ```

## 📱 エミュレータ/シミュレータの起動

### 自動セットアップ
```bash
chmod +x scripts/setup-emulator.sh
./scripts/setup-emulator.sh
```

### 手動セットアップ

#### Android Emulator
1. **AVD Managerを開く**
   - Android Studio → `Tools` → `AVD Manager`
   - または `flutter emulators` コマンド

2. **新しい仮想デバイスを作成**
   - `Create Virtual Device`
   - デバイス選択：Pixel 7
   - システムイメージ：API 34 (Android 14)
   - AVD名：`flutter_emulator`

3. **エミュレーターを起動**
   ```bash
   flutter emulators --launch flutter_emulator
   # または
   emulator -avd flutter_emulator
   ```

#### iOS Simulator（macOSのみ）
1. **シミュレーターを起動**
   ```bash
   open -a Simulator
   ```

2. **デバイスを選択**
   - `Device` → `iOS` → `iPhone 15`

3. **Flutterから起動**
   ```bash
   flutter emulators --launch "iPhone 15"
   ```

## 🚀 モバイルアプリの実行

### 自動実行
```bash
chmod +x scripts/run-mobile-app.sh
./scripts/run-mobile-app.sh
```

### 手動実行

#### 1. プロジェクトディレクトリに移動
```bash
cd devlop/laravel-prj/mobile
```

#### 2. 依存関係をインストール
```bash
flutter pub get
```

#### 3. コードを生成
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### 4. 利用可能なデバイスを確認
```bash
flutter devices
```

#### 5. アプリを実行

**Android Emulator:**
```bash
flutter run -d android
```

**iOS Simulator:**
```bash
flutter run -d ios
```

**接続されたデバイス:**
```bash
flutter run
```

## 🔧 トラブルシューティング

### よくある問題と解決方法

#### 1. Flutter doctor エラー
```bash
flutter doctor
```
表示された問題を順番に解決してください。

#### 2. Android SDK が見つからない
```bash
# Android StudioでSDKをインストール
# または環境変数を設定
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

#### 3. iOS Simulator エラー（macOS）
```bash
# Xcodeコマンドラインツールを再インストール
sudo xcode-select --reset
xcode-select --install
```

#### 4. エミュレーターが起動しない
```bash
# AVDを再作成
flutter emulators --create --name flutter_emulator
flutter emulators --launch flutter_emulator
```

#### 5. 依存関係エラー
```bash
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 📋 開発ワークフロー

### 1. 開発環境の準備
```bash
# Laravelバックエンドを起動
docker-compose up -d
# または
php artisan serve

# エミュレーターを起動
flutter emulators --launch flutter_emulator
```

### 2. アプリの実行
```bash
cd mobile
flutter run
```

### 3. ホットリロード
- アプリ実行中に `r` キーを押すとホットリロード
- `R` キーを押すとホットリスタート

### 4. デバッグ
- Android Studio / VS Codeでブレークポイントを設定
- `flutter run --debug` でデバッグモードで実行

## 🧪 テスト

### ユニットテスト
```bash
flutter test
```

### ウィジェットテスト
```bash
flutter test test/widget_test.dart
```

### 統合テスト
```bash
flutter test integration_test/
```

## 📱 ビルドとデプロイ

### Android APK
```bash
flutter build apk
```

### Android App Bundle（Google Play用）
```bash
flutter build appbundle
```

### iOS（macOSのみ）
```bash
flutter build ios
```

## 🔗 参考資料

- [Flutter公式ドキュメント](https://flutter.dev/docs)
- [Dart公式ドキュメント](https://dart.dev/guides)
- [Android Studio公式サイト](https://developer.android.com/studio)
- [Xcode公式サイト](https://developer.apple.com/xcode/)
- [Flutter GitHub](https://github.com/flutter/flutter)

## 📞 サポート

問題が発生した場合は、以下の手順で解決を試してください：

1. `flutter doctor` を実行して問題を確認
2. 公式ドキュメントを参照
3. Flutterコミュニティフォーラムで質問
4. GitHub Issuesで報告 