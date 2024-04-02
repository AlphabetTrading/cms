class Meta {
  final int count;
  final int limit;
  final int page;

  Meta({
    required this.count,
    required this.limit,
    required this.page,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      count: json['count'],
      limit: json['limit'],
      page: json['page'],
    );
  }
}