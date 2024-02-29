import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import 'package:e_music/models/models.dart';
import 'package:e_music/providers/providers.dart';
import 'package:e_music/widgets/barraAvance.dart';
import 'package:e_music/widgets/widgets.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class PlayingScreenScreen extends ConsumerWidget {
  List<SongResponse>? onlineSongs;
  List<SongModel>? localSongs;
  int? indexSong;
  bool shuffle;
  PlayingScreenScreen(
      {super.key,
      this.onlineSongs,
      this.localSongs,
      this.indexSong,
      this.shuffle = false});

  @override
  Widget build(BuildContext context, ref) {
    final reproductor = ref.watch(reproductorProvider);
    if (indexSong != -1) {
      _prepareReprodictor(
          reproductor, onlineSongs, localSongs, indexSong, shuffle);
    }
    return Container(
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
          title: "",
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
          actions: StreamBuilder<SequenceState?>(
              stream: reproductor.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                final origen =
                    metadata.artHeaders!["image"]!.contains("https") == true
                        ? "I"
                        : "L";
                return _MenuAddSongaPlayList(
                    idSong: metadata.id, origen: origen);
              }),
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  children: [
                    _HeaderSong(reproductor: reproductor),
                    _PogresiveBar(reproductor: reproductor),
                    const PlayerButtons(
                      sizeIcon: 45,
                      showShuffle: true,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class _MenuAddSongaPlayList extends ConsumerWidget {
  final String idSong;
  final String origen;

  const _MenuAddSongaPlayList({required this.idSong, required this.origen});

  @override
  Widget build(BuildContext context, ref) {
    if (origen == "L") {
      final playList = ref.watch(getPlayListLocalProvider);
      return playList.when(
          data: (playList) => PopupMenuButton<PlaylistModel>(
              icon: const Icon(Icons.playlist_add),
              onSelected: (PlaylistModel item) async {
                final resp = await ref
                    .read(onQueryAudioProvider)
                    .addToPlaylist(item.id, int.parse(idSong));
                if (resp) {
                  ref.refresh(getPlayListLocalProvider);
                  ref.refresh(getTrackPlaylistProvider(item.id));
                }
                // ignore: use_build_context_synchronously
                showInSnackBar(
                    context: context,
                    type: resp,
                    msg: resp ? "Canción Agregada" : "Ocurrio un error");
              },
              itemBuilder: (BuildContext context) => playList
                  .map((e) => PopupMenuItem<PlaylistModel>(
                        value: e,
                        child: Text(e.playlist),
                      ))
                  .toList()),
          error: (error, stackTrace) => Text("$error"),
          loading: () => const CircularProgressIndicator());
    } else {
      final playList = ref.watch(playListOnloneProvider);
      return PopupMenuButton<PlayListOnlineModel>(
          icon: const Icon(Icons.playlist_add),
          onSelected: (PlayListOnlineModel item) async {
            final resp = await ref
                .read(playListOnloneProvider.notifier)
                .addSong(item.title!, idSong);
            showInSnackBar(
                context: context,
                type: resp,
                msg: resp ? "Canción Agregada" : "Ocurrio un error");
          },
          itemBuilder: (BuildContext context) => playList
              .map((e) => PopupMenuItem<PlayListOnlineModel>(
                    value: e,
                    child: Text(e.title!),
                  ))
              .toList());
    }
  }
}

class _HeaderSong extends StatelessWidget {
  const _HeaderSong({
    super.key,
    required this.reproductor,
  });

  final AudioPlayer reproductor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: StreamBuilder<SequenceState?>(
          stream: reproductor.sequenceStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            if (state?.sequence.isEmpty ?? true) {
              return const SizedBox();
            }
            final metadata = state!.currentSource!.tag as MediaItem;
            final image =
                metadata.artHeaders!["image"]!.contains("https") == true
                    ? "I"
                    : "L";
            return Column(
              children: [
                Hero(
                  tag: metadata.id,
                  child: SizedBox(
                    child: image == "L"
                        ? FutureBuilder<Uint8List?>(
                            future: OnAudioQuery().queryArtwork(
                                int.parse(metadata.id), ArtworkType.AUDIO,
                                format: ArtworkFormat.JPEG,
                                size: 200,
                                quality: 50),
                            builder: (context, item) {
                              if (item.data != null && item.data!.isNotEmpty) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.memory(
                                    item.data!,
                                    gaplessPlayback: false,
                                    repeat: ImageRepeat.noRepeat,
                                    scale: 1.0,
                                    width: size.width,
                                    height: size.height * 0.5,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                    errorBuilder:
                                        (context, exception, stackTrace) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        clipBehavior: Clip.antiAlias,
                                        child: Image.asset(
                                          "assets/images/no-image.jpg",
                                          gaplessPlayback: false,
                                          repeat: ImageRepeat.noRepeat,
                                          scale: 1.0,
                                          width: size.width,
                                          height: size.height * 0.5,
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.low,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  "assets/images/no-image.jpg",
                                  gaplessPlayback: false,
                                  repeat: ImageRepeat.noRepeat,
                                  scale: 1.0,
                                  width: size.width,
                                  height: size.height * 0.5,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                ),
                              );
                            })
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              metadata.artHeaders!["image"]!,
                              fit: BoxFit.fill,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Image(
                                    image: AssetImage(
                                        "assets/images/loading.gif"));
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/images/no-image.jpg",
                                  gaplessPlayback: false,
                                  repeat: ImageRepeat.noRepeat,
                                  scale: 1.0,
                                  width: size.width,
                                  height: size.height * 0.5,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                );
                              },
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: size.width,
                  height: 90,
                  child: Text(
                    metadata.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                )
              ],
            );
          }),
    );
  }
}

