import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Generic methods
  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Remove data
  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // Clear all data
  static Future<bool> clear() async {
    return await _prefs.clear();
  }

  // Check if key exists
  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // Auth related methods
  static Future<bool> setAuthToken(String token) async {
    return await setString('auth_token', token);
  }

  static String? getAuthToken() {
    return getString('auth_token');
  }

  static Future<bool> removeAuthToken() async {
    return await remove('auth_token');
  }

  static Future<bool> setUserId(String userId) async {
    return await setString('user_id', userId);
  }

  static String? getUserId() {
    return getString('user_id');
  }

  static Future<bool> setUserEmail(String email) async {
    return await setString('user_email', email);
  }

  static String? getUserEmail() {
    return getString('user_email');
  }

  // App settings
  static Future<bool> setThemeMode(String theme) async {
    return await setString('theme_mode', theme);
  }

  static String? getThemeMode() {
    return getString('theme_mode');
  }

  static Future<bool> setLanguage(String language) async {
    return await setString('app_language', language);
  }

  static String? getLanguage() {
    return getString('app_language');
  }

  // First launch flag
  static Future<bool> setFirstLaunch(bool isFirstLaunch) async {
    return await setBool('first_launch', isFirstLaunch);
  }

  static bool? isFirstLaunch() {
    return getBool('first_launch') ?? true;
  }

  // Cart and user data
  static Future<bool> setCartItems(List<String> cartItems) async {
    return await setStringList('cart_items', cartItems);
  }

  static List<String>? getCartItems() {
    return getStringList('cart_items');
  }

  static Future<bool> setWishlistItems(List<String> wishlistItems) async {
    return await setStringList('wishlist_items', wishlistItems);
  }

  static List<String>? getWishlistItems() {
    return getStringList('wishlist_items');
  }

  // User preferences
  static Future<bool> setNotificationEnabled(bool enabled) async {
    return await setBool('notifications_enabled', enabled);
  }

  static bool? isNotificationEnabled() {
    return getBool('notifications_enabled') ?? true;
  }

  // Clear user data (on logout)
  static Future<void> clearUserData() async {
    await removeAuthToken();
    await remove('user_id');
    await remove('user_email');
    await remove('cart_items');
    await remove('wishlist_items');
  }
}