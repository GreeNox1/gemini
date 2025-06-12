import 'package:udevs/src/features/home/data/home_repository.dart';

class AppDependencies {
  AppDependencies({
    this.locale = "en",
    this.theme = true,
    required this.homeRepository,
  });

  String locale;
  bool theme;

  final IHomeRepository homeRepository;
}
