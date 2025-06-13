import 'package:flutter/material.dart';
import 'package:udevs/src/features/gemini_ai/screen/gemini_ai_screen.dart';

mixin GeminiAiController on State<GeminiAiScreen> {
  late final TextEditingController messageController;
  String textMessage = "";

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }
}
