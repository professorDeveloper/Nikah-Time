import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'package:video_compress/video_compress.dart';
import 'add_story.dart'; // Assuming this page is for images

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  File? _latestImage;
  int _selectedCameraIndex = 0;
  bool _isPhotoMode = true;
  bool _isFlashOn = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _getLatestImageFromGallery();
  }

  void _initializeCamera() {
    _controller = CameraController(
      widget.cameras[_selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: true,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getLatestImageFromGallery() async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      List<Album> albums = await PhotoGallery.listAlbums(
        mediumType: MediumType.image,
      );

      if (albums.isNotEmpty) {
        Album recentAlbum = albums.first;
        MediaPage mediaPage = await recentAlbum.listMedia(
          newest: true,
          skip: 0,
          take: 1,
        );

        List<Medium> media = mediaPage.items;

        if (media.isNotEmpty) {
          Medium latestMedium = media.first;
          var file = await latestMedium.getFile();

          setState(() {
            _latestImage = file;
          });
        }
      }
    } else {
      print('Permission denied');
    }
  }

  void _showGalleryBottomSheet() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      File videoFile = File(pickedFile.path);
      if (await videoFile.length() <= 10 * 1024 * 1024) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => AddVideoPage(videoFile: videoFile),
        //   ),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video must be 10 MB or less')),
        );
      }
    }
  }

  void _switchCamera() {
    setState(() {
      _selectedCameraIndex =
          (_selectedCameraIndex + 1) % widget.cameras.length;
      _initializeCamera();
    });
  }

  void _toggleMode(bool isPhotoMode) {
    setState(() {
      _isPhotoMode = isPhotoMode;
    });
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
      _controller.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    });
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      File imgFile = File(image.path);
      img.Image? originalImage = img.decodeImage(await imgFile.readAsBytes());

      if (_selectedCameraIndex == 1) {
        img.Image fixedImage = img.flipHorizontal(originalImage!);
        imgFile.writeAsBytesSync(img.encodeJpg(fixedImage));
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddStoryPage(imageFile: imgFile),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _startVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      try {
        await _initializeControllerFuture;
        await _controller.startVideoRecording();
        setState(() {
          _isRecording = true;
        });

        // Stop recording after 10 seconds
        await Future.delayed(Duration(seconds: 10));
        _stopVideoRecording();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _stopVideoRecording() async {
    if (_controller.value.isRecordingVideo) {
      try {
        final videoFile = await _controller.stopVideoRecording();
        setState(() {
          _isRecording = false;
        });

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => AddVideoPage(videoFile: File(videoFile.path)),
        //   ),
        // );
      } catch (e) {
        print(e);
      }
    }
  }

  void _onRecordButtonPressed() {
    if (_isPhotoMode) {
      _takePicture();
    } else {
      if (_isRecording) {
        _stopVideoRecording();
      } else {
        _startVideoRecording();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          // Top bar with flash and close buttons
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _toggleFlash,
                  child: Icon(
                    _isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          // Bottom controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: _isPhotoMode
                            ? _showGalleryBottomSheet
                            : () => _showGalleryBottomSheet(),
                        child: Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(15.0),
                            shape: BoxShape.rectangle,
                            image: _latestImage != null
                                ? DecorationImage(
                              image: FileImage(_latestImage!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: _latestImage == null
                              ? Icon(Icons.photo, color: Colors.white)
                              : null,
                        ),
                      ),
                      GestureDetector(
                        onTap: _onRecordButtonPressed,
                        child: Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _switchCamera,
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.cameraswitch, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom mode switcher
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _toggleMode(true),
                        child: Text(
                          'ФОТО',
                          style: TextStyle(
                            color: _isPhotoMode
                                ? Colors.yellow
                                : Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      GestureDetector(
                        onTap: () => _toggleMode(false),
                        child: Text(
                          'ВИДЕО',
                          style: TextStyle(
                            color: !_isPhotoMode
                                ? Colors.yellow
                                : Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}