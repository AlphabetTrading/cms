import 'package:cms_mobile/core/entities/meta.dart';

class MetaModel extends MetaEntity {
  const MetaModel({
    required super.count,
    required super.limit,
    required super.page,
  });

  // fromJson
  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      count: json['count'],
      limit: json['limit'],
      page: json['page'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'limit': limit,
      'page': page,
    };
  }

  // empty
  factory MetaModel.empty() {
    return const MetaModel(
      count: 0,
      limit: 0,
      page: 0,
    );
  }
}
