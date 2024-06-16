import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:aldente/pages/chat_doc/chat_app.dart';


Future<void> initializeFlutterGemma() async {
  try {
    await FlutterGemmaPlugin.instance.init(
      maxTokens: 512,
      temperature: 1.0,
      topK: 1,
      randomSeed: 1,
    ).timeout(const Duration(seconds: 10)); // Set a timeout of 10 seconds
  } catch (e) {
    // Handle any errors that occur during initialization
    print('Error initializing FlutterGemmaPlugin: $e');
    // You can choose to rethrow the error, display an error message to the user,
    // or take any other appropriate action based on your app's requirements.
    rethrow;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFlutterGemma();
  runApp(const ChatApp());
}