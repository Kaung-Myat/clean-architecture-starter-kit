import 'package:equatable/equatable.dart';

/// Domain-level pagination envelope.
///
/// Lives in `core/domain` (not `core/network`) so domain repositories/usecases
/// can depend on it without importing JSON/network types.
/// JSON parsing belongs in the data layer — see [PaginationMetaMapper].
class PaginationMeta extends Equatable {
  const PaginationMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalRows,
  });

  final int currentPage;
  final int totalPages;
  final int totalRows;

  bool get hasNextPage => currentPage < totalPages;

  static const PaginationMeta empty = PaginationMeta(
    currentPage: 1,
    totalPages: 1,
    totalRows: 0,
  );

  @override
  List<Object?> get props => [currentPage, totalPages, totalRows];
}
