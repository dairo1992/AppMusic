import 'package:e_music/models/models.dart';
import 'package:e_music/screens/screens.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
  GoRoute(
      path: '/playing',
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return PlayingScreenScreen(idSong: args["idSong"]);
      }),
  GoRoute(
      path: '/playList',
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return PlayListScreen(
          playList: args["playList"],
        );
      })
]);
