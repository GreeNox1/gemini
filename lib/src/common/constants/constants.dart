class AppConstants {
  const AppConstants._();

  static const String settings = "settings";
  static const String storage = "storage";

  static const String theme = "$settings.theme";
  static const String locale = "$settings.locale";

  static const String videoStorage = "$storage.video";
  static const String appDirectoryStorage = "$storage.app_directory";
  static const String appThumbnailStorage = "$storage.app_thumbnail";

  static const List<String> movies = [
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/CastVideos/dash/SintelVideo.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/CastVideos/dash/TearsOfSteelVideo.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/CastVideos/hls/Sintel.m3u8",
    "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8",
  ];

  static const String aiApiKey = "AIzaSyD0S4W5QJv_OEGqAUfQyjSTDNPFeAMHRcA";
  static const String baseUrl = "";
}
