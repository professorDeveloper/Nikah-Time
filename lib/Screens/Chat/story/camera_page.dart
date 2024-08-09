import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'add_story.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  XFile? _storyImage; // Declare _storyImage here

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras[0],
      ResolutionPreset.high,
    );

    await _cameraController?.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isCameraInitialized)
            CameraPreview(_cameraController!)
          else
            Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.6),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.flash_on, color: Colors.white),
                    onPressed: () {
                      if (_cameraController!.value.flashMode == FlashMode.off) {
                        _cameraController!.setFlashMode(FlashMode.torch);
                      } else {
                        _cameraController!.setFlashMode(FlashMode.off);
                      }
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.camera, color: Colors.white),
                    onPressed: () async {
                      if (_cameraController != null && _cameraController!.value.isInitialized) {
                        final image = await _cameraController!.takePicture();
                        setState(() {
                          _storyImage = image;
                        });
                        if (_storyImage != null) {
                          // Navigate to AddStoryPage and pass the captured image
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => AddStoryPage(
                          //       imageFile: File(_storyImage!.path),
                          //     ),
                          //   ),
                          // );
                        }
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.switch_camera, color: Colors.white),
                    onPressed: () async {
                      if (_cameras.length > 1) {
                        // Toggle between front and rear camera
                        int newCameraIndex = _cameraController!.description.lensDirection == CameraLensDirection.front
                            ? 0
                            : 1;
                        _cameraController = CameraController(
                          _cameras[newCameraIndex],
                          ResolutionPreset.high,
                        );
                        await _cameraController!.initialize();
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

