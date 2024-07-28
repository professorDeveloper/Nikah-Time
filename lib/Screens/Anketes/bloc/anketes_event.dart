part of '../anketes.dart';

abstract class AnketesEvent extends Equatable {
  const AnketesEvent();
}

class LoadAnketas extends AnketesEvent {
  const LoadAnketas();

  @override
  List<Object?> get props => [];
}

class OnRefresh extends AnketesEvent {
  const OnRefresh();

  @override
  List<Object?> get props => [];
}

class ResetAnketas extends AnketesEvent {
  const ResetAnketas();

  @override
  List<Object?> get props => [];
}

class LoadFilter extends AnketesEvent {
  final UserFilter filter;

  const LoadFilter({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class SwitchShowMode extends AnketesEvent {
  const SwitchShowMode();

  @override
  List<Object?> get props => [];
}

class SwitchSearchMode extends AnketesEvent {
  const SwitchSearchMode();

  @override
  List<Object?> get props => [];
}

class SetupSearchName extends AnketesEvent {
  final String searchValue;

  const SetupSearchName({required this.searchValue});

  @override
  List<Object?> get props => [searchValue];
}

class ClearSearchName extends AnketesEvent {
  const ClearSearchName();

  @override
  List<Object?> get props => [];
}
