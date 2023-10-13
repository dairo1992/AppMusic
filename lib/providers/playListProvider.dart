import 'package:e_music/models/models.dart';
import 'package:e_music/services/playListService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playListTrackProvider =
    FutureProvider.family<List<SongResponse>, String>((ref, id) async {
  final service = PlayListService();
  return await service.getPlayListTracks(id);
});

// class PlayListtracksNotifier extends StateNotifier<List<SongResponse>> {
//   PlayListtracksNotifier() : super([]);

//   void addPlayListTracks(String id) async {
//     final service = PlayListService();
//     final list = await service.getPlayListTracks(id);
//     state = list;
//   }
// }

// final playProvider = StateNotifierProvider.family<PlayListtracksNotifier,
//     List<SongResponse>, String>((ref, id) {
//   PlayListtracksNotifier().addPlayListTracks(id);
//   return PlayListtracksNotifier();
// });

// final playListTrackProvider =
//     Provider.family<List<SongResponse>, String>((ref, id) {
//   final playListTracks = ref.watch(playProvider(id));
//   return playListTracks;
// });
