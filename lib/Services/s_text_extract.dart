import 'package:google_ml_kit/google_ml_kit.dart';

class STextExtract {
  static Future<List<String>> recognizeText(InputImage inputImage) async {
    // ENG recognizer
    // final textRecognizer =
    //     TextRecognizer(script: TextRecognitionScript.latin);

    final textRecognizer =
        TextRecognizer(script: TextRecognitionScript.chinese);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    // final text = recognizedText.text;
    final List<String> textInLine = [];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        textInLine.add(line.text);
      }
    }

    textRecognizer.close();
    return textInLine;
  }
}
