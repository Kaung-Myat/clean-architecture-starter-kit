/// Pagination envelope returned alongside paginated list responses.
///
/// Datasources return records as a Dart record: `({records, meta})`.
class PaginationMeta {
  const PaginationMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalRows,
  });

  final int currentPage;
  final int totalPages;
  final int totalRows;

  bool get hasNextPage => currentPage < totalPages;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: (json['current_page'] ?? json['currentPage'] ?? 1) as int,
      totalPages: (json['total_pages'] ?? json['totalPages'] ?? 1) as int,
      totalRows: (json['total_rows'] ?? json['totalRows'] ?? 0) as int,
    );
  }

  static const PaginationMeta empty =
      PaginationMeta(currentPage: 1, totalPages: 1, totalRows: 0);
}
