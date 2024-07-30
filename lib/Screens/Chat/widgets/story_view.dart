import 'package:flutter/material.dart';
import 'package:flutter_story/flutter_story.dart';

class StoryViewPage extends StatefulWidget {
  final int index;

  StoryViewPage({required this.index});

  @override
  State<StoryViewPage> createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage> {
  StoryController storyController = StoryController();
  late List<StoryModel> stories;

  @override
  void initState() {
    super.initState();
    stories = getStories();
  }

  @override
  void dispose() {
    super.dispose();
    storyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:           Story.builder(
          controller: storyController,
          itemCount: stories.length,
          itemBuilder: (context, index) {
            StoryModel s = stories[index];
            return StoryUser(
              avatar: s.avatar,
              label: s.label,
              children: s.cards == null
                  ? []
                  : s.cards!
                  .map((card) => StoryCard(
                onVisited: (cardIndex) {
                  setState(() {
                    card.visited = true;
                  });
                },
                footer: StoryCardFooter(
                  messageBox: StoryCardMessageBox(
                    child: Center(
                      child: SizedBox(
                        width:
                        MediaQuery.of(context).size.width /
                            1.5,
                        height:
                        MediaQuery.of(context).size.width /
                            1.5,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                MaterialButton(
                                  minWidth: 0,
                                  padding: EdgeInsets.zero,
                                  shape: const CircleBorder(),
                                  child: const Text(
                                    "😂",
                                    style:
                                    TextStyle(fontSize: 32),
                                  ),
                                  onPressed: () {},
                                ),
                                MaterialButton(
                                  minWidth: 0,
                                  padding: EdgeInsets.zero,
                                  shape: const CircleBorder(),
                                  child: const Text(
                                    "😮",
                                    style:
                                    TextStyle(fontSize: 32),
                                  ),
                                  onPressed: () {},
                                ),
                                MaterialButton(
                                  minWidth: 0,
                                  padding: EdgeInsets.zero,
                                  shape: const CircleBorder(),
                                  child: const Text(
                                    "😍",
                                    style:
                                    TextStyle(fontSize: 32),
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                MaterialButton(
                                  minWidth: 0,
                                  padding: EdgeInsets.zero,
                                  shape: const CircleBorder(),
                                  child: const Text(
                                    "😢",
                                    style:
                                    TextStyle(fontSize: 32),
                                  ),
                                  onPressed: () {},
                                ),
                                MaterialButton(
                                  minWidth: 0,
                                  padding: EdgeInsets.zero,
                                  shape: const CircleBorder(),
                                  child: const Text(
                                    "👏",
                                    style:
                                    TextStyle(fontSize: 32),
                                  ),
                                  onPressed: () {},
                                ),
                                MaterialButton(
                                  minWidth: 0,
                                  padding: EdgeInsets.zero,
                                  shape: const CircleBorder(),
                                  child: const Text(
                                    "🔥",
                                    style:
                                    TextStyle(fontSize: 32),
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  likeButton: StoryCardLikeButton(
                    onLike: (cardLike) {},
                  ),
                  forwardButton: StoryCardForwardButton(
                    onForward: (cardIndex) {},
                  ),
                ),
                color: card.color,
                visited: card.visited,
                cardDuration: card.duration,
                childOverlay: card.childOverlay,
                child: card.child,
              ))
                  .toList(),
            );
          }),
    );
  }

  List<StoryModel> getStories() {
    List<StoryModel> storyList = [];
    for (int i = 1; i <= 10; i++) {
      storyList.add(StoryModel(
          images:
          "https://i.pinimg.com/originals/e5/14/c7/e514c70eb8c16ad290484fd1ec067d45.jpg",
          id: i + 2,
          avatar: Image.network(
              "https://i.pinimg.com/originals/b2/38/27/b238275379a01045c14d7208be80acd3.jpg"),
          label: Text(
            userLabel(i),
            style: const TextStyle(color: Colors.black),
          ),
          cards: [
            storyCard2(i),
          ]));
    }
    return storyList;
  }

  String userLabel(int storyIndex) {
    String label = "";
    switch (storyIndex) {
      case 1:
        return "Oliver";
      case 2:
        return "Liam";
      case 3:
        return "Benjamin";
      case 4:
        return "James";
      case 5:
        return "Alexander";
      case 6:
        return "John";
      case 7:
        return "Ava";
      case 8:
        return "Emma";
      case 9:
        return "Ava";
      case 10:
        return "Lili";
    }
    return label;
  }

  StoryCardModel storyCard2(int i) => StoryCardModel(
    child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff616161), Color(0xff767676)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                "Saikou",
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Image.network("https://i.pinimg.com/originals/e5/14/c7/e514c70eb8c16ad290484fd1ec067d45.jpg"),
          const SizedBox(height: 10),
          Container(
            width: 250,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.red.withAlpha(150),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: const Center(
              child: Text(
                "This is a container widget",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 350,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
                border: Border.all(color: Colors.white, width: 1)),
            child: Center(
              child: Text(
                "This is a container widget",
                style:
                TextStyle(color: Colors.white, fontSize: 20, shadows: [
                  Shadow(
                      color: Colors.black.withAlpha(150),
                      blurRadius: 20,
                      offset: const Offset(0, 0))
                ]),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              "Story $i",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                shadows: [
                  Shadow(
                      color: Colors.red,
                      blurRadius: 20,
                      offset: Offset(0, 0))
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class StoryModel {
  StoryModel({
    this.id,
    this.avatar,
    this.images,
    this.label,
    this.cards,
  });

  String? images;

  int? id;
  Widget? avatar;
  Text? label;
  List<StoryCardModel>? cards;
}

class StoryCardModel {
  StoryCardModel({
    this.visited = false,
    this.duration = const Duration(seconds: 5),
    this.color = const Color(0xff333333),
    this.childOverlay,
    this.child,
  });

  bool visited;
  Duration duration;
  Color color;
  Widget? childOverlay;
  Widget? child;
}
