part of '../news_item.dart';

abstract class NewsItemState extends Equatable {
  const NewsItemState();
}

class NewsItemInitial extends NewsItemState {
  final NewsItemStateEnum screenState;
  final CommentariesState commentariesState;

  final int page;

  final PaginatedCommentariesList? commentsList;
  final NewsItem? item;
  final int id;

  NewsItemInitial({
    this.screenState = NewsItemStateEnum.preload,
    this.commentariesState = CommentariesState.preload,
    this.item,
    this.commentsList,
    required this.id,
    this.page = 1,
  });

  NewsItemInitial copyThis({
    NewsItemStateEnum? screenState,
    CommentariesState? commentariesState,
    NewsItem? item,
    PaginatedCommentariesList? commentsList,
    int? page,
    int? answerPage
  }){
    return NewsItemInitial(
      screenState: screenState ?? this.screenState,
      item: item ?? this.item,
      commentariesState: commentariesState ?? this.commentariesState,
      commentsList: commentsList ?? this.commentsList,
      id: id,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [
    screenState,
    commentariesState,
    item,
    id,
    commentsList,
    page
  ];
}