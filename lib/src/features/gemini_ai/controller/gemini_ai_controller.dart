import 'package:flutter/material.dart';

import '../screen/gemini_ai_screen.dart';

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
