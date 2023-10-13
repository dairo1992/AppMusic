import 'package:e_music/models/models.dart';
import 'package:e_music/services/trendingService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final trendingFutureProvider = FutureProvider<List<SongResponse>>((ref) async {
  final service = TrendingService();
  return service.getTrending();
});

final playListProvider = FutureProvider<List<PlayListResponse>>((ref) async {
  final service = TrendingService();
  return service.getPlayList();
});
