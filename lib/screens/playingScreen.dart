import 'package:e_music/models/models.dart';
import 'package:e_music/providers/providers.dart';
import 'package:e_music/widgets/barraAvance.dart';
import 'package:e_music/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class PlayingScreenScreen extends ConsumerWidget {
  final String idSong;

  const PlayingScreenScreen({super.key, required this.idSong});

  @override
  Widget build(BuildContext context, ref) {
    final song = ref.watch(songProvider(idSong));
    final reproductor = ref.watch(reproductorProvider);
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
        appBar: const CustomAppBar(
          title: '',
        ),
        extendBodyBehindAppBar: true,
        body: song.when(
            data: (data) {
              reproductor.reproductor.setUrl(
                  "https://discoveryprovider3.audius.co/v1/tracks/${data!.id}/stream?app_name=E_Music");
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    data.artwork!.the1000X1000!,
                    fit: BoxFit.fill,
                  ),
                  _BackgroundFilter(),
                  _MusicPlayer(reproductorProvider: reproductor, song: data),
                ],
              );
            },
            error: (error, stackTrace) => Center(
                  child: Text("$error"),
                ),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )),
      ),
    );
  }
}

class _MusicPlayer extends StatelessWidget {
  final SongResponse song;

  final ReproductorState reproductorProvider;

  const _MusicPlayer(
      {super.key, required this.song, required this.reproductorProvider});

  @override
  Widget build(BuildContext context) {
    Stream<PositionData> _positionDataStream() {
      return rxdart.Rx.combineLatest3<Duration, Duration, Duration?,
              PositionData>(
          reproductorProvider.reproductor.positionStream,
          reproductorProvider.reproductor.bufferedPositionStream,
          reproductorProvider.reproductor.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                song.artwork!.the1000X1000!,
                fit: BoxFit.fill,
              ),
            ),
          ),
          
          Text(song.title!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
          Text(song.title!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
          StreamBuilder<PositionData>(
            stream: _positionDataStream(),
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                duration: positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                bufferedPosition:
                    positionData?.bufferedPosition ?? Duration.zero,
                onChangeEnd: reproductorProvider.reproductor.seek,
              );
            },
          ),
          PlayerButtons(reproductorProvider: reproductorProvider),
        ],
      ),
    );
  }
}

class _BackgroundFilter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.pinkAccent.withOpacity(0.5),
              Colors.deepPurple.withOpacity(0.0),
            ],
            stops: const [
              0.0,
              0.4,
              0.6
            ]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.pinkAccent.shade400.withOpacity(0.8),
              Colors.deepPurple.shade200.withOpacity(0.8),
            ])),
      ),
    );
  }
}
