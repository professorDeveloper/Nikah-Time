part of '../answer_full_list.dart';


abstract class AnswerFullListState extends Equatable {
  const AnswerFullListState();
}

class AnswerFullListInitial extends AnswerFullListState {

  final CommentariesState answerState;
  final int answerPage;
  final List<CommentaryItem> itemList;

  AnswerFullListInitial({
    this.answerState = CommentariesState.preload,
    this.answerPage = 1,
    this.itemList = const []
  });

  AnswerFullListInitial copyThis({
    CommentariesState? answerState,
    int? answerPage,
    List<CommentaryItem>? itemList
  }){
    return AnswerFullListInitial(
      answerState: answerState ?? this.answerState,
      answerPage: answerPage ?? this.answerPage,
      itemList: itemList ?? this.itemList
    );
  }

  @override
  List<Object> get props => [
    answerState,
    answerPage,
    itemList
  ];
}
