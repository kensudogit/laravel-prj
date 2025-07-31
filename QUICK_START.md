# Laravel Development Environment - Quick Start

## 🚀 クイックスタート

### オプション1: Docker環境（推奨）

#### 前提条件
- Docker
- Docker Compose

#### セットアップ手順
```bash
# 1. プロジェクトディレクトリに移動
cd devlop/laravel-prj

# 2. Docker環境のセットアップ
chmod +x scripts/setup-docker.sh
./scripts/setup-docker.sh
```

#### アクセス情報
- **Laravelアプリ**: http://localhost:8000
- **Next.jsフロントエンド**: http://localhost:3000
- **phpMyAdmin**: http://localhost:8080
- **MySQL**: localhost:3306

### オプション2: EC2環境

#### 前提条件
- AWS EC2インスタンス（Amazon Linux 2023）
- SSHアクセス

#### セットアップ手順
```bash
# 1. EC2にSSH接続
ssh -i your-key.pem ec2-user@your-ec2-public-ip

# 2. セットアップスクリプトの実行
chmod +x scripts/setup-ec2.sh
./scripts/setup-ec2.sh
```

#### アクセス情報
- **Laravelアプリ**: http://your-ec2-public-ip
- **MySQL**: localhost:3306

## 📋 環境仕様

| コンポーネント | バージョン | 説明 |
|---------------|-----------|------|
| **Backend** | | |
| PHP | 8.2+ | Webアプリケーション言語 |
| Laravel | 11.x | PHPフレームワーク |
| MySQL | 8.0 | リレーショナルデータベース |
| Apache | 2.4 | Webサーバー |
| Composer | Latest | PHP依存関係管理 |
| **Frontend** | | |
| React | 18.2.0 | UIライブラリ |
| Next.js | 14.0.0 | Reactフレームワーク |
| TypeScript | 5.0.0 | 型安全なJavaScript |
| Tailwind CSS | 3.3.0 | CSSフレームワーク |
| Node.js | 18.x | JavaScript実行環境 |
| **Mobile** | | |
| Flutter | 3.16.0+ | クロスプラットフォームフレームワーク |
| Dart | 3.2.0+ | プログラミング言語 |
| Riverpod | 2.4.9 | 状態管理 |
| Go Router | 12.1.3 | ナビゲーション |

## 🛠️ 開発コマンド

### Docker環境
```bash
# コンテナの起動
docker-compose up -d

# コンテナの停止
docker-compose down

# ログの確認
docker-compose logs -f

# Laravelコマンドの実行
docker-compose exec app php artisan migrate
docker-compose exec app php artisan make:controller UserController
docker-compose exec app composer install

# Next.jsコマンドの実行
docker-compose exec frontend npm run dev
docker-compose exec frontend npm run build
docker-compose exec frontend npm run lint
```

### EC2環境
```bash
# Laravelコマンド
php artisan migrate
php artisan make:controller UserController
php artisan serve

# Composerコマンド
composer install
composer update

# Next.jsコマンド（フロントエンドディレクトリで実行）
cd /var/www/frontend
npm install
npm run dev
npm run build
npm run lint

# Flutterコマンド（モバイルディレクトリで実行）
cd /var/www/mobile
flutter pub get
flutter run
flutter build apk
flutter test
```

## 📁 プロジェクト構造

```
laravel-prj/
├── README.md                 # メインREADME
├── QUICK_START.md           # クイックスタートガイド
├── EC2_DEPLOYMENT.md        # EC2デプロイメントガイド
├── docker-compose.yml       # Docker設定
├── env.example              # 環境変数サンプル
├── apache/                  # Apache設定
│   └── laravel.conf
├── docker/                  # Docker設定
│   ├── php/
│   │   ├── Dockerfile
│   │   └── local.ini
│   ├── apache/
│   │   └── 000-default.conf
│   └── mysql/
│       └── my.cnf
├── scripts/                 # セットアップスクリプト
│   ├── setup-docker.sh
│   └── setup-ec2.sh
└── src/                     # Laravelアプリケーション（Docker環境）
```

## 🔧 設定ファイル

### データベース設定
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_app
DB_USERNAME=laravel_user
DB_PASSWORD=laravel_password
```

### Docker環境のデータベース設定
```env
DB_HOST=db
DB_DATABASE=laravel_app
DB_USERNAME=laravel_user
DB_PASSWORD=laravel_password
```

## 🚨 トラブルシューティング

### よくある問題

1. **権限エラー**
   ```bash
   # Docker環境
   docker-compose exec app chown -R www-data:www-data /var/www
   
   # EC2環境
   sudo chown -R apache:apache /var/www/html/laravel-app
   ```

2. **データベース接続エラー**
   - `.env`ファイルの設定を確認
   - データベースサービスの状態を確認

3. **Composerエラー**
   - PHP拡張機能の確認
   - メモリ制限の調整

### ログの確認
```bash
# Docker環境
docker-compose logs -f app
docker-compose logs -f webserver
docker-compose logs -f db

# EC2環境
sudo tail -f /var/log/httpd/error_log
tail -f storage/logs/laravel.log
```

## 📚 次のステップ

1. **Laravelの基本を学ぶ**
   - [Laravel公式ドキュメント](https://laravel.com/docs)
   - [Laravel日本語ドキュメント](https://readouble.com/laravel/)

2. **データベース設計**
   - マイグレーションファイルの作成
   - シーダーの設定

3. **認証システム**
   - Laravel Breezeの導入
   - カスタム認証の実装

4. **API開発**
   - APIルートの作成
   - リソースコントローラーの実装

5. **テスト**
   - PHPUnitの設定
   - 機能テストの作成

## 🔗 便利なリンク

- [Laravel公式サイト](https://laravel.com/)
- [Composer公式サイト](https://getcomposer.org/)
- [MySQL公式ドキュメント](https://dev.mysql.com/doc/)
- [Apache公式ドキュメント](https://httpd.apache.org/docs/)
- [Docker公式ドキュメント](https://docs.docker.com/)

## 📞 サポート

問題が発生した場合は、以下の手順で解決を試してください：

1. ログファイルの確認
2. 設定ファイルの見直し
3. 公式ドキュメントの参照
4. コミュニティフォーラムでの質問 