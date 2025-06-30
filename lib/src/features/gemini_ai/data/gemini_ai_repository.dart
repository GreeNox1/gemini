import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../../common/model/message_model.dart';
import '../../../common/service/api_service.dart';

abstract interface class IGeminiAiRepository {
  const IGeminiAiRepository._();

  Future<MessageModel> sendMessage(String text);
}

final class GeminiAiRepositoryImpl implements IGeminiAiRepository {
  const GeminiAiRepositoryImpl({required this.apiService});

  final ApiService apiService;

  @override
  Future<MessageModel> sendMessage(String text) async {
    try {
      final gemini = Gemini.instance;

      final part = Part.text(text);

      final response = await gemini.prompt(parts: [part]);

      return MessageModel(
        role: "model",
        text: response?.output ?? "Something went wrong",
      );
    } on Object catch (e) {
      debugPrint("Error: $e");
      return MessageModel(role: "model", text: "Something went wrong");
    }
  }
}
