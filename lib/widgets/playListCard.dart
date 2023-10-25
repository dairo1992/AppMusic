import 'package:e_music/models/models.dart';
import 'package:e_music/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PlayListCard extends ConsumerWidget {
  final PlayListResponse playList;

  const PlayListCard({super.key, required this.playList});

  @override
  Widget build(BuildContext context, ref) {
    return GestureDetector(
      onTap: () => context.push("/playList", extra: {"playList": playList}),
      child: Container(
        height: 70,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.pink.shade100.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          SizedBox(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                playList.artwork!.the480X480!,
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
                  child: Text(playList.playlistName!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                SizedBox(
                  width: 200,
                  height: 30,
                  child: Text(
                    "${playList.totalPlayCount} Reproducciones",
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
          _StarPlayList(idPlayList: playList.id!)
        ]),
      ),
    );
  }
}

class _StarPlayList extends ConsumerWidget {
  final String idPlayList;

  const _StarPlayList({super.key, required this.idPlayList});

  @override
  Widget build(BuildContext context, ref) {
    final button = ref.watch(playListTrackProvider(idPlayList));
    return button.when(
        data: (data) => IconButton(
            onPressed: () => context
                .push("/playing", extra: {'onlineSongs': data, 'indexSong': 0}),
            icon: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
            )),
        error: (error, stackTrace) => Container(),
        loading: () => const CircularProgressIndicator(
              color: Colors.white,
            ));
  }
}
