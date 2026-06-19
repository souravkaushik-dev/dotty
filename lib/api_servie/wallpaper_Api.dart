import 'dart:convert';
import 'package:http/http.dart' as http;

class Wallpaper {
  final String id;
  final String image;
  final String title;
  final String subtitle;
  final String category;
  final bool isViewed;
  final DateTime addedAt;

  Wallpaper({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.isViewed,
    required this.addedAt,
  });

  factory Wallpaper.fromJson(
      Map<String, dynamic> json,
      ) {
    return Wallpaper(
      id: json['id']?.toString() ??
          DateTime.now()
              .millisecondsSinceEpoch
              .toString(),

      image: json['image'] ?? '',

      title: json['title'] ?? 'Wallpaper',

      subtitle:
      json['subtitle'] ?? 'Awesome wallpaper',

      category: json['category'] ?? 'Unknown',

      isViewed: json['isViewed'] ?? false,

      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
    );
  }
}