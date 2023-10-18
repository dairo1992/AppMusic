import 'dart:typed_data';

import 'package:e_music/models/models.dart';
import 'package:e_music/providers/providers.dart';
import 'package:e_music/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:on_audio_query/on_audio_query.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
          width: size.width,
          height: size.height * 0.70,
          child: const SingleChildScrollView(
            child: Column(
              children: [
                FiltrarMusic(),
                _SongCard()
                // _PlayListmusic()
              ],
            ),
          ),
        ),
        // reproductor.playing ? MiniReproductor(song: song!) : Container()
      ],
    );
  }
}

class _SongCard extends ConsumerWidget {
  const _SongCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final onQueryAudio = ref.watch(onQueryAudioProvider);
    final size = MediaQuery.of(context).size;
    return FutureBuilder<bool>(
      future: onQueryAudio.checkAndRequest(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!) {
            return FutureBuilder<List<SongModel>>(
                future: onQueryAudio.querySongs(
                  sortType: null,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true,
                ),
                builder: (context, item) {
                  if (item.hasError) {
                    return Text(item.error.toString());
                  }
                  if (item.data == null) {
                    return const CircularProgressIndicator();
                  }
                  if (item.data!.isEmpty) {
                    return const Text("Nothing found!");
                  }
                  final songs = item.data!;
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: SectionHeader(title: "Tendencia Music"),
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
                            itemBuilder: (context, i) {
                              return FutureBuilder<Uint8List?>(
                                future: OnAudioQuery().queryArtwork(
                                  songs[i].id,
                                  ArtworkType.AUDIO,
                                  format: ArtworkFormat.JPEG,
                                  size: 200,
                                  quality: 50,
                                ),
                                builder: (context, item) {
                                  if (item.data != null &&
                                      item.data!.isNotEmpty) {
                                    return GestureDetector(
                                      onTap: () {
                                        List<String> lista = [];
                                        lista.add(songs[i].data.toString());
                                        context.push("/playing",
                                            extra: {'idSong': lista});
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: MemoryImage(
                                                        item.data!,
                                                        scale: 1.0,
                                                      ))),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                              height: 40,
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.white
                                                      .withOpacity(0.8)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                    height: 40,
                                                    child: Text(
                                                      songs[i].title,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Colors
                                                                  .deepPurple
                                                                  .shade800,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  const Icon(Icons.play_circle)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "assets/images/no-image.jpg")),
                                      ));
                                  //  Image.asset(
                                  //     "assets/images/no-image.jpg");
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                });
          }
        }
        return Container(
          margin: const EdgeInsets.only(top: 20),
          width: size.width * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.redAccent.withOpacity(0.5),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Habilitar permiso"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  onQueryAudio.checkAndRequest(retryRequest: true);
                },
                child: const Text("Permitir"),
              ),
            ],
          ),
        );
      },
    );
  }
}
