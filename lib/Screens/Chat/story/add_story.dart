import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddStoryPage extends StatefulWidget {
  @override
  _AddStoryPageState createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  String _storyText = '';
  XFile? _storyImage;
  final ImagePicker _picker = ImagePicker();
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;

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
      appBar: AppBar(
        title: Text('Add Story'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _postStory,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_storyImage != null)
            Image.file(
              File(_storyImage!.path),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
          else if (_isCameraInitialized)
            CameraPreview(_cameraController!)
          else
            Center(child: CircularProgressIndicator()),
          if (_storyText.isNotEmpty)
            Center(
              child: Text(
                _storyText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          _buildBottomToolbar(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: _capturePhoto,
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.text_fields),
              onPressed: _addText,
              color: Colors.white,
            ),
            IconButton(
              icon: Icon(Icons.photo),
              onPressed: _pickImage,
              color: Colors.white,
            ),
            // Additional icons for stickers, etc., can be added here
          ],
        ),
      ),
    );
  }

  Future<void> _addText() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _TextInputDialog(),
    );

    if (result != null) {
      setState(() {
        _storyText = result;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _storyImage = pickedFile;
        _cameraController?.dispose();
        _isCameraInitialized = false;
      });
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      final image = await _cameraController!.takePicture();
      setState(() {
        _storyImage = image;
        _cameraController?.dispose();
        _isCameraInitialized = false;
      });
    }
  }

  void _postStory() {
    // Handle posting the story here
    print('Story Posted');
    print('Text: $_storyText');
    if (_storyImage != null) {
      print('Image: ${_storyImage!.path}');
    }
  }
}

class _TextInputDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _text = '';

    return AlertDialog(
      title: Text('Enter Text'),
      content: TextField(
        onChanged: (value) {
          _text = value;
        },
        decoration: InputDecoration(hintText: 'Type your story text here'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_text);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}