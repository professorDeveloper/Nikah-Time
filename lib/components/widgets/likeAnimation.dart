import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter/cupertino.dart';

class LikeAnimationWidget extends StatefulWidget {
  LikeAnimationWidget(this.show, {this.onCompleted});

  final void Function()? onCompleted;

  bool show;
  @override
  State<LikeAnimationWidget> createState() => LikeAnimationWidgetState();
}

class LikeAnimationWidgetState extends State<LikeAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool show = true;

  @override
  void initState() {
    debugPrint("init chat_main_menu");
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          widget.show = true;
        });
      }
      if (status == AnimationStatus.completed) {
        setState(() {
          widget.show = false;
          if (widget.onCompleted != null) {
            widget.onCompleted!();
          }
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Visibility(
          visible: widget.show,
          child: Lottie.asset(
            'assets/icons/likeAnimation.json',
            frameRate: FrameRate.max,
            controller: _controller,
            onLoaded: (composition) {
              // Configure the AnimationController with the duration of the
              // Lottie file and start the animation.
              _controller
                ..duration = composition.duration
                ..reset()
                ..forward();
            },
          )),
    );
  }
}
