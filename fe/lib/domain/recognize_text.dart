class RecognizedPage {
  const RecognizedPage(this.text);

  final String text;
}

class OcrEmptyException implements Exception {
  const OcrEmptyException();
}

abstract class OcrEngine {
  Future<String> recognizePath(String path);
}

class RecognizeTextUseCase {
  const RecognizeTextUseCase(this._engine);

  final OcrEngine _engine;

  Future<RecognizedPage> call(String path) async {
    final text = (await _engine.recognizePath(path)).trim();
    if (text.isEmpty) throw const OcrEmptyException();
    return RecognizedPage(text);
  }
}

class UnavailableOcrEngine implements OcrEngine {
  const UnavailableOcrEngine();

  @override
  Future<String> recognizePath(String path) {
    throw UnsupportedError('On-device OCR is available on Android and iOS.');
  }
}
