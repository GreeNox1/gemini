import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udevs/src/common/utils/extension/context_extension.dart';
import 'package:udevs/src/features/home/bloc/message_bloc.dart';

import '../../../common/style/app_size.dart';
import '../../../common/utils/enums/status.dart';
import '../widgets/message_box.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Home Screen")),
//       body: Center(
//         child: CustomButton(
//           onPressed: () {
//             // Navigator.pushReplacement(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (context) => SecondScreen(),
//             //     settings: RouteSettings(name: AppRouter.second),
//             //   ),
//             // );
//           },
//           child: Center(child: Text("Salom")),
//         ),
//       ),
//     );
//   }
// }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController messageController;
  String textMessage = "";

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          print("Status ${state.status.name}");
          return state.messages.isNotEmpty
              ? ListView(
                children: [
                  for (int i = 0; i < 10; i++)
                    Padding(
                      padding: AppSize.paddingAll10,
                      child: MessageBox(
                        text:
                            "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
                        isUser: i % 2 == 0,
                      ),
                    ),
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
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: AppSize.paddingAll10,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                ],
              )
              : Center(
                child: Text(
                  context.lang.gemini_message,
                  style: context.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
        },
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          color: context.colors.outlineVariant,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                      hintText: "Ask anything",
                    ),
                    controller: messageController,
                    cursorColor: context.colors.onPrimaryFixed,
                    onChanged: (value) => textMessage = value,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      print("Send Message: $textMessage");
                      context.read<HomeBloc>().add(
                        SendMessage$HomeEvent(
                          context: context,
                          text: textMessage,
                        ),
                      );
                    },
                    icon: Icon(Icons.send, color: context.colors.surfaceTint),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }
}
