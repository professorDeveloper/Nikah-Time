part of '../employee_information.dart';

abstract class EmployeerEvent extends Equatable {
  const EmployeerEvent();
}


class LoadDataEvent extends EmployeerEvent {
  const LoadDataEvent();

  @override
  List<Object?> get props => [];
}

class LoadSelectedDataEvent extends EmployeerEvent {
  final int id;

  const LoadSelectedDataEvent({required this.id});

  @override
  List<Object?> get props => [
    id
  ];
}