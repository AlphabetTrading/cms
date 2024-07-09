import 'package:equatable/equatable.dart';

class MetaEntity extends Equatable {
  final int count;
  final int limit;
  final int page;

  const MetaEntity({
    required this.count,
    required this.limit,
    required this.page,
  });

  factory MetaEntity.fromJson(Map<String, dynamic> json) {
    return MetaEntity(
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
  factory MetaEntity.empty() {
    return const MetaEntity(
      count: 0,
      limit: 0,
      page: 0,
    );
  }

  @override
  List<Object?> get props => [
        count,
        limit,
        page,
      ];
}
