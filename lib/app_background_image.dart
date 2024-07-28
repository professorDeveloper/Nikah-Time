import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';

class AppBackgroundImage {
  var image = const AssetImage('assets/icons/background_image.png');

  static final AppBackgroundImage _appBackgroundImage = AppBackgroundImage._internal();

  factory AppBackgroundImage() {
    return _appBackgroundImage;
  }

  AppBackgroundImage._internal();

  static AppBackgroundImage get instance => _appBackgroundImage;

  Future precacheBackgroundImage(
    BuildContext context, {
      Size? size,
      void Function(Object, StackTrace?)? onError,
    }
  ) {
    return precacheImage(
        image,
        context,
        size: size,
        onError: onError
    );
  }

  Widget buildFadeInBackgroundImage() {
    return _FadeInBackgroundImage(image);
  }
}

class _FadeInBackgroundImage extends StatefulWidget {
  final AssetImage _image;

  const _FadeInBackgroundImage(this._image);

  @override
  createState() => _FadeInBackgroundImageState(_image);
}

class _FadeInBackgroundImageState extends State<_FadeInBackgroundImage> {
  final AssetImage _image;

  _FadeInBackgroundImageState(this._image);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: const Color(0xFFFFFFFF),
          height: double.infinity,
          width: double.infinity,
        ),
        FadeInImage(
          image: _image,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: MemoryImage(kTransparentImage),
          fadeInDuration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}