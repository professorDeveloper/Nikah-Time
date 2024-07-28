import 'package:json_annotation/json_annotation.dart';

part 'nikah_error.g.dart';

@JsonSerializable()
class NikahError extends Error {
  int code;
  String title;
  String detail;

  NikahError({
    required this.code,
    required this.title,
    required this.detail
  });

  bool isUnknown() {
    return title == "ERR_UNKNOWN";
  }

  factory NikahError.tryFromJson({
    required Map<String, dynamic> json,
    int? defaultCode,
    String? defaultDetail
  }) {
    try {
      return NikahError.fromJson(json);
    } on Error catch (e) {
      return NikahError.getUnknown(
          defaultDetail ?? (e.toString() + " | " + json.toString()),
          code: defaultCode
      );
    }
  }

  factory NikahError.getUnknown(String? detail, {int? code}) {
    return NikahError(
        code: -1,
        title: "ERR_UNKNOWN",
        detail: detail ?? "ERR_UNKNOWN"
    );
  }

  factory NikahError.fromJson(Map<String, dynamic> json) => _$NikahErrorFromJson(json);

  Map<String, dynamic> toJson() => _$NikahErrorToJson(this);
}