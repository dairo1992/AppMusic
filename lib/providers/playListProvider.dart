import 'package:e_music/models/models.dart';
import 'package:e_music/services/playListService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playListTrackProvider =
    FutureProvider.family<List<SongResponse>, String>((ref, id) async {
  final service = PlayListService();
  final playlist = await service.getPlayListTracks(id);
  return playlist;
});

// final listTrackIdProvider = Provider.family<List<String>, String>((ref, id) {
//   List<String> lista = [];
//   void getList() async {
//     final service = PlayListService();
//     lista = await service.LisTrackIds(id);
//   }

//   List<String> test() {
//     getList();
//     return lista;
//   }

//   return test();
// });
