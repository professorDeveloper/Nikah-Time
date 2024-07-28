import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

@JsonSerializable()
class Pagination {
  final int count;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final int? from;
  final int? to;
  final String? nextPageUrl;
  final String? prevPageUrl;

  Pagination({
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    this.from,
    this.to,
    this.nextPageUrl,
    this.prevPageUrl
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}