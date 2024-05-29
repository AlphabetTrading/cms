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
      if (contains != null) 'contains': contains ?? '',
      if (startsWith != null) 'startsWith': startsWith ?? '',
      if (endsWith != null) 'endsWith': endsWith ?? '',
    };
  }
}
