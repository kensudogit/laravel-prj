# Laravel Development Environment

## 開発環境仕様
- **Backend**:
  - **PHP**: 8.2以上
  - **Laravel**: 11.x
  - **Database**: MySQL 8.0 / MariaDB 10.11
  - **Web Server**: Apache 2.4
  - **OS**: Amazon Linux 2023 (EC2)
- **Frontend**:
  - **React**: 18.2.0
  - **Next.js**: 14.0.0
  - **TypeScript**: 5.0.0
  - **Tailwind CSS**: 3.3.0
  - **Node.js**: 18.x以上
- **Mobile**:
  - **Flutter**: 3.16.0+
  - **Dart**: 3.2.0+
  - **Riverpod**: 2.4.9 (状態管理)
  - **Go Router**: 12.1.3 (ナビゲーション)

## セットアップ手順

### 1. EC2インスタンスの準備
```bash
# Amazon Linux 2023 AMIを使用
# インスタンスタイプ: t3.micro以上推奨
# セキュリティグループ: SSH(22), HTTP(80), HTTPS(443), MySQL(3306)
```

### 2. システムパッケージのインストール
```bash
# システムアップデート
sudo yum update -y

# PHP 8.2と必要な拡張機能のインストール
sudo yum install -y php82 php82-cli php82-common php82-mysqlnd php82-zip php82-gd php82-mbstring php82-curl php82-xml php82-bcmath php82-json php82-opcache php82-intl

# Apache インストール
sudo yum install -y httpd

# MySQL 8.0 インストール
sudo yum install -y mysql mysql-server

# Composer インストール
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
```

### 3. Laravel プロジェクトの作成
```bash
# プロジェクトディレクトリに移動
cd /var/www/html

# Laravel 11 プロジェクトを作成
composer create-project laravel/laravel laravel-app

# 権限設定
sudo chown -R apache:apache /var/www/html/laravel-app
sudo chmod -R 755 /var/www/html/laravel-app
sudo chmod -R 777 /var/www/html/laravel-app/storage
sudo chmod -R 777 /var/www/html/laravel-app/bootstrap/cache
```

### 4. Next.js フロントエンドのセットアップ
```bash
# Node.js 18+ のインストール
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# フロントエンドディレクトリの作成
mkdir -p /var/www/frontend
cd /var/www/frontend

# Next.js プロジェクトの作成
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --yes

# 依存関係のインストール
npm install

# 開発サーバーの起動
npm run dev
```

### 5. Apache設定
```bash
# 仮想ホスト設定
sudo nano /etc/httpd/conf.d/laravel.conf
```

### 6. MySQL設定
```bash
# MySQLサービス開始
sudo systemctl start mysqld
sudo systemctl enable mysqld

# セキュリティ設定
sudo mysql_secure_installation

# データベース作成
mysql -u root -p
CREATE DATABASE laravel_app;
CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON laravel_app.* TO 'laravel_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 7. Laravel環境設定
```bash
# 環境設定ファイルのコピー
cp .env.example .env

# アプリケーションキーの生成
php artisan key:generate

# データベース設定の編集
nano .env
```

### 8. サービス開始
```bash
# Apache開始
sudo systemctl start httpd
sudo systemctl enable httpd

# MySQL開始
sudo systemctl start mysqld
sudo systemctl enable mysqld
```

## 開発用ツール

### Docker環境（推奨）
Dockerを使用した開発環境も提供しています：
```bash
# Docker環境の起動
docker-compose up -d

# Laravelプロジェクトの作成
docker-compose exec app composer create-project laravel/laravel .

# Next.jsフロントエンドのアクセス
# フロントエンドは自動的に http://localhost:3000 で利用可能
```

### フロントエンド専用セットアップ
```bash
# フロントエンドのみをセットアップ
chmod +x scripts/setup-frontend.sh
./scripts/setup-frontend.sh
```

### モバイル専用セットアップ
```bash
# モバイルアプリのみをセットアップ
chmod +x scripts/setup-mobile.sh
./scripts/setup-mobile.sh
```

### 完全なモバイル開発環境セットアップ
```bash
# Flutter SDK、Android Studio、エミュレーター、アプリの完全セットアップ
chmod +x scripts/setup-complete-mobile.sh
./scripts/setup-complete-mobile.sh
```

### モバイル開発用スクリプト
```bash
# Flutter SDKインストール
chmod +x scripts/install-flutter.sh
./scripts/install-flutter.sh

# Android Studioセットアップ
chmod +x scripts/setup-android-studio.sh
./scripts/setup-android-studio.sh

# エミュレーターセットアップ
chmod +x scripts/setup-emulator.sh
./scripts/setup-emulator.sh

# モバイルアプリ実行
chmod +x scripts/run-mobile-app.sh
./scripts/run-mobile-app.sh
```

## トラブルシューティング

### よくある問題
1. **権限エラー**: `storage`と`bootstrap/cache`ディレクトリの権限を確認
2. **データベース接続エラー**: `.env`ファイルの設定を確認
3. **Composerエラー**: PHP拡張機能が不足している可能性

### ログ確認
```bash
# Apacheログ
sudo tail -f /var/log/httpd/error_log

# Laravelログ
tail -f storage/logs/laravel.log
```

## 開発ワークフロー

1. コードの変更
2. テストの実行: `php artisan test`
3. マイグレーション: `php artisan migrate`
4. キャッシュクリア: `php artisan cache:clear`

## 本番環境へのデプロイ

本番環境では以下の点に注意：
- 環境変数の適切な設定
- セキュリティ設定の強化
- パフォーマンス最適化
- バックアップ戦略の実装 "# laravel-prj" 
