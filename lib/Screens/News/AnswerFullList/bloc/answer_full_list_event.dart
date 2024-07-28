part of '../answer_full_list.dart';

abstract class AnswerFullListEvent extends Equatable {
  const AnswerFullListEvent();
}


class LoadAnswers extends AnswerFullListEvent
{
  final int id;

  const LoadAnswers({required this.id});

  @override
  List<Object?> get props => [];

}

class AddAnswer extends AnswerFullListEvent
{
  final int newsId;
  final int? commentId;
  final String text;

  const AddAnswer({required this.newsId, this.commentId, required this.text});

  @override
  List<Object?> get props => [];

}