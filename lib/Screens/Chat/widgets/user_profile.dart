import 'package:flutter/material.dart';
import 'package:untitled/Screens/Chat/widgets/story_view.dart';

import '../../../components/models/story_model.dart';
import 'my_story_view.dart';

class UserProfile extends StatefulWidget {
  final User user;

  UserProfile({required this.user});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // Function to update the viewed status of all stories
  void _updateViewed() {
    setState(() {
      for (var story in widget.user.stories) {
        story.isViewed = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool allStoriesViewed =
        widget.user.stories.every((story) => story.isViewed);
    Color borderColor = allStoriesViewed ? Colors.grey : Colors.white;
    LinearGradient borderGradient = allStoriesViewed
        ? LinearGradient(colors: [Colors.grey, Colors.grey])
        : LinearGradient(colors: [Color(0xffFB457E), Color(0xff8048F9)]);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          _updateViewed(); // Update all stories as viewed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget.user.userType == UserType.self
                  ? MyStoryViewPage(
                      stories: widget.user.stories,
                      user: widget.user,
                    )
                  : StoryViewPage(
                      stories: widget.user.stories,
                      initialIndex: 0,
                      onStoryViewed: (index) {
                        _updateViewed(); // Update story status when any story is viewed
                      },
                      user: widget.user, // Pass the user here
                    ),
            ),
          ).then((_) {
            // Refresh the UI after returning to the main page
            setState(() {});
          });
        },
        //     builder: (context) => user.userType == UserType.self
        //         ? StoryViewPage(stories: user.stories, initialIndex: 0)
        //         : StoryViewPage(stories: user.stories, initialIndex: 0),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: borderGradient,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(widget.user.avatarUrl),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              widget.user.name,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
