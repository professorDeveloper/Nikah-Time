import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoryItem extends StatelessWidget {
  final String imageUrl;

  StoryItem({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xffFB457E),Color(0xff8048F9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'User',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}