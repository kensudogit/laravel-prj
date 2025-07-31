<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| ここでアプリケーションのAPIルートを登録できます。
| これらのルートはRouteServiceProviderによって読み込まれ、
| すべて"api"ミドルウェアグループに割り当てられます。
| 素晴らしいAPIを作成しましょう！
|
*/

// ===== 認証関連ルート =====

/// 認証済みユーザー情報取得エンドポイント
/// Sanctum認証を使用してログイン中のユーザー情報を返す
Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user(); // 認証済みユーザーの情報を返す
});

// ===== システムエンドポイント =====

/// ヘルスチェックエンドポイント
/// APIの動作状況を確認するために使用
Route::get('/health', function () {
    return response()->json([
        'status' => 'healthy', // ステータス：正常
        'timestamp' => now()->toISOString(), // 現在のタイムスタンプ
        'message' => 'Laravel API is running successfully' // 成功メッセージ
    ]);
});

/// テスト用Helloエンドポイント
/// APIの基本動作確認に使用
Route::get('/hello', function () {
    return response()->json([
        'message' => 'Hello from Laravel API!', // 挨拶メッセージ
        'timestamp' => now()->toISOString(), // 現在のタイムスタンプ
        'version' => '1.0.0' // APIバージョン
    ]);
});

// ===== ユーザー管理エンドポイント =====

/// ユーザー関連のAPIエンドポイント群
/// プレフィックス'users'でグループ化
Route::prefix('users')->group(function () {
    
    /// ユーザー一覧取得エンドポイント
    /// サンプルユーザーデータを返す
    Route::get('/', function () {
        return response()->json([
            'users' => [
                ['id' => 1, 'name' => 'John Doe', 'email' => 'john@example.com'],
                ['id' => 2, 'name' => 'Jane Smith', 'email' => 'jane@example.com'],
            ]
        ]);
    });
    
    /// 特定ユーザー情報取得エンドポイント
    /// 指定されたIDのユーザー情報を返す
    Route::get('/{id}', function ($id) {
        return response()->json([
            'user' => [
                'id' => $id, // ユーザーID
                'name' => 'User ' . $id, // ユーザー名
                'email' => 'user' . $id . '@example.com' // メールアドレス
            ]
        ]);
    });
});

// ===== CORS対応エンドポイント =====

/// CORSミドルウェア適用エンドポイント群
/// フロントエンドからのクロスオリジンリクエストに対応
Route::middleware('cors')->group(function () {
    // ここにAPIルートを追加してください
    // 例：認証、ユーザー管理、データ操作などのエンドポイント
}); 