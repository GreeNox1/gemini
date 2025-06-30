import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../l10n/generated/l10n.dart';
import '../router/app_router.dart';
import '../style/app_theme.dart';
import '../utils/extension/context_extension.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale("en")],
      locale: Locale(context.dependency.locale),
      theme:
          context.dependency.theme ? AppTheme.lightTheme : AppTheme.darkTheme,
    );
  }
}
