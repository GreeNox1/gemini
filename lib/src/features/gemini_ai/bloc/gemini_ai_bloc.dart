import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../common/model/message_model.dart';
import '../../../common/utils/enums/status.dart';
import '../data/gemini_ai_repository.dart';

part 'gemini_ai_event.dart';
part 'gemini_ai_state.dart';

class GeminiAiBloc extends Bloc<GeminiAiEvent, GeminiAiState> {
  GeminiAiBloc({required final IGeminiAiRepository homeRepository})
    : _homeRepository = homeRepository,
      super(const GeminiAiState()) {
    on<GeminiAiEvent>(
      (event, emit) => switch (event) {
        SendMessage$GeminiAiEvent _ => _sendMessage(event, emit),
        AddMessage$GeminiAiEvent _ => _addMessage(event, emit),
        AudioIndex$GeminiAiEvent _ => _audio(event, emit),
      },
    );
  }

  final IGeminiAiRepository _homeRepository;

  Future<void> _sendMessage(
    SendMessage$GeminiAiEvent event,
    Emitter<GeminiAiState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      List<MessageModel> messages = [...state.messages];

      final response = await _homeRepository.sendMessage(event.text);

      messages.add(response);

      emit(state.copyWith(status: Status.success, messages: messages));
    } on Object catch (_) {
      emit(state.copyWith(status: Status.error));
    }
  }

  Future<void> _addMessage(
    AddMessage$GeminiAiEvent event,
    Emitter<GeminiAiState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    try {
      List<MessageModel> messages = [
        ...state.messages,
        MessageModel(role: "user", text: event.text),
      ];

      emit(state.copyWith(status: Status.success, messages: messages));
    } on Object catch (_) {
      emit(state.copyWith(status: Status.error));
    }
  }

  Future<void> _audio(
    AudioIndex$GeminiAiEvent event,
    Emitter<GeminiAiState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));

    emit(
      state.copyWith(
        status: Status.success,
        audioIndex:
            state.audioIndex != event.audioIndex ? event.audioIndex : -1,
      ),
    );
  }
}
