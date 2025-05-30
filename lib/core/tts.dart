import 'dart:developer';

import 'package:flutter_tts/flutter_tts.dart';

import 'dart:async';

class SpeakCardholder {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isSpeaking = false;
  static String? _currentUserId;

  static void init() {
    _flutterTts.setLanguage("id-ID");
    _flutterTts.awaitSpeakCompletion(true);
    _flutterTts
        .setVoice({"name": "Google Bahasa Indonesia", "locale": "id-ID"});

    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
      log("🔊 TTS started");
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      log("✅ TTS completed");
    });

    _flutterTts.setCancelHandler(() {
      _isSpeaking = false;
      log("🚫 TTS canceled");
    });

    _flutterTts.setErrorHandler((msg) {
      _isSpeaking = false;
      log("❌ TTS error: $msg");
    });
  }

  static Future<void> handleSpeak(
      String userId, String firstName, String door) async {
    if (_isSpeaking && _currentUserId == userId) {
      log("⏭ Skipping speak because same user is speaking");
      return;
    }

    if (_isSpeaking) {
      log("🛑 Stopping current TTS for new user");
      await _flutterTts.stop();
      await Future.delayed(const Duration(milliseconds: 300));
    }

    _currentUserId = userId;
    final location = door.contains('Office') ? 'Office Building' : door;

    final textToSpeak = "Selamat Datang $firstName di $location";
    log("🗣️ Speaking: $textToSpeak");

    await _flutterTts.speak(textToSpeak);
  }
}