class _PogresiveBar extends StatelessWidget {
  const _PogresiveBar({
    super.key,
    required this.reproductor,
  });

  final AudioPlayer reproductor;

  Stream<PositionData> _positionDataStream() {
    return rxdart.Rx.combineLatest3<Duration, Duration, Duration?,
            PositionData>(
        reproductor.positionStream,
        reproductor.bufferedPositionStream,
        reproductor.durationStream,
        (position, bufferedPosition, duration) => PositionData(
            position, bufferedPosition, duration ?? Duration.zero));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: _positionDataStream(),
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        return SeekBar(
          duration: positionData?.duration ?? Duration.zero,
          position: positionData?.position ?? Duration.zero,
          bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
          onChangeEnd: reproductor.seek,
        );
      },
    );
  }
}

_prepareReprodictor(AudioPlayer reproductor, List<SongResponse>? onlineSongs,
    List<SongModel>? localSongs, int? indexSong, bool shuffle) {
  if (localSongs != null) {
    final playList = ConcatenatingAudioSource(
        useLazyPreparation: true,
        shuffleOrder: DefaultShuffleOrder(),
        children: localSongs
            .map((e) => AudioSource.uri(Uri.parse(e.data),
                tag: MediaItem(
                    id: "${e.id}",
                    title: e.title,
                    album: e.album,
                    artHeaders: {"image": e.data},
                    extras: {"heroTag": "image_${e.id}"})))
            .toList());
    reproductor.setAudioSource(playList,
        initialIndex: indexSong ?? 0, initialPosition: Duration.zero);
  } else {
    final playList = ConcatenatingAudioSource(
        useLazyPreparation: true,
        shuffleOrder: DefaultShuffleOrder(),
        children: onlineSongs!
            .map((e) => AudioSource.uri(
                Uri.parse(
                    "https://discoveryprovider3.audius.co/v1/tracks/${e.id}/stream?app_name=E_Music"),
                tag: MediaItem(
                    id: e.id!,
                    title: e.title!,
                    album: "Desconocido",
                    artHeaders: {"image": e.artwork!.the480X480!})))
            .toList());
    reproductor.setAudioSource(playList,
        initialIndex: indexSong ?? 0, initialPosition: Duration.zero);
    reproductor.setShuffleModeEnabled(shuffle);
  }
}

void showInSnackBar(
    {required bool type, required String msg, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    ),
    duration: const Duration(seconds: 2),
    backgroundColor: type ? Colors.green : Colors.red,
  ));
}
