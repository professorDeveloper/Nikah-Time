import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;
import 'add_story.dart';

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
      enableAudio: false,
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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddStoryPage(imageFile: File(pickedFile.path)),
        ),
      );
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

  void _takePicture() async {
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
                        onTap: _showGalleryBottomSheet,
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
                        onTap: _takePicture,
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

              ],
            ),
          ),
        ],
      ),
    );
  }
}