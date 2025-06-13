import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:udevs/src/common/style/app_size.dart';
import 'package:udevs/src/common/utils/extension/context_extension.dart';
import 'package:udevs/src/features/gemini_ai/bloc/gemini_ai_bloc.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({
    super.key,
    required this.text,
    required this.isPlay,
    this.audioIndex = -1,
    this.isUser = true,
  });

  final String text;
  final bool isUser;
  final bool isPlay;
  final int audioIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isUser) Expanded(child: SizedBox()),
        Expanded(
          flex: 3,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color:
                  isUser
                      ? context.colors.inversePrimary
                      : context.colors.outline,
              borderRadius: AppSize.borderRadiusAll15,
            ),
            child: Padding(
              padding: AppSize.paddingAll10,
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    isUser ? context.lang.you : context.lang.gemini,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(text, style: context.textTheme.bodyMedium),
                  if (!isUser)
                    isPlay
                        ? Row(
                          children: [
                            Expanded(child: SizedBox()),
                            IconButton(
                              onPressed: () async {
                                context.read<GeminiAiBloc>().add(
                                  AudioIndex$GeminiAiEvent(
                                    audioIndex: audioIndex,
                                  ),
                                );

                                FlutterTts flutterTts = FlutterTts();
                                await flutterTts.setVolume(1);
                                await flutterTts.setPitch(1);
                                await flutterTts.setSpeechRate(0.5);
                                await flutterTts.setLanguage("en-US");
                                await flutterTts.speak(text, focus: true);

                                flutterTts.setCompletionHandler(
                                  () {
                                        context.read<GeminiAiBloc>().add(
                                          AudioIndex$GeminiAiEvent(
                                            audioIndex: audioIndex,
                                          ),
                                        );
                                      }
                                      as VoidCallback,
                                );
                              },
                              icon: Icon(Icons.multitrack_audio),
                            ),
                          ],
                        )
                        : Row(
                          children: [
                            Expanded(child: SizedBox()),
                            IconButton(
                              onPressed: () async {
                                context.read<GeminiAiBloc>().add(
                                  AudioIndex$GeminiAiEvent(
                                    audioIndex: audioIndex,
                                  ),
                                );

                                FlutterTts flutterTts = FlutterTts();
                                await flutterTts.pause();
                              },
                              icon: Icon(Icons.pause),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
        if (!isUser) Expanded(child: SizedBox()),
      ],
    );
  }
}
