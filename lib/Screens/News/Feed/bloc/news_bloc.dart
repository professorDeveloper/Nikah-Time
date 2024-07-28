part of '../news.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial()) {
    on<LoadNews>(_onLoadNews);
    on<ToggleLike>(_onToggleLike);
    on<MakeSeen>(_onMakeSeen);
    on<SetNewSearchValue>(_onSetNewSearchValue);
  }

  String? accessToken;

  Future<void> getAccessToken() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  void _onLoadNews(LoadNews event, Emitter emit) async
  {
    if(accessToken == null)
    {
      await getAccessToken();
    }

    if((state as NewsInitial).screenState == NewsScreenStateEnum.noMoreItem)
    {
      return;
    }

    List<NewsItem> receivedNews = (state as NewsInitial).items.map((e) => e).toList();

    try {
      PaginatedNewsList response = await NetworkService().getNews(
          accessToken: accessToken ?? "",
          searchString: (state as NewsInitial).searchValue ?? "",
          page: (state as NewsInitial).loadingPage
      );

      receivedNews.addAll(response.newsList);
      if(response.newsList.isEmpty || response.newsList.length < 20)
      {
        emit((state as NewsInitial).copyThis(
          items: receivedNews,
          loadingPage: (state as NewsInitial).loadingPage,
          screenState: NewsScreenStateEnum.noMoreItem
        ));
        return;
      }

    } catch (err) {
      emit((state as NewsInitial).copyThis(
          items: [],
          screenState: NewsScreenStateEnum.error
      ));
    }



    emit((state as NewsInitial).copyThis(
        items: receivedNews,
        loadingPage: (state as NewsInitial).loadingPage + 1,
        screenState: NewsScreenStateEnum.ready
    ));
  }

  void _onSetNewSearchValue(SetNewSearchValue event, Emitter emit) async
  {
    if(event.searchValue == null)
    {
      emit(NewsInitial());
      return;
    }
    emit((state as NewsInitial).copyThis(
      items: [],
      searchValue: event.searchValue,
      screenState: NewsScreenStateEnum.preload,
      loadingPage: 1
    ));

  }

  void _onToggleLike(ToggleLike event, Emitter emit) async
  {
    if(accessToken == null)
    {
      await getAccessToken();
    }
    bool response = false;

    NewsScreenStateEnum oldState = (state as NewsInitial).screenState;

    try {
      response = await NetworkService().newsToggleLike(
          accessToken: accessToken ?? "",
          id: event.id
      );
      if(response == false) return;

    } catch (err) {
      return;
    }

    List<NewsItem> receivedNews = (state as NewsInitial).items.map((e) => e).toList();
    for(int i = 0; i < receivedNews.length; i++)
      {
        if(receivedNews[i].id == event.id)
          {
            receivedNews[i].likesCount = (receivedNews[i].likesCount ?? 0)
                + ((receivedNews[i].inFavourite != null && receivedNews[i].inFavourite == false) ? 1 : -1);
            receivedNews[i].inFavourite = !(receivedNews[i].inFavourite ?? false);

          }
      }

    emit((state as NewsInitial).copyThis(
        items: receivedNews,
        screenState: NewsScreenStateEnum.loading
    ));
    emit((state as NewsInitial).copyThis(
        items: receivedNews,
        screenState: oldState
    ));

  }

  void _onMakeSeen(MakeSeen event, Emitter emit) async
  {
    if(accessToken == null)
    {
      await getAccessToken();
    }
    bool response = false;
    NewsScreenStateEnum oldState = (state as NewsInitial).screenState;

    try {
      response = await NetworkService().newsMakeSeen(
          accessToken: accessToken ?? "",
          id: event.id
      );
      if(response == false) return;

    } catch (err) {
      return;
    }

    List<NewsItem> receivedNews = (state as NewsInitial).items.map((e) => e).toList();
    for(int i = 0; i < receivedNews.length; i++)
    {
      if(receivedNews[i].id == event.id)
      {
        receivedNews[i].viewsCount = (receivedNews[i].viewsCount ?? 0) + 1;
      }
    }

    emit((state as NewsInitial).copyThis(
        items: receivedNews,
        screenState: NewsScreenStateEnum.loading
    ));
    emit((state as NewsInitial).copyThis(
        items: receivedNews,
        screenState: oldState
    ));

  }

}
