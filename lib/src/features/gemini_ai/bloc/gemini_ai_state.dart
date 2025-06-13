part of 'gemini_ai_bloc.dart';

class GeminiAiState extends Equatable {
  const GeminiAiState({
    this.messages = const [],
    this.status = Status.initial,
    this.audioIndex = -1,
  });

  final List<MessageModel> messages;
  final Status status;
  final int audioIndex;

  GeminiAiState copyWith({
    List<MessageModel>? messages,
    Status? status,
    int? audioIndex,
  }) {
    return GeminiAiState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      audioIndex: audioIndex ?? this.audioIndex,
    );
  }

  @override
  List<Object?> get props => [messages, status, audioIndex];
}
