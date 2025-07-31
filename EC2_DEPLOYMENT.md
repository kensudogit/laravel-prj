# EC2 Laravel Deployment Guide

## 前提条件
- AWSアカウント
- EC2インスタンス（Amazon Linux 2023）
- セキュリティグループの設定

## EC2インスタンスの準備

### 1. インスタンスの作成
```bash
# Amazon Linux 2023 AMIを選択
# インスタンスタイプ: t3.micro以上推奨
# ストレージ: 20GB以上推奨
```

### 2. セキュリティグループの設定
以下のポートを開放：
- **SSH (22)**: サーバーアクセス用
- **HTTP (80)**: Webアクセス用
- **HTTPS (443)**: SSL通信用
- **MySQL (3306)**: データベースアクセス用（必要に応じて）

### 3. キーペアの設定
```bash
# SSHキーを使用してサーバーに接続
ssh -i your-key.pem ec2-user@your-ec2-public-ip
```

## 自動セットアップ

### 1. セットアップスクリプトの実行
```bash
# スクリプトをダウンロード
wget https://raw.githubusercontent.com/your-repo/laravel-prj/main/scripts/setup-ec2.sh

# 実行権限を付与
chmod +x setup-ec2.sh

# スクリプトを実行
./setup-ec2.sh
```

### 2. 手動セットアップ（推奨）

#### システムアップデート
```bash
sudo yum update -y
```

#### PHP 8.2のインストール
```bash
# EPELリポジトリの追加
sudo yum install -y epel-release

# PHP 8.2と拡張機能のインストール
sudo yum install -y \
    php82 \
    php82-cli \
    php82-common \
    php82-mysqlnd \
    php82-zip \
    php82-gd \
    php82-mbstring \
    php82-curl \
    php82-xml \
    php82-bcmath \
    php82-json \
    php82-opcache \
    php82-intl \
    php82-fpm
```

#### Apacheのインストールと設定
```bash
# Apacheのインストール
sudo yum install -y httpd mod_ssl

# Apacheの開始と自動起動設定
sudo systemctl start httpd
sudo systemctl enable httpd

# ファイアウォールの設定
sudo yum install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

#### MySQL 8.0のインストールと設定
```bash
# MySQLのインストール
sudo yum install -y mysql mysql-server

# MySQLの開始と自動起動設定
sudo systemctl start mysqld
sudo systemctl enable mysqld

# セキュリティ設定
sudo mysql_secure_installation

# データベースとユーザーの作成
mysql -u root -p
```

MySQLプロンプトで以下を実行：
```sql
CREATE DATABASE laravel_app CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON laravel_app.* TO 'laravel_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

#### Composerのインストール
```bash
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
```

#### Laravelプロジェクトの作成
```bash
# プロジェクトディレクトリの作成
sudo mkdir -p /var/www/html
cd /var/www/html

# Laravel 11プロジェクトの作成
composer create-project laravel/laravel laravel-app

# 権限の設定
sudo chown -R apache:apache /var/www/html/laravel-app
sudo chmod -R 755 /var/www/html/laravel-app
sudo chmod -R 777 /var/www/html/laravel-app/storage
sudo chmod -R 777 /var/www/html/laravel-app/bootstrap/cache
```

#### Apache設定ファイルの配置
```bash
# 設定ファイルをコピー
sudo cp /var/www/html/laravel-app/apache/laravel.conf /etc/httpd/conf.d/

# Apacheの再起動
sudo systemctl restart httpd
```

#### Laravel環境設定
```bash
cd /var/www/html/laravel-app

# 環境設定ファイルのコピー
cp .env.example .env

# アプリケーションキーの生成
php artisan key:generate

# データベース設定の編集
sudo nano .env
```

`.env`ファイルで以下を設定：
```env
DB_HOST=localhost
DB_DATABASE=laravel_app
DB_USERNAME=laravel_user
DB_PASSWORD=your_secure_password
```

#### マイグレーションの実行
```bash
php artisan migrate
```

#### Node.jsとNPMのインストール（フロントエンドアセット用）
```bash
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# 依存関係のインストール
npm install

# アセットのビルド
npm run build
```

## SSL証明書の設定（オプション）

### Let's Encryptを使用したSSL設定
```bash
# Certbotのインストール
sudo yum install -y certbot python3-certbot-apache

# SSL証明書の取得
sudo certbot --apache -d your-domain.com

# 自動更新の設定
sudo crontab -e
```

crontabに以下を追加：
```
0 12 * * * /usr/bin/certbot renew --quiet
```

## パフォーマンス最適化

### OPcacheの設定
```bash
sudo nano /etc/php.ini
```

以下を追加/変更：
```ini
opcache.enable=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=2
opcache.fast_shutdown=1
```

### Apache MPM設定
```bash
sudo nano /etc/httpd/conf.modules.d/00-mpm.conf
```

## 監視とログ

### ログの確認
```bash
# Apacheログ
sudo tail -f /var/log/httpd/error_log
sudo tail -f /var/log/httpd/access_log

# Laravelログ
tail -f /var/www/html/laravel-app/storage/logs/laravel.log

# MySQLログ
sudo tail -f /var/log/mysqld.log
```

### システム監視
```bash
# システムリソースの確認
htop
df -h
free -h

# サービスステータスの確認
sudo systemctl status httpd
sudo systemctl status mysqld
```

## バックアップ戦略

### データベースバックアップ
```bash
# バックアップスクリプトの作成
sudo nano /usr/local/bin/backup-db.sh
```

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/mysql"
mkdir -p $BACKUP_DIR

mysqldump -u laravel_user -p laravel_app > $BACKUP_DIR/laravel_app_$DATE.sql
gzip $BACKUP_DIR/laravel_app_$DATE.sql

# 古いバックアップの削除（30日以上）
find $BACKUP_DIR -name "*.sql.gz" -mtime +30 -delete
```

```bash
# 実行権限の付与
sudo chmod +x /usr/local/bin/backup-db.sh

# cronに追加（毎日午前2時に実行）
sudo crontab -e
```

```
0 2 * * * /usr/local/bin/backup-db.sh
```

## トラブルシューティング

### よくある問題と解決方法

1. **権限エラー**
   ```bash
   sudo chown -R apache:apache /var/www/html/laravel-app
   sudo chmod -R 755 /var/www/html/laravel-app
   ```

2. **データベース接続エラー**
   - `.env`ファイルの設定を確認
   - MySQLサービスの状態を確認
   - ファイアウォール設定を確認

3. **Composerエラー**
   - PHP拡張機能の不足を確認
   - メモリ制限の調整

4. **Apache設定エラー**
   ```bash
   sudo apachectl configtest
   sudo systemctl status httpd
   ```

## セキュリティ強化

### ファイアウォール設定
```bash
# 不要なポートの閉鎖
sudo firewall-cmd --permanent --remove-service=dhcpv6-client
sudo firewall-cmd --reload
```

### ファイル権限の最適化
```bash
# 設定ファイルの保護
sudo chmod 644 /var/www/html/laravel-app/.env
sudo chown root:root /var/www/html/laravel-app/.env
```

### 定期的なセキュリティアップデート
```bash
# 自動アップデートの設定
sudo yum install -y yum-cron
sudo systemctl enable yum-cron
sudo systemctl start yum-cron
``` 