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
    _flutterTts.setVoice({"name": "Google Bahasa Indonesia", "locale": "id-ID"});

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

  static Future<void> handleSpeak(String userId, String firstName, String door) async {
    // 1. Jika user yang sama dan masih bicara → abaikan
    if (_isSpeaking && _currentUserId == userId) {
      log("⏭ Skipping speak because same user is speaking");
      return;
    }

    // 2. Jika user beda dan masih bicara → stop dulu
    if (_isSpeaking) {
      log("🛑 Stopping current TTS for new user");
      await _flutterTts.stop();
      await Future.delayed(const Duration(milliseconds: 300)); // penting di web
    }

    // 3. Update ID dan mulai bicara
    _currentUserId = userId;
    final location = door.contains('Office') ? 'Office Building' : door;

    final textToSpeak = "Selamat Datang $firstName di $location";
    log("🗣️ Speaking: $textToSpeak");

    await _flutterTts.speak(textToSpeak);
  }
}


// class SpeakCardholder {
//   static final FlutterTts _flutterTts = FlutterTts();
//   static bool _isSpeaking = false;
//   static String? _lastUserId;

//   static bool get isSpeaking => _isSpeaking;

// static Future<void> speak(String userId, String firstName, String door) async {
//     // Jika sedang berbicara dan user berbeda, hentikan dulu
//     if (_isSpeaking && _lastUserId != userId) {
//       await stop();
//       await Future.delayed(const Duration(milliseconds: 300)); // penting agar web sempat idle
//     }

//     // Skip jika sama dan masih bicara
//     if (_isSpeaking && _lastUserId == userId) {
//       log("🚫 Skip: Masih bicara user yang sama");
//       return;
//     }

//     _lastUserId = userId;
//     _isSpeaking = true;

//     final doors = door.contains('Office') ? 'Office Building' : door;

//     try {
//       await _flutterTts.setLanguage("id-ID");
//       await _flutterTts.setVoice({
//         "name": "Google Bahasa Indonesia",
//         "locale": "id-ID",
//       });

//       await _flutterTts.awaitSpeakCompletion(true);

//       _flutterTts.setStartHandler(() {
//         _isSpeaking = true;
//         log("✅ TTS started for $userId");
//       });

//       _flutterTts.setCompletionHandler(() {
//         _isSpeaking = false;
//         log("✅ TTS completed");
//       });

//       _flutterTts.setCancelHandler(() {
//         _isSpeaking = false;
//         log("🚫 TTS cancelled");
//       });

//       _flutterTts.setErrorHandler((msg) {
//         _isSpeaking = false;
//         log("❌ TTS error: $msg");
//       });

//       log("📢 Speaking: Selamat Datang $firstName di $doors");
//       await _flutterTts.speak("Selamat Datang $firstName di $doors");
//     } catch (e) {
//       log("❗ Exception in speak(): $e");
//       _isSpeaking = false;
//     }
//   }
  
  // static Future<void> speak(String userId, String firstName, String door) async {
  //   _isSpeaking = true;
  //   _lastUserId = userId;

  //   final doors = door.contains('Office') ? 'Office Building' : door;
  //   await _flutterTts.setLanguage("id-ID");
  //   await _flutterTts.awaitSpeakCompletion(true);
  //   await _flutterTts.speak("Selamat Datang $firstName di $doors");

  //   _flutterTts.setCompletionHandler(() {
  //     _isSpeaking = false;
  //   });

  //   _flutterTts.setCancelHandler(() {
  //     _isSpeaking = false;
  //   });
  // }
//   static Future<void> speak(String userId, String firstName, String door) async {


//   final doors = door.contains('Office') ? 'Office Building' : door;
//   await _flutterTts.setLanguage("id-ID");

//   // Set voice dulu sebelum speak
//   await _flutterTts.setVoice({
//     "name": "Google Bahasa Indonesia",
//     "locale": "id-ID",
//   });

//   await _flutterTts.awaitSpeakCompletion(true);

//   try {
//     await _flutterTts.speak("Selamat Datang $firstName di $doors");
//   } catch (e) {
//     log('TTS error: $e');
//     _isSpeaking = false;
//   }
// }

// static Future<void> speak(String userId, String firstName, String door) async {
//     final doors = door.contains('Office') ? 'Office Building' : door;

//     // Jika sedang bicara dan user berbeda, hentikan dulu
//     if (_isSpeaking) {
//       await stop();
//       await Future.delayed(const Duration(milliseconds: 100)); // beri delay kecil agar stabil
//     }

//     _lastUserId = userId;
//     _isSpeaking = true;

//     try {
//       await _flutterTts.setLanguage("id-ID");
//       await _flutterTts.setVoice({
//         "name": "Google Bahasa Indonesia",
//         "locale": "id-ID",
//       });

//       await _flutterTts.awaitSpeakCompletion(true);

//       _flutterTts.setStartHandler(() {
//         _isSpeaking = true;
//         log('✅ TTS started');
//       });

//       _flutterTts.setCompletionHandler(() {
//         _isSpeaking = false;
//         log('✅ TTS completed');
//       });

//       _flutterTts.setCancelHandler(() {
//         _isSpeaking = false;
//         log('🚫 TTS cancelled');
//       });

//       _flutterTts.setErrorHandler((msg) {
//         _isSpeaking = false;
//         log('❌ TTS error: $msg');
//       });

//       await _flutterTts.speak("Selamat Datang $firstName di $doors");
//     } catch (e) {
//       log("❗ speak() exception: $e");
//       _isSpeaking = false;
//     }
//   }


//   static Future<void> stop() async {
//     await _flutterTts.stop();
//     _isSpeaking = false;
//   }

//   static void init() {
//     _flutterTts.setLanguage("id-ID");
//     _flutterTts.awaitSpeakCompletion(true);

//     _flutterTts.setStartHandler(() {
//       _isSpeaking = true;
//     });

//     _flutterTts.setCompletionHandler(() {
//       _isSpeaking = false;
//     });

//     _flutterTts.setErrorHandler((msg) {
//       _isSpeaking = false;
//     });
//   }

//   static String? get lastUserId => _lastUserId;
// }


// class SpeakCardholder {
//   static final FlutterTts _flutterTts = FlutterTts();

//   static bool _isSpeaking = false;
//   static String? _lastUserId;

//   static void init() {
//     _flutterTts.setLanguage("id-ID");
//     // _flutterTts
//     //     .setVoice({"name": "Google Bahasa Indonesia", "locale": "id-ID"});
//     _flutterTts.awaitSpeakCompletion(true);

//     _flutterTts.setStartHandler(() {
//       _isSpeaking = true;
//     });

//     _flutterTts.setCompletionHandler(() {
//       _isSpeaking = false;
//     });

//     _flutterTts.setErrorHandler((msg) {
//       _isSpeaking = false;
//     });
//   }

//   static Future<void> speak(String userId, String name, String door) async {
//     if (_lastUserId == userId && _isSpeaking) {
//       return;
//     }

//     if (_isSpeaking) {
//       await _flutterTts.stop();
//       _isSpeaking = false;
//     }

//     _lastUserId = userId;

//     final doors = door.contains('Office') ? 'Office Building' : door;
//     await _flutterTts.speak("Selamat Datang $name di $doors");
//   }

//   static Future<void> stop() async {
//     if (_isSpeaking) {
//       await _flutterTts.stop();
//       _isSpeaking = false;
//     }
//   }

// }


    // await flutterTts.setVolume(100);
    // await flutterTts.setSpeechRate(1);
    // await flutterTts.setPitch(0);