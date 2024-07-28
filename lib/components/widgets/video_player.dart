import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/generated/locale_keys.g.dart';
import 'package:video_player/video_player.dart';


class VideoPlayerScreen extends StatefulWidget{
  VideoPlayerScreen(this.uri,
    {
      super.key,
      int? photoOwnerId
    }
  )
  {
    this.photoOwnerId = photoOwnerId!;
  }

  String uri;
  late int photoOwnerId;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        widget.uri,
    )..initialize().then((_) {
      setState(() {
        _controller.play();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: (){
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),)
            : vaitBox(),
      ),
    );
  }

  Widget vaitBox(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
        const SizedBox(height: 16,),
        Text(
          LocaleKeys.common_videoWaitBox,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.white,
          ),
        ).tr(),
      ],
    );
  }

}
