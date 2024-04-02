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
  final String? equals;
  final String? contains;
  final String? not;
  final String? startsWith;
  final String? endsWith;

  StringFilter({
    this.equals,
    this.contains,
    this.not,
    this.startsWith,
    this.endsWith,
  });

  Map<String, dynamic> toJson() {
    return {
      'equals': equals ?? '',
      'contains': contains ?? '',
      'not': not ?? '',
      'startsWith': startsWith ?? '',
      'endsWith': endsWith ?? '',
    };
  }
}
