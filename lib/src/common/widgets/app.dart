import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:udevs/src/common/style/app_theme.dart';
import 'package:udevs/src/common/utils/extension/context_extension.dart';
import 'package:udevs/src/features/video_player/bloc/video_player_bloc.dart';
import 'package:udevs/src/features/video_player/screens/folders.dart';

import '../l10n/generated/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          context.dependency.theme ? AppTheme.lightTheme : AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale("en")],
      locale: Locale(context.dependency.locale),
      home: BlocProvider(
        create: (context) {
          return VideoPlayerBloc(
            videoPlayerRepository: context.dependency.videoPlayerRepository,
          )..add(GetVideoAll$VideoPlayerEvent(context: context));
        },
        child: Folders(),
      ),
    );
  }
}
