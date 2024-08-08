import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

import '../../../components/models/story_model.dart';

class StoryViewPage extends StatelessWidget {
  final List<Story> stories;
  final int initialIndex;
  final Function(int index) onStoryViewed; // Callback to notify story viewed
  final User user; // User model containing user details


  StoryViewPage({
    required this.stories,
    required this.initialIndex,
    required this.onStoryViewed,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final controller = StoryController();

    List<StoryItem> storyItems = stories.map((story) {
      if (story.type == StoryType.image) {
        return StoryItem.pageImage(
          url: story.url,
          shown: true,
          imageFit: BoxFit.fill,
          duration: const Duration(seconds: 5), controller: controller, // Duration for images
        );
      } else if (story.type == StoryType.video) {
        return StoryItem.pageVideo(
          story.url,
          imageFit: BoxFit.fitHeight,

          controller: controller,
          duration: const Duration(seconds: 35), // Duration for videos
        );
      } else  {
        return StoryItem.text(title: "Unsupported story type",backgroundColor: Colors.black38);
      }
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          StoryView(
            storyItems:storyItems,
            controller: controller,
            repeat: false,
            onStoryShow: (s, index) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                print("Showing story at index: $index");
                onStoryViewed(index); // Notify story viewed
              });
              },
            onComplete: () {
              Navigator.pop(context); // Navigate back when all stories are completed
            },
            progressPosition: ProgressPosition.bottom,
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                Navigator.pop(context); // Close the story view on downward swipe
              }
            },
          ),
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.avatarUrl),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '6 hours ago', // You can format this to be dynamic
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Close the story view
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.black.withOpacity(0.5),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Send a message...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Handle send message action
                    },
                  ),
                  Container(
                    child: LikeButton(
                      padding: EdgeInsets.all(8.0),
                      circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: Color(0xff33b5e5),
                        dotSecondaryColor: Color(0xff0099cc),
                      ),

                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.favorite,
                          color: isLiked ? Colors.red : Colors.grey,
                        );
                      },
                      likeCount: 0,
                      countBuilder: (int? count, bool isLiked, String text) {
                        var color = isLiked ? Colors.red : Colors.grey;
                        Widget result;
                        if (count == 0) {
                          result = Text(
                            "",
                            style: TextStyle(color: color),
                          );
                        } else
                          result = Text(
                            "",
                            style: TextStyle(color: color),
                          );
                        return result;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

