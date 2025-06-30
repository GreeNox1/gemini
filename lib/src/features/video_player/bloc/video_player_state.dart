part of 'video_player_bloc.dart';

class VideoPlayerState extends Equatable {
  const VideoPlayerState({
    this.status = Status.initial,
    this.videos = const [],
    this.progress = 0,
    this.download = Download.start,
    this.videoIndex = -1,
    this.isDownload = true,
    this.checkPermission = false,
  });

  final Status status;
  final List<VideoModel> videos;
  final double progress;
  final Download download;
  final int videoIndex;
  final bool isDownload;
  final bool checkPermission;

  VideoPlayerState copyWith({
    Status? status,
    List<VideoModel>? videos,
    double? progress,
    Download? download,
    int? videoIndex,
    bool? isDownload,
    bool? checkPermission,
  }) {
    return VideoPlayerState(
      status: status ?? this.status,
      videos: videos ?? this.videos,
      progress: progress ?? this.progress,
      download: download ?? this.download,
      videoIndex: videoIndex ?? this.videoIndex,
      isDownload: isDownload ?? this.isDownload,
      checkPermission: checkPermission ?? this.checkPermission,
    );
  }

  @override
  List<Object?> get props => [
    status,
    videos,
    progress,
    download,
    videoIndex,
    isDownload,
    checkPermission,
  ];
}
