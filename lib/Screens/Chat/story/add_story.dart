import 'dart:io';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path/path.dart';

class AddStoryPage extends StatefulWidget {
  final File imageFile;

  AddStoryPage({required this.imageFile});

  @override
  _AddStoryPageState createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  late File _editedImage;
  TextEditingController _textEditingController = TextEditingController();
  bool _showEmojiPicker = false;
  List<Filter> filters = presetFiltersList;

  @override
  void initState() {
    super.initState();
    _editedImage = widget.imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Display the edited image
            Image.file(
              _editedImage,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // Overlay text on the image
            if (_textEditingController.text.isNotEmpty)
              Positioned(
                left: 20,
                top: 20,
                child: Text(
                  _textEditingController.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // Bottom bar with actions
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                color: Colors.black.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    GradientStrokeButton(
                      icon: Icons.arrow_back,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // Action icons
                    IconButton(
                      icon: Icon(Icons.crop, color: Colors.white),
                      onPressed: () => _cropImage(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.auto_awesome, color: Colors.white),
                      onPressed: () => _applyFilter(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.text_fields, color: Colors.white),
                      onPressed: () => _addText(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.emoji_emotions, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _showEmojiPicker = !_showEmojiPicker;
                        });
                      },
                    ),
                    // Next button
                    NextButton(
                      text: 'Далее',
                      onPressed: () {
                        // Add your post story logic here
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Emoji picker
            if (_showEmojiPicker)
              Align(
                alignment: Alignment.bottomCenter,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    _textEditingController.text += emoji.emoji;
                  },
                  config: Config(
                    columns: 7,
                    emojiSizeMax: 32,
                    bgColor: Colors.black,
                    indicatorColor: Colors.white,
                    iconColorSelected: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _cropImage(BuildContext context) async {
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: _editedImage.path,
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );

    if (cropped != null) {
      setState(() {
        _editedImage = File(cropped.path);
      });
    }
  }

  Future<void> _applyFilter(BuildContext context) async {
    var image = imageLib.decodeImage(_editedImage.readAsBytesSync());
    image = imageLib.copyResize(image!, width: 600);

    Map imageFile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoFilterSelector(
          title: Text("Apply Filter"),
          image: image!,
          filters: filters,
          filename: basename(_editedImage.path),
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imageFile.containsKey('image_filtered')) {
      setState(() {
        _editedImage = imageFile['image_filtered'];
      });
    }
  }

  void _addText(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text("Add Text", style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _textEditingController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter your text",
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: Text("OK", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

// Custom widget to create a gradient stroke button with border color
class GradientStrokeButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  GradientStrokeButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 2,
          color: Colors.white,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        padding: EdgeInsets.all(0),
      ),
    );
  }
}

// Custom widget for the "Next" button
class NextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  NextButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff1EC760),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}