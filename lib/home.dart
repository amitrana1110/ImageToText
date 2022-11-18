import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? image;
  ImagePicker? imagePicker;

  String? result = "";

  pickImageFromGallery() async {
    final pickedImage =
        await imagePicker!.pickImage(source: ImageSource.gallery);
    image = File(pickedImage!.path);
    setState(() {
      image;
      performImageLabeling();
    });
  }

  pickImageFromCamera() async {
    final pickedFile = await imagePicker!.pickImage(source: ImageSource.camera);
    image = File(pickedFile!.path);
    setState(() {
      image;
      performImageLabeling();
    });
  }

  performImageLabeling() async {
    final inputImage = InputImage.fromFilePath(image!.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    result = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        result = "${result!}${line.text}\n";
      }
    }
    setState(() {
      result;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              width: 100,
            ),
            Container(
              height: 280,
              width: 250,
              margin: const EdgeInsets.only(top: 70),
              padding: const EdgeInsets.only(left: 20, bottom: 5, right: 10),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/note.jpg'), fit: BoxFit.cover)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    result!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 140),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.asset('assets/pin.png',
                            height: 240, width: 240),
                      )
                    ],
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        pickImageFromGallery();
                      },
                      onLongPress: () {
                        pickImageFromCamera();
                      },
                      child: Container(
                          margin: const EdgeInsets.only(top: 25),
                          child: image != null
                              ? Image.file(
                                  image!,
                                  width: 140,
                                  height: 192,
                                  fit: BoxFit.fill,
                                )
                              : Container(
                                  width: 240,
                                  height: 200,
                                  child: const Icon(
                                    Icons.camera_enhance_sharp,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
