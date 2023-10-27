import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:e_music/providers/providers.dart';
import 'package:e_music/widgets/widgets.dart';

class AllSongsScreen extends ConsumerWidget {
  const AllSongsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final onQueryAudio = ref.watch(getAudiosProvider(false));
    final sw = ref.watch(switchProvider);
    return onQueryAudio.when(
      data: (songs) => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.pinkAccent.shade400.withOpacity(0.8),
              Colors.deepPurple.shade200.withOpacity(0.8),
            ])),
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Tu Música",
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.pop(),
            ),
            actions: IconButton(
                onPressed: () {
                  ref.read(switchProvider.notifier).toogle();
                  // ref.refresh(switchProvider);
                },
                icon: Icon(sw
                    ? Icons.drag_indicator_outlined
                    : Icons.list_alt_outlined)),
          ),
          body: !sw
              ? _Opc1(songs: songs, ref: ref)
              : _Opc2(songs: songs, ref: ref),
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Text("$error"),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Opc2 extends StatelessWidget {
  final List<SongModel> songs;
  final WidgetRef ref;

  const _Opc2({super.key, required this.songs, required this.ref});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
          itemBuilder: (context, i) {
            final artworkAsync = ref.watch(getArtworkProvider(songs[i].id));
            return GestureDetector(
              onTap: () => context.push("/playing",
                  extra: {'localSongs': songs, 'indexSong': i}),
              child: SizedBox(
                width: size.width,
                height: 60,
                child: Row(
                  children: [
                    artworkAsync.when(
                        data: (data) {
                          return Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: data != null
                                    ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: MemoryImage(
                                          data,
                                          scale: 1.0,
                                        ))
                                    : const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/images/no-image.jpg"))),
                          );
                        },
                        error: (error, stackTrace) => Center(
                              child: Text("$error"),
                            ),
                        loading: () => const Center(
                              child: CircularProgressIndicator(),
                            )),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        SizedBox(
                            width: size.width * 0.8,
                            height: 25,
                            child: Text(
                              songs[i].title,
                              overflow: TextOverflow.ellipsis,
                            )),
                        SizedBox(
                            width: size.width * 0.8,
                            height: 25,
                            child: Text(
                              "${songs[i].artist}",
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: songs.length),
    );
  }
}

class _Opc1 extends StatelessWidget {
  final List<SongModel> songs;
  final WidgetRef ref;

  const _Opc1({super.key, required this.songs, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: CustomScrollView(
              slivers: [
                SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: songs.length,
                  itemBuilder: (context, i) {
                    final artworkAsync =
                        ref.watch(getArtworkProvider(songs[i].id));
                    return artworkAsync.when(
                        data: (data) {
                          return GestureDetector(
                              onTap: () => context.push("/playing",
                                  extra: {'localSongs': songs, 'indexSong': i}),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: data != null
                                            ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: MemoryImage(
                                                  data,
                                                  scale: 1.0,
                                                ))
                                            : const DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                    "assets/images/no-image.jpg"))),
                                  ),
                                  SizedBox(
                                    height: 15,
                                    child: Text(
                                      songs[i].title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                    child: Text(
                                      songs[i].artist ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ));
                        },
                        error: (error, stackTrace) => Center(
                              child: Text("$error"),
                            ),
                        loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ));
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
