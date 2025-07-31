// LaravelバックエンドとのAPI通信を管理するクライアント
// Axiosを使用してRESTful APIとの通信を実装
import axios from 'axios';

// ===== API設定 =====

/// APIベースURL
/// 環境変数から取得、デフォルトはlocalhost:8000
const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';

/// Axiosインスタンスの作成
/// デフォルト設定でAPIクライアントを初期化
const api = axios.create({
  baseURL: API_BASE_URL, // APIのベースURL
  headers: {
    'Content-Type': 'application/json', // JSONコンテンツタイプ
    'Accept': 'application/json', // JSONレスポンスを受け入れ
  },
  withCredentials: true, // CSRFトークンとセッションクッキーのために必要
});

// ===== リクエストインターセプター =====

/// CSRFトークンを自動的に追加するリクエストインターセプター
/// LaravelのCSRF保護に対応
api.interceptors.request.use(
  (config) => {
    // メタタグからCSRFトークンを取得（利用可能な場合）
    const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
    if (token) {
      config.headers['X-CSRF-TOKEN'] = token; // CSRFトークンをヘッダーに追加
    }
    return config;
  },
  (error) => {
    return Promise.reject(error); // エラーを再スロー
  }
);

// ===== レスポンスインターセプター =====

/// エラーハンドリング用のレスポンスインターセプター
/// 共通のエラー処理を実装
api.interceptors.response.use(
  (response) => response, // 成功レスポンスはそのまま返す
  (error) => {
    if (error.response?.status === 401) {
      // 認証エラーの処理
      console.error('Unauthorized access'); // 未認証アクセス
      // ログインページにリダイレクトまたはログインモーダルを表示
    } else if (error.response?.status === 422) {
      // バリデーションエラーの処理
      console.error('Validation errors:', error.response.data.errors); // バリデーションエラー
    } else if (error.response?.status >= 500) {
      // サーバーエラーの処理
      console.error('Server error:', error.response.data); // サーバーエラー
    }
    return Promise.reject(error); // エラーを再スロー
  }
);

// ===== API関数群 =====

/// APIクライアントオブジェクト
/// 認証、ユーザー管理、CRUD操作、ファイルアップロードなどの機能を提供
export const apiClient = {
  // ===== 認証関連エンドポイント =====
  auth: {
    /// ユーザーログイン
    /// [credentials] ログイン認証情報（メールアドレス、パスワード）
    login: (credentials: { email: string; password: string }) =>
      api.post('/api/auth/login', credentials),
    
    /// ユーザー登録
    /// [userData] ユーザー登録データ（名前、メール、パスワード、パスワード確認）
    register: (userData: { name: string; email: string; password: string; password_confirmation: string }) =>
      api.post('/api/auth/register', userData),
    
    /// ユーザーログアウト
    logout: () => api.post('/api/auth/logout'),
    
    /// 現在のユーザー情報取得
    user: () => api.get('/api/auth/user'),
    
    /// パスワードリセット要求
    /// [email] リセット対象のメールアドレス
    forgotPassword: (email: string) =>
      api.post('/api/auth/forgot-password', { email }),
    
    /// パスワードリセット実行
    /// [data] リセットデータ（トークン、メール、新しいパスワード、パスワード確認）
    resetPassword: (data: { token: string; email: string; password: string; password_confirmation: string }) =>
      api.post('/api/auth/reset-password', data),
  },

  // ===== ユーザー管理エンドポイント =====
  users: {
    /// ユーザー一覧取得
    /// [params] クエリパラメータ（ページネーション、フィルタリングなど）
    index: (params?: any) => api.get('/api/users', { params }),
    
    /// 特定ユーザー情報取得
    /// [id] ユーザーID
    show: (id: number) => api.get(`/api/users/${id}`),
    
    /// ユーザー作成
    /// [data] ユーザーデータ
    store: (data: any) => api.post('/api/users', data),
    
    /// ユーザー情報更新
    /// [id] ユーザーID、[data] 更新データ
    update: (id: number, data: any) => api.put(`/api/users/${id}`, data),
    
    /// ユーザー削除
    /// [id] 削除対象のユーザーID
    destroy: (id: number) => api.delete(`/api/users/${id}`),
  },

  // ===== 汎用CRUD操作 =====
  crud: {
    /// 一覧取得（汎用）
    /// [endpoint] APIエンドポイント、[params] クエリパラメータ
    index: (endpoint: string, params?: any) => api.get(`/api/${endpoint}`, { params }),
    
    /// 詳細取得（汎用）
    /// [endpoint] APIエンドポイント、[id] レコードID
    show: (endpoint: string, id: number) => api.get(`/api/${endpoint}/${id}`),
    
    /// 作成（汎用）
    /// [endpoint] APIエンドポイント、[data] 作成データ
    store: (endpoint: string, data: any) => api.post(`/api/${endpoint}`, data),
    
    /// 更新（汎用）
    /// [endpoint] APIエンドポイント、[id] レコードID、[data] 更新データ
    update: (endpoint: string, id: number, data: any) => api.put(`/api/${endpoint}/${id}`, data),
    
    /// 削除（汎用）
    /// [endpoint] APIエンドポイント、[id] 削除対象のレコードID
    destroy: (endpoint: string, id: number) => api.delete(`/api/${endpoint}/${id}`),
  },

  // ===== ファイルアップロード =====
  upload: {
    /// ファイルアップロード
    /// [file] アップロードするファイル、[endpoint] アップロードエンドポイント
    file: (file: File, endpoint: string = 'upload') => {
      const formData = new FormData(); // FormDataオブジェクトを作成
      formData.append('file', file); // ファイルを追加
      return api.post(`/api/${endpoint}`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data', // マルチパートフォームデータ
        },
      });
    },
  },

  // ===== システムエンドポイント =====
  
  /// ヘルスチェック
  /// APIの動作状況を確認
  health: () => api.get('/api/health'),
};

// ===== カスタムフック =====

/// API呼び出し用のカスタムフック
/// エラーハンドリングを含むAPI呼び出し関数を提供
export const useApi = () => {
  /// GETリクエスト
  /// [url] リクエストURL、[params] クエリパラメータ
  const get = async (url: string, params?: any) => {
    try {
      const response = await api.get(url, { params });
      return { data: response.data, error: null }; // 成功時
    } catch (error: any) {
      return { data: null, error: error.response?.data || error.message }; // エラー時
    }
  };

  /// POSTリクエスト
  /// [url] リクエストURL、[data] 送信データ
  const post = async (url: string, data?: any) => {
    try {
      const response = await api.post(url, data);
      return { data: response.data, error: null }; // 成功時
    } catch (error: any) {
      return { data: null, error: error.response?.data || error.message }; // エラー時
    }
  };

  /// PUTリクエスト
  /// [url] リクエストURL、[data] 更新データ
  const put = async (url: string, data?: any) => {
    try {
      const response = await api.put(url, data);
      return { data: response.data, error: null }; // 成功時
    } catch (error: any) {
      return { data: null, error: error.response?.data || error.message }; // エラー時
    }
  };

  /// DELETEリクエスト
  /// [url] リクエストURL
  const del = async (url: string) => {
    try {
      const response = await api.delete(url);
      return { data: response.data, error: null }; // 成功時
    } catch (error: any) {
      return { data: null, error: error.response?.data || error.message }; // エラー時
    }
  };

  return { get, post, put, delete: del }; // API関数を返す
};

export default api; // デフォルトエクスポート 