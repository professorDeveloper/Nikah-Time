import 'package:json_annotation/json_annotation.dart';
import 'package:untitled/components/models/pagination.dart';
import 'package:untitled/components/models/user_profile_data.dart';

part 'paginated_news_list.g.dart';

@JsonSerializable()
class PaginatedNewsList {
  @JsonKey(name: "data")
  final List<NewsItem> newsList;

  final Pagination pagination;

  PaginatedNewsList({required this.newsList, required this.pagination});

  factory PaginatedNewsList.fromJson(Map<String, dynamic> json) => _$PaginatedNewsListFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedNewsListToJson(this);
}

@JsonSerializable()
class NewsItem {

  int? id;
  String? title;
  String? shortDescription;
  String? description;
  String? image;
  String? publishDate;
  int? likesCount;
  bool? inFavourite;
  int? viewsCount;
  int? commentsCount;

  NewsItem({
    this.id,
    this.image,
    this.shortDescription,
    this.description,
    this.inFavourite,
    this.title,
    this.publishDate,
    this.commentsCount,
    this.likesCount,
    this.viewsCount,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) => _$NewsItemFromJson(json);

  Map<String, dynamic> toJson() => _$NewsItemToJson(this);
}


@JsonSerializable()
class PaginatedCommentariesList {
  @JsonKey(name: "data")
  final List<CommentaryFullItem> commentariesList;

  final Pagination pagination;

  PaginatedCommentariesList({required this.commentariesList, required this.pagination});

  factory PaginatedCommentariesList.fromJson(Map<String, dynamic> json) => _$PaginatedCommentariesListFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedCommentariesListToJson(this);
}


@JsonSerializable()
class UserShortDescription {

  int? id;
  String? name;
  UserProfileImage? avatar;


  UserShortDescription({
    this.id,
    this.name,
    this.avatar,
  });

  factory UserShortDescription.fromJson(Map<String, dynamic> json) => _$UserShortDescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$UserShortDescriptionToJson(this);
}

@JsonSerializable()
class UserWasAnswered {

  int? id;
  String? name;

  UserWasAnswered({
    this.id,
    this.name,
  });

  factory UserWasAnswered.fromJson(Map<String, dynamic> json) => _$UserWasAnsweredFromJson(json);

  Map<String, dynamic> toJson() => _$UserWasAnsweredToJson(this);
}

@JsonSerializable()
class CommentaryItem {

  int? id;
  String? text;
  String? leftDate;
  UserShortDescription? user;
  UserWasAnswered? userWasAnswered;

  CommentaryItem({
    this.id,
    this.text,
    this.leftDate,
    this.user,
    this.userWasAnswered,
  });

  factory CommentaryItem.fromJson(Map<String, dynamic> json) => _$CommentaryItemFromJson(json);

  Map<String, dynamic> toJson() => _$CommentaryItemToJson(this);
}

@JsonSerializable()
class CommentaryFullItem {
  @JsonKey(name: "comment")
  CommentaryItem? commentary;
  List<CommentaryItem>? answers;
  int? answersCount;
  @JsonKey(ignore: true)
  int answerPage;

  CommentaryFullItem({
    this.commentary,
    this.answers,
    this.answersCount,
    this.answerPage = 1
  });

  factory CommentaryFullItem.fromJson(Map<String, dynamic> json) => _$CommentaryFullItemFromJson(json);

  Map<String, dynamic> toJson() => _$CommentaryFullItemToJson(this);
}