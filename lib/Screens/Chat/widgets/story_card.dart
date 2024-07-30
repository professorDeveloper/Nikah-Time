import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Screens/Chat/widgets/story_view.dart';

StoryCardModel storyCard1(int i) => StoryCardModel(
  color: Color(0xff616161),
  childOverlay: Container(

    margin: const EdgeInsets.all(50),
    child: const Center(
      child: Text(
        "Lorem Ipsum is simply dummy text of the printing "
            "and typesetting industry. Lorem Ipsum has been the industry's "
            "standard dummy text ever since the 1500s, when an unknown "
            "printer took a galley of type and scrambled it to "
            "make a type specimen book. It has survived not only five centuries,"
            " but also the leap into electronic typesetting, "
            "remaining essentially unchanged. It was popularised in the 1960s "
            "with the release of Letraset sheets containing "
            "Lorem Ipsum passages, and more recently with "
            "desktop publishing software like Aldus PageMaker "
            "including versions of Lorem Ipsum.",
        style: TextStyle(color: Colors.greenAccent, fontSize: 20, height: 1.5),
      ),
    ),
  ),
);
StoryCardModel storyCard2(String image) => StoryCardModel(
  child: Scaffold(
    backgroundColor: Color(0xff616161),
    body: Image.network(image,      fit: BoxFit.cover, // centerCrop ga o'xshash
    ),
  ),
);