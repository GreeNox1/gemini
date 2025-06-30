part of 'video_player_bloc.dart';

sealed class VideoPlayerEvent {
  const VideoPlayerEvent();
}

class CheckPermission$VideoPlayerEvent extends VideoPlayerEvent {
  const CheckPermission$VideoPlayerEvent({required this.context});

  final BuildContext context;
}

class GetVideoAll$VideoPlayerEvent extends VideoPlayerEvent {
  const GetVideoAll$VideoPlayerEvent({required this.context});

  final BuildContext context;
}

class UpdateVideo$VideoPlayerEvent extends VideoPlayerEvent {
  const UpdateVideo$VideoPlayerEvent({required this.context});

  final BuildContext context;
}

class DownloadVideo$VideoPlayerEvent extends VideoPlayerEvent {
  const DownloadVideo$VideoPlayerEvent({
    required this.context,
    required this.url,
    required this.index,
  });

  final BuildContext context;
  final String url;
  final int index;
}

class DownloadVideoInProgress$VideoPlayerEvent extends VideoPlayerEvent {
  const DownloadVideoInProgress$VideoPlayerEvent({
    required this.context,
    required this.percent,
  });

  final BuildContext context;
  final double percent;
}

class DeleteVideo$VideoPlayerEvent extends VideoPlayerEvent {
  const DeleteVideo$VideoPlayerEvent({
    required this.context,
    required this.path,
  });

  final BuildContext context;
  final String path;
}

class PauseVideo$VideoPlayerEvent extends VideoPlayerEvent {
  const PauseVideo$VideoPlayerEvent({required this.context});

  final BuildContext context;
}
