part of 'video_player_bloc.dart';

class VideoPlayerState extends Equatable {
  const VideoPlayerState({
    this.status = Status.initial,
    this.videos = const [],
    this.progress = 0,
    this.download = Download.start,
    this.videoIndex = -1,
    this.isDownload = true,
  });

  final Status status;
  final List<VideoModel> videos;
  final int progress;
  final Download download;
  final int videoIndex;
  final bool isDownload;

  VideoPlayerState copyWith({
    Status? status,
    List<VideoModel>? videos,
    int? progress,
    Download? download,
    int? videoIndex,
    bool? isDownload,
  }) {
    return VideoPlayerState(
      status: status ?? this.status,
      videos: videos ?? this.videos,
      progress: progress ?? this.progress,
      download: download ?? this.download,
      videoIndex: videoIndex ?? this.videoIndex,
      isDownload: isDownload ?? this.isDownload,
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
  ];
}
