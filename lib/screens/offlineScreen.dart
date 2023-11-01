import 'package:e_music/providers/providers.dart';
import 'package:e_music/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:on_audio_query/on_audio_query.dart';

class OfflineScreen extends ConsumerWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    final statusAsync = ref.watch(checkPermissionProvider);
    final isPlayingAsync = ref.watch(isPlayingProvider);

    return statusAsync.when(
      data: (status) {
        if (status) {
          return isPlayingAsync.when(
              data: (isPlaying) {
                return isPlaying! > 0
                    ? Column(
                        children: [
                          SizedBox(
                            width: size.width,
                            height: size.height * 0.74,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const FiltrarMusic(
                                    origen: 'L',
                                  ),
                                  const _SongCard(),
                                  _PlayListmusic()
                                ],
                              ),
                            ),
                          ),
                          const MiniReproductor()
                        ],
                      )
                    : SizedBox(
                        width: size.width,
                        height: size.height * 0.82,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const FiltrarMusic(
                                origen: 'L',
                              ),
                              const _SongCard(),
                              _PlayListmusic()
                            ],
                          ),
                        ),
                      );
              },
              error: (error, stackTrace) => Text("$error"),
              loading: () => const CircularProgressIndicator());
        }
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.redAccent.withOpacity(0.5),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  "La apicacion no cuenta con los permisos necesarios para buscar tu musica, por favor habilita el permiso"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async =>
                    await ref.watch(onQueryAudioProvider).permissionsRequest(),
                child: const Text("Habilitar"),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Center(
        child: Text("$error"),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _SongCard extends ConsumerWidget {
  const _SongCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final onQueryAudio = ref.watch(getAudiosProvider(true));
    return onQueryAudio.when(
      data: (songs) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SectionHeader(
                    title: "Tu música",
                    action: TextButton(
                        onPressed: () =>
                            context.push("/allSongs", extra: {'origen': "L"}),
                        child: Text("Ver más",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith()))),
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
                  final artworkAsync =
                      ref.watch(getArtworkProvider(songs[i].id));
                  return GestureDetector(
                    onTap: () {
                      context.push("/playing",
                          extra: {'localSongs': songs, 'indexSong': i});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          artworkAsync.when(
                              data: (data) {
                                if (data != null) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
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
                              },
                              error: (error, stackTrace) => Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: const DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/images/no-image.jpg")),
                                  )),
                              loading: () => const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: 40,
                                  child: Text(
                                    songs[i].title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
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
                },
              ),
            ),
          ),
        ],
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

class _PlayListmusic extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    // final playList = ref.watch(onQueryAudioProvider);
    final playList = ref.watch(getPlayListLocalProvider);
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
          playList.when(
              data: (playlist) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: playlist.length,
                    padding: const EdgeInsets.only(top: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return Container(
                        height: 70,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.pink.shade100.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(15)),
                        child: GestureDetector(
                          onTap: () => context.push("/playList",
                              extra: {"playListLocal": playlist[i]}),
                          onLongPressEnd: (position) {
                            _showContextMenu(context, position.globalPosition,
                                playlist[i], ref);
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: const Icon(
                                    Icons.queue_music_sharp,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Text(playlist[i].playlist,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18)),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        height: 30,
                                        child: Text(
                                          "${playlist[i].numOfSongs} Canciones",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                _StarPlayList(
                                  idPlayList: playlist[i].id,
                                  cantSong: playlist[i].numOfSongs,
                                )
                              ]),
                        ),
                      );
                    },
                  ),
              error: (error, stackTrace) => Text("$error"),
              loading: () => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )),
        ],
      ),
    );
  }
}

class _AddPlayListButton extends ConsumerWidget {
  const _AddPlayListButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return FilledButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.pink)),
        onPressed: () {
          final playListName = TextEditingController();
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Nueva PlayList'),
              content: TextFormField(
                  controller: playListName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Nombre",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (playListName.text != "") {
                      final resp = await ref
                          .read(onQueryAudioProvider)
                          .createPlaylist(playListName.text);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: resp ? Colors.green : Colors.red,
                          content: Text(
                              resp
                                  ? "PlayList Creada"
                                  : "Ocurrio un error creando PlayList",
                              style: Theme.of(context).textTheme.bodyMedium)));
                    }
                    Navigator.pop(context, 'Crear');
                  },
                  child: const Text('Crear'),
                ),
              ],
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Crear PlayList",
                style: Theme.of(context).textTheme.bodyMedium),
            const Icon(
              Icons.playlist_add_rounded,
              size: 40,
            )
          ],
        ));
  }
}

class _StarPlayList extends ConsumerWidget {
  final int idPlayList;
  final int cantSong;

  const _StarPlayList(
      {super.key, required this.idPlayList, required this.cantSong});

  @override
  Widget build(BuildContext context, ref) {
    final button = ref.watch(getTrackPlaylistProvider(idPlayList));
    return button.when(
        data: (data) => IconButton(
            onPressed: () {
              if (cantSong > 0) {
                context.push("/playing",
                    extra: {'localSongs': data, 'indexSong': 0});
              } else {
                null;
              }
            },
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

void _showContextMenu(BuildContext context, Offset position,
    PlaylistModel playList, WidgetRef ref) {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  showMenu(
    context: context,
    position: RelativeRect.fromRect(
        position & const Size(40, 40), Offset.zero & overlay.size),
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
    if (value != null) {
      // Realiza una acción según la opción seleccionada.
      switch (value) {
        case 1:
          final textEditInput = TextEditingController();
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(playList.playlist),
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
                      // final type = await ref
                      // .read(onQueryAudioProvider)
                      // .renamePlaylist(playList.id, textEditInput.text);
                      ref.refresh(getPlayListLocalProvider);
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text(
                      //     type ? "PlayList Actualizada" : "ocurrio un error",
                      //     textAlign: TextAlign.center,
                      //     style: const TextStyle(
                      //         fontSize: 16.0, fontWeight: FontWeight.bold),
                      //   ),
                      //   duration: const Duration(seconds: 2),
                      //   backgroundColor: type ? Colors.green : Colors.red,
                      // ));
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          break;
        case 2:
          ref.read(onQueryAudioProvider).removePlaylist(playList.id);
          ref.refresh(getPlayListLocalProvider);
          break;
      }
    }
  });
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
                  .read(onQueryAudioProvider)
                  .createPlaylist(textInput.text);
              ref.refresh(getPlayListLocalProvider);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  type ? "PlayList Creada" : "ocurrio un error",
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
}
