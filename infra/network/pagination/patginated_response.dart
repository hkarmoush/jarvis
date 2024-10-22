import '../network_manager.dart';

class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int totalPages;

  PaginatedResponse(
      {required this.data,
      required this.currentPage,
      required this.totalPages});
}

abstract class PaginatedNetworkManager<T>
    extends NetworkManager<PaginatedResponse<T>> {
  Future<PaginatedResponse<T>> fetchPaginatedData(
    String url,
    int page, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  });
}
