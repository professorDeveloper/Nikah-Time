part of '../employee_information.dart';

abstract class EmployeerState extends Equatable {
  const EmployeerState();
}

class EmployeerInitial extends EmployeerState {

  final EmployerScreenState screenState;
  final List<PeopleList> employerList;
  final PeopleCard? selectedPeopleItem;


  EmployeerInitial({
    this.screenState = EmployerScreenState.preload,
    this.employerList = const [],
    this.selectedPeopleItem
  });


  EmployeerInitial copyThis({
    List<PeopleList> ? employerList,
    EmployerScreenState? screenState,
    PeopleCard? selectedPeopleItem
  }){
    return EmployeerInitial(
      employerList: employerList ?? this.employerList,
      screenState: screenState ?? this.screenState,
      selectedPeopleItem: selectedPeopleItem ?? this.selectedPeopleItem
    );
  }

  @override
  List<Object?> get props => [
    screenState,
    employerList,
    selectedPeopleItem
  ];
}
