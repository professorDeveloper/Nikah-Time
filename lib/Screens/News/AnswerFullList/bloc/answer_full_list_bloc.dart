part of '../answer_full_list.dart';

class AnswerFullListBloc extends Bloc<AnswerFullListEvent, AnswerFullListState> {
  AnswerFullListBloc({required List<CommentaryItem> items}) : super(AnswerFullListInitial(itemList: items)) {
    on<LoadAnswers>(_onLoadAnswers);
    on<AddAnswer>(_onAddCommentary);
  }
  String? accessToken;

  Future<void> getAccessToken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  void _onLoadAnswers(LoadAnswers event, Emitter emit) async
  {
    if(accessToken == null)
    {
      await getAccessToken();
    }

    if(CommentariesState.noMoreItem == (state as AnswerFullListInitial).answerState
        ||CommentariesState.loading == (state as AnswerFullListInitial).answerState)
    {
      return;
    }

    List<CommentaryItem> list = (state as AnswerFullListInitial).itemList.map((e) => e).toList();
    List<CommentaryItem> response = [];

    try {
      response = await NetworkService().getCommentAnswers(
        accessToken: accessToken ?? "",
        id: event.id,
        page: (state as AnswerFullListInitial).answerPage
      );

      if(response.isEmpty){
        emit((state as AnswerFullListInitial).copyThis(
          answerState: CommentariesState.noMoreItem
        ));
        return;
      }

    } catch (err) {
      emit((state as AnswerFullListInitial).copyThis(
          answerState: CommentariesState.error
      ));
    }

    for(var item in response){
      list.add(item);
    }

    emit((state as AnswerFullListInitial).copyThis(
      answerPage: (state as AnswerFullListInitial).answerPage + 1,
      itemList: list,
      answerState: response.length < 20 ? CommentariesState.noMoreItem : CommentariesState.ready
    ));
  }

  void _onAddCommentary(AddAnswer event, Emitter emit) async
  {
    if(accessToken == null)
    {
      await getAccessToken();
    }
    try {
      emit((state as AnswerFullListInitial).copyThis(
          answerState: CommentariesState.loading
      ));

      var text = event.text.trim();

      if (text.isEmpty) {
        return;
      }

      text = text.replaceAll(RegExp(r'((?<=\n)\s+)|((?<=\s)\s+)'), "");

      CommentaryItem response = await NetworkService().addCommentaryToNews(
          accessToken: accessToken ?? "",
          newsId: event.newsId,
          text: text,
          commentId: event.commentId
      );

      List<CommentaryItem> list = (state as AnswerFullListInitial).itemList.map((e) => e).toList();

      list.add(response);


      emit((state as AnswerFullListInitial).copyThis(
          itemList: list,
          answerState: CommentariesState.noMoreItem
      ));


    } catch (err) {
      emit((state as AnswerFullListInitial).copyThis(
          answerState: CommentariesState.error
      ));
    }

    /// ОБНОВЛЕНИЕ КОММЕНТАРИЯ В СПИСКЕ
  }

}
