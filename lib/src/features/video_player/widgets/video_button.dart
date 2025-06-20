import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:udevs/src/common/style/app_size.dart';
import 'package:udevs/src/common/utils/extension/context_extension.dart';

import '../../../common/utils/enums/download.dart';

class VideoButton extends StatelessWidget {
  const VideoButton({
    super.key,
    required this.onPressed,
    required this.onPressedDownload,
    required this.onPressedRemove,
    required this.onPressedPause,
    required this.title,
    required this.image,
    required this.duration,
    required this.isDownload,
    required this.download,
    required this.progress,
    required this.isVideoDownload,
    this.videoUrl,
  });

  final void Function() onPressed;
  final void Function() onPressedRemove;
  final void Function() onPressedDownload;
  final void Function() onPressedPause;
  final String title;
  final Uint8List image;
  final Duration duration;
  final bool isDownload;
  final String? videoUrl;
  final Download download;
  final bool isVideoDownload;
  final int progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: AppSize.paddingAll10,
          child: Row(
            spacing: 15,
            children: [
              SizedBox(
                height: 94,
                width: 130,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: AppSize.borderRadiusAll5,
                    color: context.colors.outline,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 94,
                        width: 130,
                        child: ClipRRect(
                          borderRadius: AppSize.borderRadiusAll5,
                          child: Image(
                            image: MemoryImage(image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: AppSize.paddingAll4,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: context.colors.onPrimary,
                              borderRadius: AppSize.borderRadiusAll5,
                            ),
                            child: Padding(
                              padding: AppSize.paddingAll2,
                              child: Text(
                                duration.inHours == 0
                                    ? "${duration.inMinutes % 60 < 10 ? "0${duration.inMinutes % 60}" : duration.inMinutes % 60}:${duration.inSeconds % 60 < 10 ? "0${duration.inSeconds % 60}" : duration.inSeconds % 60}"
                                    : "${duration.inHours}:${duration.inMinutes % 60 < 10 ? "0${duration.inMinutes % 60}" : duration.inMinutes % 60}:${duration.inSeconds % 60 < 10 ? "0${duration.inSeconds % 60}" : duration.inSeconds % 60}",
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.colors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (isVideoDownload && videoUrl != null)
                        SizedBox(
                          height: 94,
                          width: 130,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: context.colors.onPrimaryFixed.withAlpha(
                                140,
                              ),
                              borderRadius: AppSize.borderRadiusAll5,
                            ),
                            child: Center(
                              child:
                                  (download != Download.pause)
                                      ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 10,
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircularProgressIndicator(
                                                value: progress / 100,
                                              ),

                                              Icon(
                                                Icons.download_outlined,
                                                color: context.colors.primary,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "$progress %",
                                            style: context.textTheme.bodyLarge
                                                ?.copyWith(
                                                  color: context.colors.primary,
                                                ),
                                          ),
                                        ],
                                      )
                                      : Icon(
                                        Icons.pause,
                                        color: context.colors.primary,
                                      ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: SizedBox(
                  child: Text(
                    title,
                    style: context.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (videoUrl == null ||
                  isVideoDownload ||
                  download == Download.start)
                PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 1) {
                      onPressedPause();
                    } else if (value == 2) {
                      if (download == Download.start) {
                        onPressedDownload();
                      } else {
                        onPressedPause();
                      }
                    } else if (value == 3) {
                      onPressedRemove();
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<int>>[
                      if (videoUrl != null)
                        isDownload
                            ? const PopupMenuItem<int>(
                              value: 1,
                              child: ListTile(
                                leading: Icon(Icons.pause_circle),
                                title: Text('pause'),
                              ),
                            )
                            : const PopupMenuItem<int>(
                              value: 2,
                              child: ListTile(
                                leading: Icon(Icons.download_outlined),
                                title: Text('Download'),
                              ),
                            ),
                      if (videoUrl == null)
                        const PopupMenuItem<int>(
                          value: 3,
                          child: ListTile(
                            leading: Icon(Icons.delete_outline),
                            title: Text('Remove'),
                          ),
                        ),
                    ];
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
