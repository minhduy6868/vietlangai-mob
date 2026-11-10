import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../domain/recognize_text.dart';

class MlKitOcrEngine implements OcrEngine {
  const MlKitOcrEngine();

  @override
  Future<String> recognizePath(String path) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      throw UnsupportedError('On-device OCR is available on Android and iOS.');
    }
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final result = await recognizer.processImage(InputImage.fromFilePath(path));
      return result.text;
    } finally {
      await recognizer.close();
    }
  }
}

OcrEngine createOcrEngine() {
  if (Platform.isAndroid || Platform.isIOS) return const MlKitOcrEngine();
  return const UnavailableOcrEngine();
}
