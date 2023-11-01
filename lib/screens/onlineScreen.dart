import 'package:e_music/providers/providers.dart';
import 'package:e_music/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    ref.read(playListOnloneProvider.notifier).getPlayListOnline();
    final playList = ref.watch(playListOnloneProvider);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SectionHeader(
            title: "PlayLists",
            action: MaterialButton(
                color: Colors.pink.shade100,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () => _showMyDialog(context, ref),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          ),
          playList.isEmpty
              ? const Center(
                  child: Text("Crea tu primer PlayList"),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: playList.length,
                  padding: const EdgeInsets.only(top: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    // return Text(playList[index].title!);
                    return PlayListCard(
                      playList: playList[index],
                    );
                  },
                )
        ],
      ),
    );
  }
}

class _TrendingMusic extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final trending = ref.watch(trendingFutureProvider(true));
    return trending.when(
        data: (songs) {
          if (songs.isEmpty) {
            return const Center();
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: SectionHeader(
                        title: "Tendencia Music",
                        action: TextButton(
                            onPressed: () => context
                                .push("/allSongs", extra: {'origen': "O"}),
                            child: Text("Ver más",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith()))),
                  ),
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

Future<void> _showMyDialog(BuildContext context, WidgetRef ref) async {
  final textInput = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Nueva Playlist'),
            Icon(
              Icons.playlist_play_rounded,
              size: 30,
            )
          ],
        ),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              TextFormField(
                  controller: textInput,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.black),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Colors.deepPurple.shade200.withOpacity(0.8)),
                    borderRadius: BorderRadius.circular(20),
                  ))),
            ],
          ),
        ),
        actions: [
          // ignore: prefer_const_constructors
          TextButton(
            onPressed: () => context.pop(),
            child: const Text("Cencelar"),
          ),
          TextButton(
            child: const Text('Agregar'),
            onPressed: () async {
              final type = await ref
                  .read(playListOnloneProvider.notifier)
                  .addPlayListOnline(textInput.text);

              // ref.refresh(getPlayListLocalProvider);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  type ? "PlayList Creada" : "PlayList existe",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                duration: const Duration(seconds: 2),
                backgroundColor: type ? Colors.green : Colors.red,
              ));
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
