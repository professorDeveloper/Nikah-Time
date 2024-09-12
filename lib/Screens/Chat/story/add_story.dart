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
        widget.imageFile =
            File(croppedFile.path); // Convert CroppedFile to File
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
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                top: 50,
              ),
              height: double.infinity,
              width: double.infinity,
              color: Colors.yellow,
              child: const Image(
                image: NetworkImage(
                  'https://e0.pxfuel.com/wallpapers/135/106/desktop-wallpaper-%DD%8B-sosuke-aizen-iphone.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 100,
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(0, 207, 144, 1),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(
                  Icons.crop_rounded,
                  color: Colors.white,
                ),
                const Icon(
                  Icons.color_lens_rounded,
                  color: Colors.white,
                ),
                const Icon(
                  Icons.text_fields_rounded,
                  color: Colors.white,
                ),
                InkWell(
                  onTap: () {
                    //AlertDialog
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Вы уверены, что хотите опубликовать эту историю?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Только для приятелей ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  right: 10,
                                ),
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 3,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                    child: CircleAvatar(
                                      radius: 5,
                                      backgroundColor:
                                      Color.fromRGBO(0, 207, 144, 1),
                                    )),
                              )
                            ],
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Отмена',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(0, 207, 144, 1),
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Далее',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 45,
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 207, 144, 1),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Center(
                      child: Text(
                        'Далее',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}