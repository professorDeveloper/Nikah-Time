part of '../anketes.dart';

class AnketesBloc extends Bloc<AnketesEvent, AnketesState> {
  AnketesBloc() : super(AnketesInitial()) {
    on<LoadAnketas>(_onLoadAnketas);
    on<SwitchShowMode>(_onSwitchShowMode);
    on<ResetAnketas>(_onResetAnketas);
    on<LoadFilter>(_onLoadFilter);
    on<SwitchSearchMode>(_onSwitchSearchMode);
    on<SetupSearchName>(_onSetupSearchName);
    on<ClearSearchName>(_onClearSearchName);
    on<OnRefresh>(_onRefreshPage);
    add(const LoadAnketas());
  }

  String? accessToken;

  Future<void> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("token") ?? "";
  }

  void _onRefreshPage(OnRefresh event, Emitter emit) async {
    PaginatedUserList response;
    List<UserProfileData> receivedAnketas = [];
    response = await NetworkService().searchUsers(
      accessToken: accessToken ?? "",
      filter: (state as AnketesInitial).filterItem ?? UserFilter(),
      isExpandedFilter: (state as AnketesInitial).needApplyFilter,
      page: 0 + Random().nextInt(3 - 0),
      // exceptIds: receivedAnketas.map((e) => e.id ?? 0).toList()
    );
    receivedAnketas.addAll(response.users as Iterable<UserProfileData>);
    print(response);
    emit((state as AnketesInitial).copyThis(
        anketas: receivedAnketas,
        // loadingPage: (state as AnketesInitial).loadingPage + 1,
        screenState: AnketasScreenState.ready));
  }

  void _onLoadAnketas(LoadAnketas event, Emitter emit) async {
    if (accessToken == null) {
      await getAccessToken();
    }

    if ((state as AnketesInitial).screenState ==
        AnketasScreenState.noMoreItem) {
      return;
    }

    List<UserProfileData> receivedAnketas =
        (state as AnketesInitial).anketas.map((e) => e).toList();

    try {
      PaginatedUserList response;
      if ((state as AnketesInitial).isSearchName == false) {
        response = await NetworkService().searchUsers(
            accessToken: accessToken ?? "",
            filter: (state as AnketesInitial).filterItem ?? UserFilter(),
            isExpandedFilter: (state as AnketesInitial).needApplyFilter,
            page: (state as AnketesInitial).loadingPage,
            exceptIds: receivedAnketas.map((e) => e.id ?? 0).toList());
      } else {
        response = await NetworkService().searchUsersByName(
            accessToken: accessToken ?? "",
            name: (state as AnketesInitial).searchName ?? "",
            page: (state as AnketesInitial).loadingPage);
      }

      receivedAnketas.addAll(response.users as Iterable<UserProfileData>);

      List<int> ids = [];
      for (var element in receivedAnketas) {
        ids.add(element.id ?? -1);
      }
      debugPrint(ids.toString());

      if (response.users.isEmpty || response.users.length < 20) {
        print(response);
        emit((state as AnketesInitial).copyThis(
            anketas: receivedAnketas,
            loadingPage: (state as AnketesInitial).loadingPage,
            screenState: AnketasScreenState.noMoreItem));
        return;
      }
    } catch (err) {
      emit((state as AnketesInitial)
          .copyThis(anketas: [], screenState: AnketasScreenState.error));
    }
    emit((state as AnketesInitial).copyThis(
        anketas: receivedAnketas,
        loadingPage: (state as AnketesInitial).loadingPage + 1,
        screenState: AnketasScreenState.ready));
  }

  void _onResetAnketas(ResetAnketas event, Emitter emit) async {
    emit(AnketesInitial());
  }

  void _onSwitchShowMode(SwitchShowMode event, Emitter emit) async {
    MyTracker.trackEvent("Switch anketes show type", {});
    emit((state as AnketesInitial)
        .copyThis(isVertical: !(state as AnketesInitial).isVertical));
  }

  void _onLoadFilter(LoadFilter event, Emitter emit) async {
    emit((state as AnketesInitial).copyThis(
        anketas: [],
        screenState: AnketasScreenState.preload,
        filterItem: event.filter,
        needApplyFilter: true,
        loadingPage: 1));
  }

  void _onSwitchSearchMode(SwitchSearchMode event, Emitter emit) async {
    if ((state as AnketesInitial).isSearchName == true) {
      emit((state as AnketesInitial).copyThis(
          isSearchName: !(state as AnketesInitial).isSearchName,
          searchName: "",
          screenState: AnketasScreenState.preload,

          ///закомментить для эффекта бесконечной ленты при выходе из поиска
          anketas: [],
          loadingPage: 1));
    } else {
      emit((state as AnketesInitial).copyThis(
          isSearchName: !(state as AnketesInitial).isSearchName,
          anketas: [],
          isVertical: true));
    }
  }

  void _onSetupSearchName(SetupSearchName event, Emitter emit) async {
    emit((state as AnketesInitial).copyThis(
        searchName: event.searchValue,
        anketas: [],
        screenState: AnketasScreenState.preload,
        filterItem: UserFilter(),
        loadingPage: 1));
  }

  void _onClearSearchName(ClearSearchName event, Emitter emit) async {
    emit((state as AnketesInitial).copyThis(searchName: ""));
  }
}
