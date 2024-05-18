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

class StringFilter {
  final String? contains;
  final String? startsWith;
  final String? endsWith;

  StringFilter({
    this.contains,
    this.startsWith,
    this.endsWith,
  });

  Map<String, dynamic> toJson() {
    return {
      'contains': contains ?? '',
      'startsWith': startsWith ?? '',
      'endsWith': endsWith ?? '',
    };
  }
}
