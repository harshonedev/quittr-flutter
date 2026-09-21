
abstract interface class PodcastDataSource {
  Future<String> getPodcastFiles();
}

class PodcastDataSourceImpl implements PodcastDataSource {
  @override
  Future<String> getPodcastFiles() async {
    // Return a single podcast file path directly
    return 'audio/podcast_1.mp3';
  }
}
