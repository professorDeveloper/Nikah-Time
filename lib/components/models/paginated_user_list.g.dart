// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_user_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedUserList _$PaginatedUserListFromJson(Map<String, dynamic> json) =>
    PaginatedUserList(
      users: (json['data'] as List<dynamic>)
          .map((e) => UserProfileData.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedUserListToJson(PaginatedUserList instance) =>
    <String, dynamic>{
      'data': instance.users,
      'pagination': instance.pagination,
    };
