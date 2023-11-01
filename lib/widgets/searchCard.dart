import 'package:e_music/models/models.dart';
import 'package:e_music/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SeachCard extends ConsumerWidget {
  final List<dynamic> songList;
  final int index;
  final String origen;

  const SeachCard(
      {super.key,
      required this.songList,
      required this.origen,
      required this.index});

  @override
  Widget build(BuildContext context, ref) {
    return GestureDetector(
      onTap: () {
        if (origen == "L") {
          final List<SongModel> songs = [];
          for (var i = 0; i < songList.length; i++) {
            final SongModel x = SongModel(songList[i]);
            songs.add(x);
          }
          context.push("/playing",
              extra: {'localSongs': songs, 'indexSong': index});
        } else {
          final List<SongResponse> songs = [];
          for (var i = 0; i < songList.length; i++) {
            final SongResponse x = SongResponse.fromJson(songList[i]);
            songs.add(x);
          }
          context.push("/playing",
              extra: {'onlineSongs': songs, 'indexSong': index});
        }
        context.pop();
      },
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.pink.shade100.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          if (origen == "O")
            SizedBox(
              width: 60,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  songList[index]['artwork']['480x480'],
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset("assets/images/no-image.jpg");
                  },
                ),
              ),
            )
          else
            ref.watch(getArtworkProvider(songList[index]["_id"])).when(
                  data: (data) {
                    return Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                  error: (error, stackTrace) => Text("$error"),
                  loading: () => const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 30,
                  child: Text(songList[index]["title"],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                SizedBox(
                  width: 200,
                  height: 20,
                  child: Text(
                    "Artista: ${songList[index]["artist"] ?? 'Indefinido'}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                )
              ],
            ),
          ),
          const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
          )
        ]),
      ),
    );
  }
}
