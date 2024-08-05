enum StoryType { image, video }

enum UserType { self, others }

class Story {
  final String url;
  final StoryType type;
  bool isViewed;
  bool isLiked;

  Story(
      {required this.url,
      required this.type,
      this.isViewed = false,
      this.isLiked = false});
}

class User {
  final String name;
  final String avatarUrl;
  final List<Story> stories;
  final UserType userType;

  User(
      {required this.name,
      required this.avatarUrl,
      required this.stories,
      required this.userType});
}
