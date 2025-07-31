# Next.js Frontend

## 🚀 概要

このプロジェクトは、Laravelバックエンドと連携するNext.jsフロントエンドアプリケーションです。

## 📋 技術スタック

- **React**: 18.2.0
- **Next.js**: 14.0.0
- **TypeScript**: 5.0.0
- **Tailwind CSS**: 3.3.0
- **Axios**: 1.6.0
- **Heroicons**: 2.0.0
- **Lucide React**: 0.292.0

## 🛠️ セットアップ

### 前提条件
- Node.js 18.x以上
- npm または yarn

### インストール
```bash
# 依存関係のインストール
npm install

# 環境変数ファイルの作成
cp env.local.example .env.local

# 開発サーバーの起動
npm run dev
```

### Docker環境での実行
```bash
# プロジェクトルートから実行
docker-compose up -d frontend
```

## 📁 プロジェクト構造

```
frontend/
├── src/
│   ├── app/                 # Next.js App Router
│   │   ├── layout.tsx      # ルートレイアウト
│   │   ├── page.tsx        # ホームページ
│   │   └── globals.css     # グローバルスタイル
│   ├── components/         # 再利用可能なコンポーネント
│   │   ├── Button.tsx
│   │   └── Input.tsx
│   ├── lib/               # ユーティリティ関数
│   │   └── api.ts         # API通信ライブラリ
│   ├── types/             # TypeScript型定義
│   ├── hooks/             # カスタムフック
│   └── utils/             # ユーティリティ関数
├── public/                # 静的ファイル
├── package.json           # 依存関係
├── next.config.js         # Next.js設定
├── tailwind.config.js     # Tailwind CSS設定
├── tsconfig.json          # TypeScript設定
└── Dockerfile             # Docker設定
```

## 🔧 設定

### 環境変数
```env
# API設定
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_APP_NAME="Laravel + Next.js App"

# 開発設定
NODE_ENV=development
```

### Next.js設定
- **App Router**: 有効
- **TypeScript**: 有効
- **Tailwind CSS**: 有効
- **ESLint**: 有効
- **Prettier**: 有効

## 🎨 デザインシステム

### カラーパレット
```css
/* Primary Colors */
primary-50: #eff6ff
primary-500: #3b82f6
primary-600: #2563eb
primary-700: #1d4ed8

/* Secondary Colors */
secondary-50: #f8fafc
secondary-500: #64748b
secondary-600: #475569
```

### コンポーネント
- **Button**: プライマリ、セカンダリ、アウトライン、デンジャー
- **Input**: ラベル、エラー、ヘルパーテキスト対応
- **Card**: 標準的なカードコンポーネント

## 🔌 API統合

### APIクライアント
```typescript
import { apiClient } from '@/lib/api';

// 認証
const login = await apiClient.auth.login({ email, password });

// ユーザー取得
const users = await apiClient.users.index();

// 汎用CRUD
const data = await apiClient.crud.index('posts');
```

### エラーハンドリング
- 401: 未認証エラー
- 422: バリデーションエラー
- 500: サーバーエラー

## 📱 レスポンシブデザイン

- **モバイル**: 320px以上
- **タブレット**: 768px以上
- **デスクトップ**: 1024px以上

## 🧪 テスト

```bash
# 型チェック
npm run type-check

# ESLint
npm run lint

# ビルドテスト
npm run build
```

## 🚀 デプロイ

### Vercel
```bash
# Vercel CLIのインストール
npm i -g vercel

# デプロイ
vercel
```

### Docker
```bash
# プロダクションビルド
docker build -t laravel-frontend .

# コンテナ実行
docker run -p 3000:3000 laravel-frontend
```

## 🔄 開発ワークフロー

1. **機能開発**
   ```bash
   # 新しい機能ブランチを作成
   git checkout -b feature/new-feature
   
   # 開発サーバー起動
   npm run dev
   ```

2. **コード品質**
   ```bash
   # リンター実行
   npm run lint
   
   # 型チェック
   npm run type-check
   
   # コードフォーマット
   npx prettier --write .
   ```

3. **テスト**
   ```bash
   # ビルドテスト
   npm run build
   
   # 本番サーバー起動
   npm run start
   ```

## 📚 参考資料

- [Next.js公式ドキュメント](https://nextjs.org/docs)
- [React公式ドキュメント](https://react.dev/)
- [Tailwind CSS公式ドキュメント](https://tailwindcss.com/docs)
- [TypeScript公式ドキュメント](https://www.typescriptlang.org/docs/)

## 🤝 コントリビューション

1. フォークを作成
2. 機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。 