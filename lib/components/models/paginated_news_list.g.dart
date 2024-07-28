// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_news_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedNewsList _$PaginatedNewsListFromJson(Map<String, dynamic> json) =>
    PaginatedNewsList(
      newsList: (json['data'] as List<dynamic>)
          .map((e) => NewsItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedNewsListToJson(PaginatedNewsList instance) =>
    <String, dynamic>{
      'data': instance.newsList,
      'pagination': instance.pagination,
    };

NewsItem _$NewsItemFromJson(Map<String, dynamic> json) => NewsItem(
      id: json['id'] as int?,
      image: json['image'] as String?,
      shortDescription: json['shortDescription'] as String?,
      description: json['description'] as String?,
      inFavourite: json['inFavourite'] as bool?,
      title: json['title'] as String?,
      publishDate: json['publishDate'] as String?,
      commentsCount: json['commentsCount'] as int?,
      likesCount: json['likesCount'] as int?,
      viewsCount: json['viewsCount'] as int?,
    );

Map<String, dynamic> _$NewsItemToJson(NewsItem instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'shortDescription': instance.shortDescription,
      'description': instance.description,
      'image': instance.image,
      'publishDate': instance.publishDate,
      'likesCount': instance.likesCount,
      'inFavourite': instance.inFavourite,
      'viewsCount': instance.viewsCount,
      'commentsCount': instance.commentsCount,
    };

PaginatedCommentariesList _$PaginatedCommentariesListFromJson(
        Map<String, dynamic> json) =>
    PaginatedCommentariesList(
      commentariesList: (json['data'] as List<dynamic>)
          .map((e) => CommentaryFullItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedCommentariesListToJson(
        PaginatedCommentariesList instance) =>
    <String, dynamic>{
      'data': instance.commentariesList,
      'pagination': instance.pagination,
    };

UserShortDescription _$UserShortDescriptionFromJson(
        Map<String, dynamic> json) =>
    UserShortDescription(
      id: json['id'] as int?,
      name: json['name'] as String?,
      avatar: json['avatar'] == null
          ? null
          : UserProfileImage.fromJson(json['avatar'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserShortDescriptionToJson(
        UserShortDescription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
    };

UserWasAnswered _$UserWasAnsweredFromJson(Map<String, dynamic> json) =>
    UserWasAnswered(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$UserWasAnsweredToJson(UserWasAnswered instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

CommentaryItem _$CommentaryItemFromJson(Map<String, dynamic> json) =>
    CommentaryItem(
      id: json['id'] as int?,
      text: json['text'] as String?,
      leftDate: json['leftDate'] as String?,
      user: json['user'] == null
          ? null
          : UserShortDescription.fromJson(json['user'] as Map<String, dynamic>),
      userWasAnswered: json['userWasAnswered'] == null
          ? null
          : UserWasAnswered.fromJson(
              json['userWasAnswered'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentaryItemToJson(CommentaryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'leftDate': instance.leftDate,
      'user': instance.user,
      'userWasAnswered': instance.userWasAnswered,
    };

CommentaryFullItem _$CommentaryFullItemFromJson(Map<String, dynamic> json) =>
    CommentaryFullItem(
      commentary: json['comment'] == null
          ? null
          : CommentaryItem.fromJson(json['comment'] as Map<String, dynamic>),
      answers: (json['answers'] as List<dynamic>?)
          ?.map((e) => CommentaryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      answersCount: json['answersCount'] as int?,
    );

Map<String, dynamic> _$CommentaryFullItemToJson(CommentaryFullItem instance) =>
    <String, dynamic>{
      'comment': instance.commentary,
      'answers': instance.answers,
      'answersCount': instance.answersCount,
    };
