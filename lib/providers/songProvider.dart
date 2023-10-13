import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_music/models/models.dart';
import 'package:e_music/services/songService.dart';

final songProvider =
    FutureProvider.family<SongResponse?, String>((ref, id) async {
  final service = SongService();
  return await service.getSong(id);
});

final searchProvider =
    FutureProvider.family<List<SongResponse>, String>((ref, query) async {
  final service = SongService();
  service.searchSong(query);
  return [];
});
