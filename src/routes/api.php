<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Health check endpoint
Route::get('/health', function () {
    return response()->json([
        'status' => 'healthy',
        'timestamp' => now()->toISOString(),
        'message' => 'Laravel API is running successfully'
    ]);
});

// Hello endpoint for testing
Route::get('/hello', function () {
    return response()->json([
        'message' => 'Hello from Laravel API!',
        'timestamp' => now()->toISOString(),
        'version' => '1.0.0'
    ]);
});

// Sample users API
Route::prefix('users')->group(function () {
    Route::get('/', function () {
        return response()->json([
            'users' => [
                ['id' => 1, 'name' => 'John Doe', 'email' => 'john@example.com'],
                ['id' => 2, 'name' => 'Jane Smith', 'email' => 'jane@example.com'],
            ]
        ]);
    });
    
    Route::get('/{id}', function ($id) {
        return response()->json([
            'user' => [
                'id' => $id,
                'name' => 'User ' . $id,
                'email' => 'user' . $id . '@example.com'
            ]
        ]);
    });
});

// CORS middleware for frontend
Route::middleware('cors')->group(function () {
    // Add your API routes here
}); 