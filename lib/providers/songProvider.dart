import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_music/models/models.dart';
import 'package:e_music/services/songService.dart';

final songProvider =
    FutureProvider.family<List<SongResponse>?, List<String>>((ref, id) async {
  final service = SongService();

  List<SongResponse>? songs = [];
  final SongResponse? song = await service.getSong(id[0]);
  songs.add(song!);
  return songs;
});

final searchProvider =
    FutureProvider.family<List<dynamic>, String>((ref, query) async {
  final service = SongService();
  return service.searchSong(query);
});
