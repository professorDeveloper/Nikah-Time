part of '../news.dart';

abstract class NewsState extends Equatable {
  const NewsState();
}

class NewsInitial extends NewsState {
  final NewsScreenStateEnum screenState;
  final int loadingPage;
  final String? searchValue;
  final List<NewsItem> items;


  NewsInitial({
    this.screenState = NewsScreenStateEnum.preload,
    this.loadingPage = 1,
    this.searchValue,
    this.items = const []
  });

  NewsInitial copyThis({
    NewsScreenStateEnum? screenState,
    int? loadingPage,
    String? searchValue,
    List<NewsItem>? items
  }){
    return NewsInitial(
      screenState: screenState ?? this.screenState,
      loadingPage: loadingPage ?? this.loadingPage,
      searchValue: searchValue ?? this.searchValue,
      items: items ?? this.items
    );
  }

  @override
  List<Object?> get props => [
    screenState,
    loadingPage,
    searchValue,
    items
  ];
}
