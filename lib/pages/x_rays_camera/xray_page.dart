import 'dart:io';
import 'dart:math';
import 'package:aldente/pages/x_rays_camera/bbox.dart';
import 'package:aldente/pages/x_rays_camera/labels.dart';
import 'package:aldente/pages/x_rays_camera/yolo.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class XRayPage extends StatefulWidget {
  const XRayPage({super.key});

  @override
  State<XRayPage> createState() => _XRayPageState();
}

class _XRayPageState extends State<XRayPage> {
  static const inModelWidth = 640;
  static const inModelHeight = 640;
  static const numClasses = 4;
  static const double maxImageWidgetHeight = 400;

  late final YoloModel model;
  File? imageFile;

  double confidenceThreshold = 0.4;
  double iouThreshold = 0.1;

  List<List<double>>? inferenceOutput;
  List<int> classes = [];
  List<List<double>> bboxes = [];
  List<double> scores = [];

  int? imageWidth;
  int? imageHeight;

  @override
  void initState() {
    super.initState();
    model = YoloModel(
      'assets/models/yolov8n.tflite',
      inModelWidth,
      inModelHeight,
      numClasses,
    );
    model.init();
  }

  @override
  Widget build(BuildContext context) {
    final bboxesColors = generateBboxColors();
    final picker = ImagePicker();
    final displayWidth = MediaQuery.of(context).size.width;
    final resizeFactor = calculateResizeFactor(displayWidth);

    return Scaffold(
      appBar: AppBar(title: const Text('YOLO')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.image_outlined),
        onPressed: () => pickImage(picker),
      ),
      body: ListView(
        children: [
          InteractiveViewer(
            child: buildImageWidget(resizeFactor, bboxesColors),
          ),
          const SizedBox(height: 30),
          buildConfidenceThresholdSlider(),
          const SizedBox(height: 30),
          buildIoUThresholdSlider(),
          const SizedBox(height: 30),
          buildResultsWidget(),
        ],
      ),
    );
  }

  Widget buildResultsWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detection Results:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...buildResultItems(),
        ],
      ),
    );
  }

  List<Widget> buildResultItems() {
    return classes.asMap().entries.map((entry) {
      final index = entry.key;
      final boxClass = entry.value;
      final score = scores[index];
      return Text(
        '${labels[boxClass]}: ${score.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 16),
      );
    }).toList();
  }

  List<Color> generateBboxColors() {
    return List<Color>.generate(
      numClasses,
      (_) => Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    );
  }

  double calculateResizeFactor(double displayWidth) {
    if (imageWidth != null && imageHeight != null) {
      double k1 = displayWidth / imageWidth!;
      double k2 = maxImageWidgetHeight / imageHeight!;
      return min(k1, k2);
    }
    return 1;
  }

  Future<void> pickImage(ImagePicker picker) async {
    final XFile? newImageFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (newImageFile != null) {
      setState(() {
        imageFile = File(newImageFile.path);
      });
      final image = img.decodeImage(await newImageFile.readAsBytes())!;
      imageWidth = image.width;
      imageHeight = image.height;
      inferenceOutput = model.infer(image);
      updatePostprocess();
    }
  }

  Widget buildImageWidget(double resizeFactor, List<Color> bboxesColors) {
    return SizedBox(
      height: maxImageWidgetHeight,
      child: Center(
        child: Stack(
          children: [
            if (imageFile != null) Image.file(imageFile!),
            ...buildBboxWidgets(resizeFactor, bboxesColors),
          ],
        ),
      ),
    );
  }

  List<Widget> buildBboxWidgets(double resizeFactor, List<Color> bboxesColors) {
    return bboxes.asMap().entries.map((entry) {
      final index = entry.key;
      final box = entry.value;
      final boxClass = classes[index];
      return Bbox(
        box[0] * resizeFactor,
        box[1] * resizeFactor,
        box[2] * resizeFactor,
        box[3] * resizeFactor,
        labels[boxClass],
        scores[index],
        bboxesColors[boxClass],
      );
    }).toList();
  }

  Widget buildConfidenceThresholdSlider() {
    return Column(
      children: [
        const Center(
          child: Text(
            'Confidence threshold',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Slider(
          value: confidenceThreshold,
          min: 0,
          max: 1,
          divisions: 100,
          label: confidenceThreshold.toStringAsFixed(2),
          onChanged: (value) {
            setState(() {
              confidenceThreshold = value;
              updatePostprocess();
            });
          },
        ),
      ],
    );
  }

  Widget buildIoUThresholdSlider() {
    return Column(
      children: [
        const Center(
          child: Text(
            'IoU threshold',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Slider(
          value: iouThreshold,
          min: 0,
          max: 1,
          divisions: 100,
          label: iouThreshold.toStringAsFixed(2),
          onChanged: (value) {
            setState(() {
              iouThreshold = value;
              updatePostprocess();
            });
          },
        ),
      ],
    );
  }

  void updatePostprocess() {
    if (inferenceOutput == null) {
      return;
    }

    final List<int> newClasses;
    final List<List<double>> newBboxes;
    final List<double> newScores;

    (newClasses, newBboxes, newScores) = model.postprocess(
      inferenceOutput!,
      imageWidth!,
      imageHeight!,
      confidenceThreshold: confidenceThreshold,
      iouThreshold: iouThreshold,
    );

    debugPrint('Detected ${newBboxes.length} bboxes');

    setState(() {
      classes = newClasses;
      bboxes = newBboxes;
      scores = newScores;
    });
  }
}
