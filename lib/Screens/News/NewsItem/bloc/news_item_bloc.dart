part of '../news_item.dart';

class NewsItemBloc extends Bloc<NewsItemEvent, NewsItemState> {
  NewsItemBloc({required int id}) : super(NewsItemInitial(id: id)) {
    on<LoadFullNews>(_onLoadNews);
    on<LoadCommenariesPage>(_onLoadComments);
    on<ToggleLikeNewsItem>(_onToggleLike);
    on<AddCommentary>(_onAddCommentary);
  }

  String? accessToken;

  Future<void> getAccessToken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  void _onLoadNews(LoadFullNews event, Emitter emit) async
  {
    if(accessToken == null)
    {
      await getAccessToken();
    }
    NewsItem response;
    try {
      response = await NetworkService().getNewsItem(
        accessToken: accessToken ?? "",
        id: (state as NewsItemInitial).id
      );
      emit((state as NewsItemInitial).copyThis(
          item: response,
          screenState:  NewsItemStateEnum.ready
      ));
    } catch (err) {
      emit((state as NewsItemInitial).copyThis(
          screenState: NewsItemStateEnum.error
      ));
    }
  }

  void _onLoadComments(LoadCommenariesPage event, Emitter emit) async
  {
    if(accessToken == null)
    {
      await getAccessToken();
    }

    if(CommentariesState.noMoreItem == (state as NewsItemInitial).commentariesState
      ||CommentariesState.loading == (state as NewsItemInitial).commentariesState)
    {
      return;
    }

    emit((state as NewsItemInitial).copyThis(
        commentariesState: CommentariesState.loading
    ));
    PaginatedCommentariesList response;
    List<CommentaryFullItem> list = (state as NewsItemInitial).commentsList?.commentariesList ?? [];

    try {
      response = await NetworkService().getComments(
        accessToken: accessToken ?? "",
        id: (state as NewsItemInitial).id,
        page: (state as NewsItemInitial).page
      );

      for(var item in response.commentariesList){
        list.add(item);
      }

      emit((state as NewsItemInitial).copyThis(
        commentsList: PaginatedCommentariesList(commentariesList: list, pagination: response.pagination),
        commentariesState: (response.pagination.lastPage != (state as NewsItemInitial).page)
          ? CommentariesState.ready : CommentariesState.noMoreItem,
        page: (response.pagination.lastPage != (state as NewsItemInitial).page)
          ? (state as NewsItemInitial).page + 1 : (state as NewsItemInitial).page
      ));

    } catch (err) {
      emit((state as NewsItemInitial).copyThis(
          commentariesState: CommentariesState.error
      ));
    }
  }

  void _onAddCommentary(AddCommentary event, Emitter emit) async
  {
    if(accessToken == null)
    {
      await getAccessToken();
    }

    CommentariesState oldState = (state as NewsItemInitial).commentariesState;

    try {
      emit((state as NewsItemInitial).copyThis(
          commentariesState: CommentariesState.loading
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

      List<CommentaryFullItem> list = (state as NewsItemInitial).commentsList?.commentariesList ?? [];

      if(event.commentId == null){
        list.add(CommentaryFullItem(commentary: response, answers: [], answersCount: 0));
      }else{
        int index = list.indexWhere((element) => element.commentary!.id == event.commentId);
        CommentaryFullItem item = list[index];
        item.answers!.add(response);
        item.answersCount = (item.answersCount ?? 0) + 1;
        list[index] = item;
      }
      emit((state as NewsItemInitial).copyThis(
        commentsList: PaginatedCommentariesList(commentariesList: list, pagination: (state as NewsItemInitial).commentsList!.pagination),
        commentariesState: oldState
      ));

    } catch (err) {
      emit((state as NewsItemInitial).copyThis(
          screenState: NewsItemStateEnum.error
      ));
    }

    /// ОБНОВЛЕНИЕ КОММЕНТАРИЯ В СПИСКЕ

  }

  void _onToggleLike(ToggleLikeNewsItem event, Emitter emit) async
  {
    if(accessToken == null)
    {
      await getAccessToken();
    }
    bool response = false;

    NewsItemStateEnum oldState = (state as NewsItemInitial).screenState;

/*    try {
      response = await NetworkService().newsToggleLike(
          accessToken: accessToken ?? "",
          id: event.id
      );
      if(response == false) return;

    } catch (err) {
      return;
    }*/

    NewsItem item = (state as NewsItemInitial).item!;
    if(item.id == event.id)
    {
      item.likesCount = (item.likesCount ?? 0)
          + ((item.inFavourite != null && item.inFavourite == false) ? 1 : -1);
      item.inFavourite = !(item.inFavourite ?? false);

    }

    emit((state as NewsItemInitial).copyThis(
        item: item,
        screenState: NewsItemStateEnum.loading
    ));
    emit((state as NewsItemInitial).copyThis(
        item: item,
        screenState: oldState
    ));

  }

}
