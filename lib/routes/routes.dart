import 'package:e_music/models/models.dart';
import 'package:e_music/screens/screens.dart';
import 'package:go_router/go_router.dart';
import 'package:on_audio_query/on_audio_query.dart';

final router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
  GoRoute(
      path: '/playing',
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        if (args["localSongs"] != null) {
          final List<SongModel> songs = args["localSongs"];
          final int index = args["indexSong"];
          return PlayingScreenScreen(localSongs: songs, indexSong: index);
        } else {
          final List<SongResponse> songs = args["onlineSongs"];
          final int index = args["indexSong"];
          return PlayingScreenScreen(onlineSongs: songs, indexSong: index);
        }
      }),
  GoRoute(
      path: '/playList',
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return PlayListScreen(
          playList: args["playList"],
        );
      }),
  GoRoute(
    path: '/allSongs',
    builder: (context, state) => AllSongsScreen(),
  )
]);
