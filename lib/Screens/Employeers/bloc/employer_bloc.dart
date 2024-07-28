part of '../employee_information.dart';

class EmployeerBloc extends Bloc<EmployeerEvent, EmployeerState> {
  EmployeerBloc() : super(EmployeerInitial()) {
    on<LoadDataEvent>(_onLoadData);
    on<LoadSelectedDataEvent>(_onLoadSelectedData);
  }

  void _onLoadData(LoadDataEvent event, Emitter emit) async
  {
    List<PeopleList> items = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var response = await NetworkService().GetStaffInfo_v1(
        accessToken: prefs.getString("token").toString()
      );

      if (response.statusCode != 200) {
        throw Exception();
      }

      List<dynamic> result = jsonDecode(response.body);

      for(final subItem in result)
      {
        PeopleList item = PeopleList.fromJson(subItem);
        items.add(item);
      }

    } on Exception {
      emit((state as EmployeerInitial).copyThis(
        screenState: EmployerScreenState.error,
        employerList: items
      ));
      return;
    }


    emit((state as EmployeerInitial).copyThis(
        screenState: EmployerScreenState.ready,
        employerList: items
    ));
  }

  void _onLoadSelectedData(LoadSelectedDataEvent event, Emitter emit) async
  {
    PeopleCard employer;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var response = await NetworkService().GetStaffProfileInfo(
          accessToken: prefs.getString("token").toString(),
          id: event.id
      );
      if (response.statusCode != 200) {
        throw Exception();
      }

      employer = PeopleCard.fromJson(jsonDecode(response.body));

    } on Exception {
      emit((state as EmployeerInitial).copyThis(
          screenState: EmployerScreenState.error
      ));
      return;
    }

    emit((state as EmployeerInitial).copyThis(
        screenState: EmployerScreenState.extendedReady,
        selectedPeopleItem: employer
    ));
    return;
  }

}
