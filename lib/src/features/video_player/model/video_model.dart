import 'dart:convert';

import 'package:flutter/foundation.dart';

List<VideoModel> fromJsonVideoModel(String data) {
  return List.from(
    (jsonDecode(data) as List<Object?>).map(
      (e) => VideoModel.fromJson(e as Map<String, Object?>),
    ),
  );
}

String toJsonVideoModel(List<VideoModel> data) {
  return jsonEncode(data.map((e) => e.toJson()).toList());
}

class VideoModel {
  VideoModel({required this.fileName, required this.videos});

  String fileName;
  List<VideoDataModel> videos;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is VideoModel &&
            runtimeType == other.runtimeType &&
            fileName == other.fileName &&
            listEquals(videos, other.videos);
  }

  factory VideoModel.fromJson(Map<String, Object?> json) {
    return VideoModel(
      fileName: json['file_name'] as String,
      videos: List.from(
        (json['videos'] as List<Object?>).map(
          (e) => VideoDataModel.fromJson(e as Map<String, Object?>),
        ),
      ),
    );
  }

  Map<String, Object> toJson() {
    return {
      'file_name': fileName,
      'videos': List.from(videos.map((e) => e.toJson())),
    };
  }

  @override
  int get hashCode => Object.hashAll([fileName, ...videos]);

  @override
  String toString() {
    return "VideoModel(fileName: $fileName, Videos: $videos)";
  }
}

class VideoDataModel {
  VideoDataModel({
    required this.text,
    required this.uint8list,
    required this.duration,
    this.urlVideo,
  });

  String text;
  Uint8List uint8list;
  Duration duration;
  String? urlVideo;

  factory VideoDataModel.fromJson(Map<String, Object?> json) {
    return VideoDataModel(
      text: json['text'] as String,
      urlVideo: json['url_video'] as String?,
      uint8list: base64Decode(json['uint8list'] as String),
      duration: Duration(milliseconds: json['duration'] as int),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'text': text,
      'uint8list': base64Encode(uint8list),
      'duration': duration.inMilliseconds,
      'url_video': urlVideo,
    };
  }

  @override
  int get hashCode => Object.hashAll([text, ...uint8list, duration, urlVideo]);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is VideoDataModel &&
            runtimeType == other.runtimeType &&
            text == other.text &&
            duration == other.duration &&
            urlVideo == other.urlVideo &&
            listEquals(uint8list, other.uint8list);
  }

  @override
  String toString() {
    return "VideoDataModel(text: $text, uint8list: $uint8list, duration: $duration, urlVideo: $urlVideo)";
  }
}
