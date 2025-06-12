import 'package:flutter/material.dart';

import '../../dependency/app_dependencies.dart';
import '../../l10n/generated/l10n.dart';
import '../../widgets/app_scope.dart';

extension ContextExtension on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  AppDependencies get dependency =>
      findRootAncestorStateOfType<AppScopeState>()!.dependencies;

  S get lang => S.of(this);
}
