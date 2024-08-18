import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

import '../../../components/models/story_model.dart';

class MyStoryViewPage extends StatefulWidget {
  final List<Story> stories;
  final User user;

  MyStoryViewPage({
    required this.stories,
    required this.user,
  });

  @override
  _MyStoryViewPageState createState() => _MyStoryViewPageState();
}

class _MyStoryViewPageState extends State<MyStoryViewPage> {
  final StoryController _controller = StoryController();

  List<Viewer> viewers = [
    Viewer(name: "User 3", avatarUrl: "https://i.pinimg.com/originals/4f/b9/aa/4fb9aab9e97f2f04d3045d9fa7b17482.jpg", viewedAt: "Сегодня в 13:22"),
    Viewer(name: "User 3", avatarUrl: "https://i.pinimg.com/originals/4f/b9/aa/4fb9aab9e97f2f04d3045d9fa7b17482.jpg", viewedAt: "Сегодня в 12:42"),
    Viewer(name: "User 3", avatarUrl: "https://i.pinimg.com/originals/4f/b9/aa/4fb9aab9e97f2f04d3045d9fa7b17482.jpg", viewedAt: "Сегодня в 11:42"),
    Viewer(name: "User 3", avatarUrl: "https://i.pinimg.com/originals/4f/b9/aa/4fb9aab9e97f2f04d3045d9fa7b17482.jpg", viewedAt: "Сегодня в 11:32"),
    Viewer(name: "User 3", avatarUrl: "https://i.pinimg.com/originals/4f/b9/aa/4fb9aab9e97f2f04d3045d9fa7b17482.jpg", viewedAt: "Сегодня в 11:12"),
    Viewer(name: "User 3", avatarUrl: "https://i.pinimg.com/originals/4f/b9/aa/4fb9aab9e97f2f04d3045d9fa7b17482.jpg", viewedAt: "Сегодня в 10:07"),
  ];

  @override
  Widget build(BuildContext context) {
    List<StoryItem> storyItems = widget.stories.map((story) {
      if (story.type == StoryType.image) {
        return StoryItem.pageImage(
          url: story.url,
          controller: _controller,
        );
      } else if (story.type == StoryType.video) {
        return StoryItem.pageVideo(
          story.url,
          controller: _controller,
        );
      } else {
        return StoryItem.text(
          title: "Unsupported story type",
          backgroundColor: Colors.black38,
        );
      }
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          StoryView(
            storyItems: storyItems,
            controller: _controller,
            repeat: false,
            onComplete: () {
              Navigator.pop(context); // Navigate back when all stories are completed
            },
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                Navigator.pop(context); // Close the story view on downward swipe
              } else if (direction == Direction.up) {
                _showViewersDialog();
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
                      backgroundImage: NetworkImage(widget.user.avatarUrl),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      _showDeleteConfirmationDialog();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_red_eye, color: Colors.white),
                    onPressed: () {
                      _showViewersDialog();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Вы уверены, что хотите удалить историю?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Оставить'),
            ),
            TextButton(
              onPressed: () {
                // Handle delete action
                Navigator.of(context).pop();
                Navigator.pop(context); // Close the story view after deletion
              },
              child: Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  void _showViewersDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${viewers.length} посмотревших'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: viewers.length,
              itemBuilder: (context, index) {
                final viewer = viewers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(viewer.avatarUrl),
                  ),
                  title: Text(viewer.name),
                  subtitle: Text(viewer.viewedAt),
                  trailing: Icon(Icons.favorite, color: Colors.red),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class Viewer {
  final String name;
  final String avatarUrl;
  final String viewedAt;

  Viewer({required this.name, required this.avatarUrl, required this.viewedAt});
}