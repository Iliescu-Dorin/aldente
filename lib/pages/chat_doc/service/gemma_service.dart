import 'package:flutter_gemma/flutter_gemma.dart';

class GemmaLocalService {
  final FlutterGemmaPlugin _gemmaPlugin;

  GemmaLocalService({FlutterGemmaPlugin? gemmaPlugin})
      : _gemmaPlugin = gemmaPlugin ?? FlutterGemmaPlugin.instance;

  Future<String?> processMessage(List<Message> messages) async {
    try {
      return await _gemmaPlugin.getChatResponse(messages: messages).timeout(const Duration(seconds: 10));
    } catch (e) {
      // Handle any errors that occur during message processing
      print('Error processing message: $e');
      // You can choose to return an error message, throw a custom exception,
      // or take any other appropriate action based on your app's requirements.
      return 'Sorry, an error occurred while processing your message.';
    }
  }

  Stream<String?> processMessageAsync(List<Message> messages) {
    try {
      return _gemmaPlugin.getChatResponseAsync(messages: messages).timeout(const Duration(seconds: 10));
    } catch (e) {
      // Handle any errors that occur during async message processing
      print('Error processing message asynchronously: $e');
      // You can choose to return an error message, throw a custom exception,
      // or take any other appropriate action based on your app's requirements.
      return Stream.value('Sorry, an error occurred while processing your message.');
    }
  }
}