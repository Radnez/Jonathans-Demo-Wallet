import 'package:camera/camera.dart';
import 'package:demo_wallet/src/core/widgets/header_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../core/utils/responsiveness/responsive_widgets.dart';

class CardScanner extends StatefulWidget {
  @override
  _CardScannerState createState() => _CardScannerState();
}

class _CardScannerState extends State<CardScanner> {
  late CameraController _cameraController;
  late TextRecognizer _textRecognizer;
  bool _isProcessing = false;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _textRecognizer = TextRecognizer();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      print("No cameras found.");
      return;
    }
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _cameraController.initialize();

    await _cameraController.setFlashMode(FlashMode.off);

    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _processImage() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final image = await _cameraController.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      String? detectedCardNumber;
      String? detectedExpiryDate;
      String? detectedCVC;

      for (var block in recognizedText.blocks) {
        for (var line in block.lines) {
          final text = line.text;

          // Match card number: Supports spaces, hyphens, or no separators
          if (RegExp(r'^(\d{4}[- ]?){3}\d{4}$').hasMatch(text)) {
            detectedCardNumber =
                text.replaceAll(RegExp(r'[- ]'), ''); // Normalize format
          }

          // Match expiry date (MM/YY format)
          if (RegExp(r'^\d{2}/\d{2}$').hasMatch(text)) {
            detectedExpiryDate = text;
          }

          // Match CVC (3 digits)
          if (RegExp(r'^\d{3}$').hasMatch(text)) {
            detectedCVC = text;
          }
        }
      }

      // Navigate if card data is detected
      if (detectedCardNumber != null || detectedCVC != null) {
        Navigator.pop(context, {
          'cardNumber': detectedCardNumber,
          'expiryDate': detectedExpiryDate,
          'cvv': detectedCVC,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("No card details detected. Please try again.")),
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      _isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Scaffold(
        appBar: HeaderAppBar(title: 'Scan Card'),
        backgroundColor: Colors.grey[850],
        body: _isCameraInitialized
            ? Stack(
                children: [
                  Positioned.fill(
                    child: CameraPreview(_cameraController),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 20,
                    right: 20,
                    child: ElevatedButton(
                      onPressed: _processImage,
                      child: Text('Scan Card'),
                    ),
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _textRecognizer.close();
    super.dispose();
  }
}
