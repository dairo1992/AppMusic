import 'package:e_music/models/models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SongCard extends StatelessWidget {
  final SongResponse song;
  final int indexSong;

  const SongCard({super.key, required this.song, required this.indexSong});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        List<SongResponse> lista = [];
        lista.add(song);
        context.push("/playing", extra: {'onlineSongs': lista, 'indexSong': indexSong});
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(song.artwork!.the480X480!),
                      fit: BoxFit.cover)),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.32,
              height: 40,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 8),
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 40,
                    child: Text(
                      song.title ?? "Untitle",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.deepPurple.shade800,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
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
}
