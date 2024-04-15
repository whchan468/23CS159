import 'package:googleapis/healthcare/v1.dart';
import 'package:medireminder/Models/med_form.dart';
import 'package:string_similarity/string_similarity.dart';

class DataMapping {
  static MedForm mapData(List<EntityMention> entity) {
    late MedForm info;
    String? name;
    int? dosage;
    int? freq;
    int? times;
    List<String> remark;
    List<String> freqList = [];
    List<String> doseList = [];
    double nameConfidence = 0;

    for (EntityMention e in entity) {
      //    Get med name
      if (isSameType(e, "MEDICINE")) {
        if (e.confidence! > nameConfidence) {
          name = getInfoFromType(e, "MEDICINE");
          nameConfidence = e.confidence!;
        }
      }

      //    Get med dosage
      if (isSameType(e, "MED_DOSE")) {
        doseList.add(getInfoFromType(e, "MED_DOSE"));
      }

      //    Get med frequency and remarks
      if (isSameType(e, "MED_FREQUENCY")) {
        freqList.add(getInfoFromType(e, "MED_FREQUENCY"));
      }
    }
    dosage = getDosage(doseList);

    freq = convertFreq(freqList);

    times = convertTimes(freqList);

    //    if times or freq not exists, auto convert it to each other
    // times ?? 24 ~/ freq!;
    // freq ?? 24 ~/ times!;
    //print("$name $freq $times $dosage");

    remark = convertRemark(freqList);

    if (freq == null) {
      if (times == null) {
        freq = 0;
        times = 0;
      } else {
        freq = 24 ~/ times;
      }
    } else if (times == null) {
      times = 24 ~/ freq;
    }

    info = MedForm(
        name: name, freq: freq, times: times, dosage: dosage, remark: remark);

    return info;
  }

  static bool isSameType(EntityMention entity, String type) {
    return (entity.type == type);
  }

  static String getInfoFromType(EntityMention entity, String type) {
    return entity.text!.content!;
  }

  static int getDosage(List<String> doseList) {
    //    get dosage integer from string
    int dosage = 999;

    //    get min value => daily dosage , max value => total dosage
    for (var text in doseList) {
      if (text.contains(RegExp('[0-9]'))) {
        final d = int.tryParse(text.replaceAll(RegExp('[^0-9]'), ''));
        if (d == null) {
        } else if (d < dosage) {
          dosage = d;
        }
      }
    }
    if (dosage == 999) return 0;
    return dosage;
  }

  static int? convertFreq(List<String> freqList) {
    final List<String> checkText = ["every hours"];
    const threshold = 0.4;
    List<String?> bestMatch = getBestMatch(freqList, checkText, threshold);
    //    identify phase "every hours" and parse the phase into freq
    if (bestMatch.isNotEmpty) {
      final text = bestMatch[0];
      final freq = int.tryParse(text!.replaceAll(RegExp('[^0-9]'), ''));
      return freq;
    } else //   check phase "times a day" if "every hours" not present
    {
      return null;
    }
  }

  static int? convertTimes(List<String> freqList) {
    final List<String> checkText = ["times a day"];
    const threshold = 0.4;
    List<String?> bestMatch = getBestMatch(freqList, checkText, threshold);

    //    identify phase "times a day" and parse the phase into times
    if (bestMatch.isNotEmpty) {
      final text = bestMatch[0];
      final times = int.tryParse(text!.replaceAll(RegExp('[^0-9]'), ''));
      return times;
    } else {
      return null;
    }
  }

  static List<String> convertRemark(List<String> remarkList) {
    final List<String?> checkText = [
      "before meals",
      "after meals",
      "when needed",
    ];
    const threshold = 0.4;
    //    identify phase type and parse the phase into remarks
    List<String> matchList = getAllMatch(remarkList, checkText, threshold);
    return matchList;
  }

  //    Find the best match using Dice-Coefficient
  static List<String?> getBestMatch(
      List<String> textList, List<String?> checkText, double threshold) {
    final Map<String, String?> matchMap = {};
    double maxRating = 0;
    String mapIndex = '';

    //    find best match phases with highest rating
    for (var text in textList) {
      BestMatch bestMatch = StringSimilarity.findBestMatch(text, checkText);
      matchMap[text] = bestMatch.bestMatch.target;
      if (bestMatch.bestMatch.rating! > maxRating) {
        maxRating = bestMatch.bestMatch.rating!;
        mapIndex = text;
      }
    }
    if (maxRating > threshold) {
      return [mapIndex, matchMap[mapIndex]];
    } else
      return [];
  }

  static List<String> getAllMatch(
      List<String> textList, List<String?> checkText, double threshold) {
    final List<String> matchList = [];

    //    find best match phases ratings > threshold
    for (var text in textList) {
      BestMatch bestMatch = StringSimilarity.findBestMatch(text, checkText);
      if (bestMatch.bestMatch.rating! >= threshold &&
          !matchList.contains(bestMatch.bestMatch.target))
        matchList.add(bestMatch.bestMatch.target!);
    }
    return matchList;
  }
}
