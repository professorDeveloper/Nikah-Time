part of '../news.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
}

class LoadNews extends NewsEvent
{
  const LoadNews();

  @override
  List<Object?> get props => [];

}

class SetNewSearchValue extends NewsEvent
{
  final String? searchValue;

  const SetNewSearchValue({this.searchValue});

  @override
  List<Object?> get props => [];

}

class RefreshNews extends NewsEvent
{
  const RefreshNews();

  @override
  List<Object?> get props => [];

}

class ToggleLike extends NewsEvent
{
  final int id;

  const ToggleLike({required this.id});

  @override
  List<Object?> get props => [];

}

class MakeSeen extends NewsEvent
{
  final int id;

  const MakeSeen({required this.id});

  @override
  List<Object?> get props => [];

}