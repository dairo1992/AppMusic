// ignore_for_file: use_build_context_synchronously

import 'package:e_music/models/models.dart';
import 'package:e_music/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PlayListCard extends ConsumerWidget {
  final PlayListOnlineModel playList;

  const PlayListCard({super.key, required this.playList});

  @override
  Widget build(BuildContext context, ref) {
    return GestureDetector(
      onTap: () => context.push("/playList", extra: {"playListOnline": playList}),
      onLongPressEnd: (position) {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        showMenu(
          context: context,
          position: RelativeRect.fromRect(
              position.globalPosition & const Size(40, 40),
              Offset.zero & overlay.size),
          items: <PopupMenuEntry>[
            const PopupMenuItem(
              value: 1,
              child: Text('Editar'),
            ),
            const PopupMenuItem(
              value: 2,
              child: Text('Eliminar'),
            )
          ],
        ).then((value) {
          switch (value) {
            case 1:
              final textEditInput = TextEditingController();
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(playList.title!),
                    backgroundColor: Colors.white,
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          TextFormField(
                              controller: textEditInput,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.black),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.deepPurple.shade200
                                        .withOpacity(0.8)),
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
                        child: const Text('Editar'),
                        onPressed: () async {
                          final type = await ref
                              .read(playListOnloneProvider.notifier)
                              .editPlayList(
                                  playList.title!, textEditInput.text);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              type
                                  ? "PlayList Actualizada"
                                  : "ocurrio un error",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: type ? Colors.green : Colors.red,
                          ));
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
              break;
            case 2:
              ref
                  .read(playListOnloneProvider.notifier)
                  .deletePlaylist(playList.title!);
              break;
          }
        });
      },
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
              child: Image.asset("assets/images/playlist-music.jpg"),
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
                  child: Text(playList.title!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                SizedBox(
                  width: 200,
                  height: 30,
                  child: Text(
                    "${playList.songs!.length} Canciones",
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
          _StarPlayList(playList: playList)
        ]),
      ),
    );
  }
}

class _StarPlayList extends StatelessWidget {
  final PlayListOnlineModel playList;

  const _StarPlayList({super.key, required this.playList});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => context.push("/playing",
            extra: {'onlineSongs': playList.songs, 'indexSong': 0}),
        icon: const Icon(
          Icons.play_arrow_rounded,
          color: Colors.white,
        ));
  }
}
