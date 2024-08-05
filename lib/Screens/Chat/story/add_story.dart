import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AddStoryPage extends StatefulWidget {
  @override
  _AddStoryPageState createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  XFile? imageFile;
  XFile? videoFile;
  XFile? latestImage;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _fetchLatestImage();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.high);
    await controller!.initialize();
    setState(() {});
  }

  Future<void> _fetchLatestImage() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      await Permission.photos.request();
    }

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        latestImage = XFile(pickedFile.path);
      }
    });
  }

  Future<void> _toggleCamera() async {
    if (controller != null && cameras != null) {
      int currentCameraIndex = cameras!.indexOf(controller!.description);
      int newCameraIndex = (currentCameraIndex + 1) % cameras!.length;
      controller = CameraController(cameras![newCameraIndex], ResolutionPreset.high);
      await controller!.initialize();
      setState(() {});
    }
  }

  Future<void> _pickFromGallery() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      await Permission.photos.request();
    }

    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageFile = XFile(pickedFile.path);
      }
    });
  }

  Future<void> _startVideoRecording() async {
    if (controller != null && controller!.value.isInitialized) {
      try {
        await controller!.startVideoRecording();
        setState(() {
          isRecording = true;
        });
        await Future.delayed(Duration(seconds: 5));
        await _stopVideoRecording();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _stopVideoRecording() async {
    if (controller != null && controller!.value.isRecordingVideo) {
      try {
        videoFile = await controller!.stopVideoRecording();
        setState(() {
          isRecording = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  void _showGalleryBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: FutureBuilder<List<XFile>>(
            future: _fetchAllImagesAndVideos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                return MasonryGridView.count(
                  crossAxisCount: 4,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(File(snapshot.data![index].path));
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Center(child: Text('No Images or Videos'));
              }
            },
          ),
        );
      },
    );
  }

  Future<List<XFile>> _fetchAllImagesAndVideos() async {
    List<XFile> mediaFiles = [];
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      mediaFiles.addAll(pickedFiles);
    }
    return mediaFiles;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Story'),
      ),
      body: Column(
        children: [
          if (controller != null && controller!.value.isInitialized)
            Expanded(
              child: CameraPreview(controller!),
            ),
          if (imageFile != null)
            Expanded(
              child: Image.file(File(imageFile!.path)),
            ),
          if (videoFile != null)
            Expanded(
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    'Video Recorded: ${videoFile!.path}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          Container(
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.flash_on, color: Colors.white),
                  onPressed: () {
                    // Flash toggle logic here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.switch_camera, color: Colors.white),
                  onPressed: _toggleCamera,
                ),
                GestureDetector(
                  onLongPress: _startVideoRecording,
                  onLongPressUp: _stopVideoRecording,
                  child: Icon(Icons.camera, color: isRecording ? Colors.red : Colors.white),
                ),
                if (latestImage != null)
                  GestureDetector(
                    onTap: () {
                      _showGalleryBottomSheet(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: FileImage(File(latestImage!.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
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