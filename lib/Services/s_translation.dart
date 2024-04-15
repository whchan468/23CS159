import 'package:google_ml_kit/google_ml_kit.dart';

class STranslation {
  static Future<String> translateText(List<String> textline) async {
    final LanguageIdentifier languageIdentifier =
        LanguageIdentifier(confidenceThreshold: 0.5);

    final translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.chinese,
        targetLanguage: TranslateLanguage.english);
    String resultText = '';
    for (String text in textline) {
      final language = await languageIdentifier.identifyLanguage(text);
      if (language != 'en') {
        String translated = await translator.translateText(text);
        resultText += translated;
        resultText += " ";
      } else {
        resultText += text;
        resultText += " ";
      }
    }
    languageIdentifier.close();
    translator.close();
    return resultText;
  }
}
