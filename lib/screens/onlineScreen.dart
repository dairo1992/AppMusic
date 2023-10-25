import 'package:e_music/providers/providers.dart';
import 'package:e_music/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnlineScreen extends ConsumerWidget {
  const OnlineScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    final isPlayingAsync = ref.watch(isPlayingProvider);
    return isPlayingAsync.when(
        data: (status) {
          if (status! > 0) {
            return Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height * 0.74,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const FiltrarMusic(
                          origen: 'O',
                        ),
                        _TrendingMusic(),
                        _PlayListmusic()
                      ],
                    ),
                  ),
                ),
                const MiniReproductor()
              ],
            );
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const FiltrarMusic(
                  origen: 'O',
                ),
                _TrendingMusic(),
                _PlayListmusic()
              ],
            ),
          );
        },
        error: (error, stackTrace) => Text("$error"),
        loading: () => const CircularProgressIndicator());
  }
}

class _PlayListmusic extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final playList = ref.watch(playListProvider);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SectionHeader(
            title: "PlayLists",
            action: Text("Ver más"),
          ),
          playList.when(
              data: (data) {
                if (data.isEmpty) {
                  return const Center(
                    child: Text("Sin conexion a internet"),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: 20,
                  padding: const EdgeInsets.only(top: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return PlayListCard(
                      playList: data[index],
                    );
                  },
                );
              },
              error: (error, stackTrace) => Text("$error"),
              loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ))
        ],
      ),
    );
  }
}

class _TrendingMusic extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final trending = ref.watch(trendingFutureProvider);
    return trending.when(
        data: (songs) {
          if (songs.isEmpty) {
            return const Center();
          }
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: SectionHeader(
                      title: "Tendencia Music",
                      action: Text("Ver más"),
                    ),
                  )
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.22,
                  child: ListView.builder(
                    itemCount: songs.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SongCard(
                        song: songs[index],
                        indexSong: index,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => Text("$error"),
        loading: () => const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ));
  }
}
