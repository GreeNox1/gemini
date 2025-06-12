import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:udevs/src/common/model/message_model.dart';
import 'package:udevs/src/common/service/api_service.dart';

abstract interface class IHomeRepository {
  const IHomeRepository._();

  Future<MessageModel> sendMessage(String text);
}

final class HomeRepositoryImpl implements IHomeRepository {
  const HomeRepositoryImpl({required this.apiService});

  final ApiService apiService;

  @override
  Future<MessageModel> sendMessage(String text) async {
    try {
      final gemini = Gemini.instance;



      gemini.prompt(parts: );
    } on Object catch (e) {
      print("Error: $e");
    }
  }
}
