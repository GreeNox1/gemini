part of "gemini_ai_bloc.dart";

sealed class GeminiAiEvent {
  const GeminiAiEvent();
}

final class SendMessage$GeminiAiEvent extends GeminiAiEvent {
  const SendMessage$GeminiAiEvent({required this.context, required this.text});

  final BuildContext context;
  final String text;
}

final class AddMessage$GeminiAiEvent extends GeminiAiEvent {
  const AddMessage$GeminiAiEvent({required this.context, required this.text});

  final BuildContext context;
  final String text;
}

final class AudioIndex$GeminiAiEvent extends GeminiAiEvent {
  const AudioIndex$GeminiAiEvent({required this.audioIndex});

  final int audioIndex;
}
