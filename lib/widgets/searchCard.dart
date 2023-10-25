import 'package:e_music/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SeachCard extends ConsumerWidget {
  final dynamic song;
  final String origen;

  const SeachCard({super.key, required this.song, required this.origen});

  @override
  Widget build(BuildContext context, ref) {
    final artworkAsync = ref.watch(getArtworkProvider(song["_id"]));
    return GestureDetector(
      onTap: () {
        // final songs = 
        // context.push("/playing", extra: {'localSongs': songs, 'indexSong': i});
      },
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.pink.shade100.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          origen == "O"
              ? SizedBox(
                  width: 60,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      song.artwork!.the480X480!,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset("assets/images/no-image.jpg");
                      },
                    ),
                  ),
                )
              : artworkAsync.when(
                  data: (data) {
                    if (data != null) {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(
                                  data,
                                  scale: 1.0,
                                ))),
                      );
                    }
                    return Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/images/no-image.jpg"))),
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
                  child: Text(song["title"],
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
                    "Artista: ${song["artist"]}",
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
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
              ))
        ]),
      ),
    );
  }
}
