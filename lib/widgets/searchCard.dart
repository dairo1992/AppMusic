import 'package:e_music/models/models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SeachCard extends StatelessWidget {
  final SongResponse song;

  const SeachCard({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push("/playing", extra: {'idSong': song.id}),
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.pink.shade100.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          SizedBox(
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
                  child: Text(song.title!,
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
                    "Genero: ${song.genre}",
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
