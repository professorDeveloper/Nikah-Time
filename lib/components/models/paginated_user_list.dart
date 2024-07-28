import 'package:json_annotation/json_annotation.dart';
import 'package:untitled/components/models/pagination.dart';
import 'package:untitled/components/models/user_profile_data.dart';


part 'paginated_user_list.g.dart';

@JsonSerializable()
class PaginatedUserList {
  @JsonKey(name: "data")
  final List<UserProfileData> users;

  final Pagination pagination;

  PaginatedUserList({required this.users, required this.pagination});

  factory PaginatedUserList.fromJson(Map<String, dynamic> json) => _$PaginatedUserListFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedUserListToJson(this);
}