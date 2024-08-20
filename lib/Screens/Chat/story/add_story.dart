import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class AddStoryPage extends StatefulWidget {
  File imageFile;

  AddStoryPage({required this.imageFile});

  @override
  _AddStoryPageState createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  TextEditingController _textController = TextEditingController();
  List<Widget> _stickers = [];
  List<Map<String, dynamic>> _texts = [];
  Color _selectedColor = Colors.white;
  double _fontSize = 24;
  double _currentSliderValue = 24;

  Future<void> _cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: widget.imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
    );

    if (croppedFile != null) {
      setState(() {
        widget.imageFile = File(croppedFile.path); // Convert CroppedFile to File
      });
    }
  }

  void _addText() {
    _textController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textController,
                style: TextStyle(color: _selectedColor, fontSize: _fontSize),
                decoration: InputDecoration(
                  hintText: 'Enter text',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => {},
                    child: Container(
                      height: 40,
                      width: 40,
                      color: _selectedColor,
                    ),
                  ),
                  Slider(
                    value: _currentSliderValue,
                    min: 12,
                    max: 72,
                    activeColor: Colors.white,
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                        _fontSize = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _texts.add({
                          'text': _textController.text,
                          'color': _selectedColor,
                          'size': _fontSize,
                          'top': 200.0,
                          'left': 100.0,
                          'rotation': 0.0,
                        });
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  void _addSticker() {
    setState(() {
      _stickers.add(
        Positioned(
          top: 150,
          left: 150,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _stickers[_stickers.length - 1] = Positioned(
                  top: details.localPosition.dy,
                  left: details.localPosition.dx,
                  child: _stickers[_stickers.length - 1],
                );
              });
            },
            child: Image.asset(
              'assets/sticker.png', // Replace with your sticker asset
              width: 100,
            ),
          ),
        ),
      );
    });
  }

  void _onTextDrag(int index, DragUpdateDetails details) {
    setState(() {
      _texts[index]['top'] += details.delta.dy;
      _texts[index]['left'] += details.delta.dx;
    });
  }

  void _onTextRotate(int index, double angle) {
    setState(() {
      _texts[index]['rotation'] += angle;
    });
  }

  void _onTextScale(int index, double scale) {
    setState(() {
      _texts[index]['size'] *= scale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Story', style: TextStyle(color: Colors.blue)),
      ),
      body: Stack(
        children: [
          Image.file(
            widget.imageFile,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          ..._stickers, // Display all stickers
          ..._texts.map((textMap) {
            int index = _texts.indexOf(textMap);
            return Positioned(
              top: textMap['top'],
              left: textMap['left'],
              child: GestureDetector(
                onPanUpdate: (details) => _onTextDrag(index, details),
                onLongPress: () {
                  // Allow scaling and rotation if needed
                },
                child: Transform.rotate(
                  angle: textMap['rotation'],
                  child: Text(
                    textMap['text'],
                    style: TextStyle(
                      color: textMap['color'],
                      fontSize: textMap['size'],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.crop, color: Colors.white),
                  onPressed: _cropImage,
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.text_fields, color: Colors.white),
                  onPressed: _addText,
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.sticky_note_2, color: Colors.white),
                  onPressed: _addSticker,
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Next action
              },
              child: Text('Далее', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}