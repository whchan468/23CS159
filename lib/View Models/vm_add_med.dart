import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:googleapis/healthcare/v1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medireminder/Models/med_form.dart';
import 'package:medireminder/Services/s_data_mapping.dart';
import 'package:medireminder/Services/s_key_info_extract.dart';
import 'package:medireminder/Services/s_text_extract.dart';
import 'package:medireminder/Services/s_translation.dart';

class VMAddMed extends ChangeNotifier {
  XFile? _imageFile;
  List<String> _resultText = [];
  String _translatedText = "";
  MedForm _medForm = MedForm();

  MedForm get medForm => _medForm;
  XFile? get imageFile => _imageFile;
  List<String> get resultText => _resultText;
  String get translatedText => _translatedText;

  setimageFile(XFile file) {
    _imageFile = file;
    notifyListeners();
  }

  setresultText(List<String> text) {
    _resultText = text;
    notifyListeners();
  }

  setTranslatedText(String text) {
    _translatedText = text;
    notifyListeners();
  }

  setMedForm(MedForm? medForm) {
    if (medForm != null) {
      _medForm = MedForm();
      notifyListeners();
    }
  }

  Future<MedForm?> extractText() async {
    // ENG recognizer
    // final textRecognizer =
    //     TextRecognizer(script: TextRecognitionScript.latin);
    File file = File(_imageFile!.path);
    final InputImage inputImage = InputImage.fromFile(file);

    //    Call Text Extraction Service
    List<String> text = await STextExtract.recognizeText(inputImage);
    setresultText(text);
    final translated = await translateText(text);
    setTranslatedText(translated);

    final keyinfo = await keyInfoExtract(digitalizeNum(translated));
    setMedForm(keyinfo);
    return keyinfo;
    //    return OCR result
    // String result = "";
    // for (String t in text) {
    //   result += t;
    // }

    // return result;
  }

  Future<String> translateText(List<String> text) async {
    final translatedText = await STranslation.translateText(text);
    final processText = digitalizeNum(translatedText.toLowerCase());
    return processText;
  }

  Future<MedForm?> keyInfoExtract(String text) async {
    AnalyzeEntitiesResponse? response = await SKeyInfoExtract.apiRequest(text);
    if (response != null) {
      final medForm = DataMapping.mapData(response.entityMentions!);
      return medForm;
    } else {
      return null;
    }
  }

  String digitalizeNum(String text) {
    var list = [
      'zero',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
      'ten',
      'eleven',
      'twelve'
    ];
    String t = text;
    for (var n in list) {
      t = t.replaceAll(RegExp('(' + n + ')'), list.indexOf(n).toString());
    }
    return t;
  }
}
