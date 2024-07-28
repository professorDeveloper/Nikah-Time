part of '../anketes.dart';

abstract class AnketesState extends Equatable {
  const AnketesState();
}

class AnketesInitial extends AnketesState {

  final AnketasScreenState screenState;

  final List<UserProfileData> anketas;
  final bool isOnline;
  final bool isVertical;
  final bool needApplyFilter;
  final UserFilter? filterItem;
  final int loadingPage;
  final bool isSearchName;
  final String? searchName;

  AnketesInitial({
    this.screenState = AnketasScreenState.preload,
    this.isOnline = false,
    this.isVertical = true,
    this.anketas = const [],
    this.needApplyFilter = false,
    this.loadingPage = 1,
    this.filterItem,
    this.isSearchName = false,
    this.searchName,
  });

  AnketesInitial copyThis({
    AnketasScreenState? screenState,
    List<UserProfileData>? anketas,
    bool? isOnline,
    bool? isVertical,
    bool? needApplyFilter,
    UserFilter? filterItem,
    int? loadingPage,
    bool? isSearchName,
    String? searchName,
  }){
    return AnketesInitial(
      screenState: screenState ?? this.screenState,
      anketas: anketas ?? this.anketas,
      isOnline: isOnline ?? this.isOnline,
      isVertical: isVertical ?? this.isVertical,
      needApplyFilter: needApplyFilter ?? this.needApplyFilter,
      filterItem: filterItem ?? this.filterItem,
      loadingPage: loadingPage ?? this.loadingPage,
      isSearchName: isSearchName ?? this.isSearchName,
      searchName: searchName ?? this.searchName,
    );
  }

  @override
  List<Object?> get props => [
    screenState,
    anketas,
    isOnline,
    isVertical,
    needApplyFilter,
    filterItem,
    loadingPage,
    isSearchName,
    searchName,
  ];
}
