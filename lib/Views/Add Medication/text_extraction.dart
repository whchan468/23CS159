import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medireminder/View%20Models/vm_add_med.dart';
import 'package:medireminder/Views/Add%20Medication/extraction_result.dart';
import 'package:medireminder/Widget/option_button.dart';
import 'package:medireminder/service_locator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class TextExtraction extends StatefulWidget {
  const TextExtraction({super.key});

  @override
  State<StatefulWidget> createState() => TextExtractionState();
}

class TextExtractionState extends State<TextExtraction> {
  final vmAddMed = serviceLocator.get<VMAddMed>();

  bool readyForScan = false;
  XFile? imageFile;

  String resultText = "";

  Future getImage(ImageSource source) async {
    try {
      //get image from gallery
      final targetImage = await ImagePicker().pickImage(source: source);
      if (targetImage != null) {
        readyForScan = true;
        setState(() {
          imageFile = targetImage;
          vmAddMed.setimageFile(imageFile!);
        });
      }
    } catch (e) {
      // system did not get any image
      readyForScan = false;
      imageFile = null;
      setState(() {});
      resultText = "Error occured while selecting images";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // //    display nothing when no image
                // if (!readyForScan && imageFile == null)
                //   Container(
                //     width: 300,
                //     height: 400,
                //     color: Colors.grey,
                //   ),

                // //    display image
                // if (imageFile != null) Image.file(File(imageFile!.path)),

                GestureDetector(
                  child: const OptionButton(
                    name: "Open Camera",
                    icon: Icons.add_a_photo_rounded,
                  ),
                  onTap: () => onPressed(ImageSource.camera),
                ),

                const SizedBox(
                  height: 40,
                ),

                GestureDetector(
                  child: const OptionButton(
                      name: "Import from Gallery",
                      icon: Icons.collections_rounded),
                  onTap: () => onPressed(ImageSource.gallery),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onPressed(ImageSource source) async {
    await getImage(source);
    if (imageFile != null && readyForScan == true) {
      PersistentNavBarNavigator.pushNewScreen(context,
          screen: ExtractionResult());
    }
  }
}
