import 'package:jarvis/infra/network/network_manager.dart';

abstract class RemoteImageDataSource {
  Future<dynamic> fetchImageFromNetwork(String url);
}

class RemoteImageDataSourceImpl implements RemoteImageDataSource {
  final NetworkManager _networkManager;

  RemoteImageDataSourceImpl(this._networkManager);

  @override
  Future<dynamic> fetchImageFromNetwork(String url) async {
    try {
      final response = await _networkManager.get(url);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch image: $e');
    }
  }
}
