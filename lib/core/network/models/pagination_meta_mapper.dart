import '../../domain/pagination_meta.dart';

/// Maps API pagination JSON → domain [PaginationMeta].
class PaginationMetaMapper {
  const PaginationMetaMapper._();

  static PaginationMeta fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: (json['current_page'] ?? json['currentPage'] ?? 1) as int,
      totalPages: (json['total_pages'] ?? json['totalPages'] ?? 1) as int,
      totalRows: (json['total_rows'] ?? json['totalRows'] ?? 0) as int,
    );
  }
}
