class PaginationResult<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final bool hasMore;

  PaginationResult({
    required this.data,
    required this.currentPage,
    required this.lastPage,
  }) : hasMore = currentPage < lastPage;
}
