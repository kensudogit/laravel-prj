// アプリケーションのテーマ設定ファイル
// Material 3デザインシステムに基づいたライトテーマとダークテーマを定義
import 'package:flutter/material.dart';

/// アプリケーションのテーマ設定クラス
/// ライトテーマとダークテーマの両方を提供し、一貫したデザインシステムを実現
class AppTheme {
  // ===== カラーパレット定義 =====
  
  /// プライマリカラー（メインカラー）
  static const Color primaryColor = Color(0xFF2563EB);
  /// プライマリカラーの明るいバリエーション
  static const Color primaryLightColor = Color(0xFF3B82F6);
  /// プライマリカラーの暗いバリエーション
  static const Color primaryDarkColor = Color(0xFF1D4ED8);
  
  /// セカンダリカラー（補助カラー）
  static const Color secondaryColor = Color(0xFF64748B);
  /// セカンダリカラーの明るいバリエーション
  static const Color secondaryLightColor = Color(0xFF94A3B8);
  /// セカンダリカラーの暗いバリエーション
  static const Color secondaryDarkColor = Color(0xFF475569);
  
  /// 背景色
  static const Color backgroundColor = Color(0xFFF8FAFC);
  /// 表面色（カードやボタンの背景）
  static const Color surfaceColor = Color(0xFFFFFFFF);
  /// エラー色
  static const Color errorColor = Color(0xFFEF4444);
  /// 成功色
  static const Color successColor = Color(0xFF10B981);
  /// 警告色
  static const Color warningColor = Color(0xFFF59E0B);

  // ===== ライトテーマ =====
  
  /// ライトテーマの設定
  /// 明るく清潔感のあるデザインで、読みやすさを重視
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true, // Material 3デザインシステムを使用
      brightness: Brightness.light, // 明るいテーマ
      colorScheme: const ColorScheme.light(
        primary: primaryColor, // プライマリカラー
        secondary: secondaryColor, // セカンダリカラー
        surface: surfaceColor, // 表面色
        background: backgroundColor, // 背景色
        error: errorColor, // エラー色
        onPrimary: Colors.white, // プライマリカラー上のテキスト色
        onSecondary: Colors.white, // セカンダリカラー上のテキスト色
        onSurface: Color(0xFF1E293B), // 表面色上のテキスト色
        onBackground: Color(0xFF1E293B), // 背景色上のテキスト色
        onError: Colors.white, // エラー色上のテキスト色
      ),
      fontFamily: 'Inter', // Interフォントファミリーを使用
      
      // アプリバーのテーマ設定
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor, // アプリバーの背景色
        foregroundColor: Color(0xFF1E293B), // アプリバーの前景色（アイコン、テキスト）
        elevation: 0, // 影なし
        centerTitle: true, // タイトルを中央揃え
        titleTextStyle: TextStyle(
          fontSize: 18, // タイトルフォントサイズ
          fontWeight: FontWeight.w600, // タイトルフォントウェイト
          color: Color(0xFF1E293B), // タイトル色
        ),
      ),
      
      // カードのテーマ設定
      cardTheme: CardTheme(
        color: surfaceColor, // カードの背景色
        elevation: 2, // カードの影
        shadowColor: Colors.black.withOpacity(0.1), // 影の色
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 角丸
        ),
      ),
      
      // ボタンのテーマ設定
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, // ボタンの背景色
          foregroundColor: Colors.white, // ボタンのテキスト色
          elevation: 0, // 影なし
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // パディング
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 角丸
          ),
          textStyle: const TextStyle(
            fontSize: 16, // フォントサイズ
            fontWeight: FontWeight.w600, // フォントウェイト
          ),
        ),
      ),
      
      // 入力フィールドのテーマ設定
      inputDecorationTheme: InputDecorationTheme(
        filled: true, // 背景色を塗りつぶし
        fillColor: Colors.grey.shade50, // 背景色
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // 角丸
          borderSide: BorderSide(color: Colors.grey.shade300), // ボーダー色
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // 角丸
          borderSide: BorderSide(color: Colors.grey.shade300), // 有効時のボーダー色
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // 角丸
          borderSide: const BorderSide(color: primaryColor, width: 2), // フォーカス時のボーダー色
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // 角丸
          borderSide: const BorderSide(color: errorColor), // エラー時のボーダー色
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 内部パディング
      ),
    );
  }

  // ===== ダークテーマ =====
  
  /// ダークテーマの設定
  /// 目に優しく、夜間使用に適したデザイン
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true, // Material 3デザインシステムを使用
      brightness: Brightness.dark, // 暗いテーマ
      colorScheme: const ColorScheme.dark(
        primary: primaryLightColor, // プライマリカラー（明るいバリエーション）
        secondary: secondaryLightColor, // セカンダリカラー（明るいバリエーション）
        surface: Color(0xFF1E293B), // 表面色（暗いグレー）
        background: Color(0xFF0F172A), // 背景色（より暗いグレー）
        error: errorColor, // エラー色
        onPrimary: Colors.white, // プライマリカラー上のテキスト色
        onSecondary: Colors.white, // セカンダリカラー上のテキスト色
        onSurface: Colors.white, // 表面色上のテキスト色
        onBackground: Colors.white, // 背景色上のテキスト色
        onError: Colors.white, // エラー色上のテキスト色
      ),
      fontFamily: 'Inter', // Interフォントファミリーを使用
      
      // アプリバーのテーマ設定（ダークテーマ）
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E293B), // アプリバーの背景色（暗いグレー）
        foregroundColor: Colors.white, // アプリバーの前景色（白）
        elevation: 0, // 影なし
        centerTitle: true, // タイトルを中央揃え
        titleTextStyle: TextStyle(
          fontSize: 18, // タイトルフォントサイズ
          fontWeight: FontWeight.w600, // タイトルフォントウェイト
          color: Colors.white, // タイトル色（白）
        ),
      ),
      
      // カードのテーマ設定（ダークテーマ）
      cardTheme: CardTheme(
        color: const Color(0xFF1E293B), // カードの背景色（暗いグレー）
        elevation: 2, // カードの影
        shadowColor: Colors.black.withOpacity(0.3), // 影の色（より濃い）
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // 角丸
        ),
      ),
      
      // ボタンのテーマ設定（ダークテーマ）
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLightColor, // ボタンの背景色（明るいプライマリ）
          foregroundColor: Colors.white, // ボタンのテキスト色（白）
          elevation: 0, // 影なし
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // パディング
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 角丸
          ),
          textStyle: const TextStyle(
            fontSize: 16, // フォントサイズ
            fontWeight: FontWeight.w600, // フォントウェイト
          ),
        ),
      ),
      
      // 入力フィールドのテーマ設定（ダークテーマ）
      inputDecorationTheme: InputDecorationTheme(
        filled: true, // 背景色を塗りつぶし
        fillColor: const Color(0xFF334155), // 背景色（暗いグレー）
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // 角丸
          borderSide: const BorderSide(color: Color(0xFF475569)), // ボーダー色
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // 角丸
          borderSide: const BorderSide(color: Color(0xFF475569)), // 有効時のボーダー色
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // 角丸
          borderSide: const BorderSide(color: primaryLightColor, width: 2), // フォーカス時のボーダー色
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // 角丸
          borderSide: const BorderSide(color: errorColor), // エラー時のボーダー色
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 内部パディング
      ),
    );
  }
} 