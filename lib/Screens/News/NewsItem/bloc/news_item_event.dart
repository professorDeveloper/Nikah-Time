part of '../news_item.dart';

abstract class NewsItemEvent extends Equatable {
  const NewsItemEvent();
}

class LoadFullNews extends NewsItemEvent
{
  const LoadFullNews();

  @override
  List<Object?> get props => [];

}

class LoadCommenariesPage extends NewsItemEvent
{
  const LoadCommenariesPage();

  @override
  List<Object?> get props => [];

}

class AddCommentary extends NewsItemEvent
{
  final int newsId;
  final int? commentId;
  final String text;

  const AddCommentary({required this.newsId, this.commentId, required this.text});

  @override
  List<Object?> get props => [];

}

class ToggleLikeNewsItem extends NewsItemEvent
{
  final int id;

  const ToggleLikeNewsItem({required this.id});

  @override
  List<Object?> get props => [];

}