class PaginationInput {
  final int? skip;
  final int? take;

  PaginationInput({required this.skip, required this.take});

  Map<String, dynamic> toJson() {
    return {
      'skip': skip,
      'take': take,
    };
  }
}
