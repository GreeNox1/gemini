import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udevs/src/common/utils/extension/context_extension.dart';
import 'package:udevs/src/features/gemini_ai/bloc/gemini_ai_bloc.dart';
import 'package:udevs/src/features/gemini_ai/controller/gemini_ai_controller.dart';

import '../../../common/style/app_size.dart';
import '../../../common/utils/enums/status.dart';
import '../widgets/message_box.dart';

class GeminiAiScreen extends StatefulWidget {
  const GeminiAiScreen({super.key});

  @override
  State<GeminiAiScreen> createState() => _GeminiAiScreenState();
}

class _GeminiAiScreenState extends State<GeminiAiScreen>
    with GeminiAiController {
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.colors.primary,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: context.colors.primary,
        title: Text(
          context.lang.gemini_ai,
          style: context.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<GeminiAiBloc, GeminiAiState>(
        builder: (context, state) {
          if (state.messages.isEmpty) {
            return Center(
              child: Text(
                context.lang.gemini_message,
                style: context.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return ListView(
            reverse: true,
            controller: controller,
            children: [
              if (state.status == Status.loading)
                Padding(
                  padding: AppSize.paddingAll10,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: context.colors.outline,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: AppSize.paddingAll10,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              for (int i = state.messages.length - 1; 0 <= i; i--)
                Padding(
                  padding: AppSize.paddingAll10,
                  child: MessageBox(
                    text: state.messages[i].text,
                    isUser: state.messages[i].role == "user",
                    audioIndex: i,
                    isPlay: state.audioIndex != i ? true : false,
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: AppSize.borderRadiusVer15,
              color: context.colors.outlineVariant,
            ),
            child: SafeArea(
              child: Padding(
                padding: AppSize.paddingV15H10,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 7,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.colors.primaryContainer,
                              width: 3,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: context.colors.primaryContainer,
                              width: 3,
                            ),
                          ),
                          hintText: context.lang.ask_anything,
                        ),
                        controller: messageController,
                        cursorColor: context.colors.onPrimaryFixed,
                        onChanged: (value) => textMessage = value,
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          messageController.clear();
                          context.read<GeminiAiBloc>().add(
                            AddMessage$GeminiAiEvent(
                              context: context,
                              text: textMessage,
                            ),
                          );
                          context.read<GeminiAiBloc>().add(
                            SendMessage$GeminiAiEvent(
                              context: context,
                              text: textMessage,
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.send,
                          color: context.colors.surfaceTint,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
