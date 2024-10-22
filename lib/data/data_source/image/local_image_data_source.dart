abstract class LocalImageDataSource {
  Future<dynamic> getCachedImage(String url);
  Future<void> cacheImage(String url, dynamic imageData);
}

class LocalImageDataSourceImpl implements LocalImageDataSource {
  final Map<String, dynamic> _memoryCache = {};

  @override
  Future<dynamic> getCachedImage(String url) async {
    if (_memoryCache.containsKey(url)) {
      return _memoryCache[url];
    }
    return null;
  }

  @override
  Future<void> cacheImage(String url, dynamic imageData) async {
    _memoryCache[url] = imageData;
  }
}
