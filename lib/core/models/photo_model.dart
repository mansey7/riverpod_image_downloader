import 'package:flutter/material.dart';

class Photo extends ChangeNotifier {
  String id;
  String description;
  String url;
  String downloadUrl;
  bool isDownloading = false;

  Photo(
      {required this.id,
      required this.description,
      required this.url,
      required this.downloadUrl,
      bool isDownloading = false});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
        id: json['id'] ?? '',
        description: json['alt_description'] ?? '',
        url: json['urls']['regular'],
        downloadUrl: json['links']['download']);
  }
}
