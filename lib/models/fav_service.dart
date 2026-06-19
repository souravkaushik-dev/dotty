import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String key = "favorite_wallpapers";

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getStringList(key) ?? [];

    return data.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<void> toggleFavorite({
    required String imageUrl,
    required String category,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final favorites = prefs.getStringList(key) ?? [];

    final exists = favorites.any((e) {
      final item = jsonDecode(e);

      return item['imageUrl'] == imageUrl;
    });

    if (exists) {
      favorites.removeWhere((e) {
        final item = jsonDecode(e);

        return item['imageUrl'] == imageUrl;
      });
    } else {
      favorites.add(jsonEncode({"imageUrl": imageUrl, "category": category}));
    }

    await prefs.setStringList(key, favorites);
  }

  static Future<bool> isFavorite(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();

    final favorites = prefs.getStringList(key) ?? [];

    return favorites.any((e) {
      final item = jsonDecode(e);

      return item['imageUrl'] == imageUrl;
    });
  }
}
