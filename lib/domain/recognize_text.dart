class RecognizedPage {
  const RecognizedPage(this.text, {this.engine = 'local'});

  final String text;
  final String engine;
}

class OcrEmptyException implements Exception {
  const OcrEmptyException();
}

abstract class OcrEngine {
  Future<String> recognizePath(String path);

  Future<String> recognizeBytes(List<int> bytes) async {
    throw UnsupportedError('On-device OCR needs a file path on this platform.');
  }
}

class RecognizeTextUseCase {
  const RecognizeTextUseCase(this._engine);

  final OcrEngine _engine;

  Future<RecognizedPage> call(String path) async {
    final text = (await _engine.recognizePath(path)).trim();
    if (text.isEmpty) throw const OcrEmptyException();
    return RecognizedPage(text);
  }

  Future<RecognizedPage> fromBytes(List<int> bytes) async {
    final text = (await _engine.recognizeBytes(bytes)).trim();
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

  @override
  Future<String> recognizeBytes(List<int> bytes) {
    throw UnsupportedError('On-device OCR is available on Android and iOS.');
  }
}
