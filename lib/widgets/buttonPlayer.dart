import 'package:e_music/providers/reproductorProvider.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({
    super.key,
    required this.reproductorProvider,
  });

  final ReproductorState reproductorProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<SequenceState?>(
            stream: reproductorProvider.reproductor.sequenceStateStream,
            builder: (context, snapshot) {
              return IconButton(
                  onPressed: () {
                    print("anterior");
                    reproductorProvider.reproductor.hasPrevious
                        ? reproductorProvider.reproductor.seekToPrevious
                        : null;
                  },
                  icon: const Icon(
                    Icons.skip_previous_rounded,
                    color: Colors.white,
                    size: 45,
                  ));
            }),
        StreamBuilder<PlayerState>(
          stream: reproductorProvider.reproductor.playerStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playerState = snapshot.data;
              var procesingState = (playerState!).processingState;
              if (procesingState == ProcessingState.loading ||
                  procesingState == ProcessingState.buffering) {
                return Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.all(10),
                  child: const CircularProgressIndicator(color: Colors.white, ),
                );
              } else if (!reproductorProvider.reproductor.playing) {
                return IconButton(
                    onPressed: reproductorProvider.reproductor.play,
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 45,
                    ));
              } else if (procesingState != ProcessingState.completed) {
                return IconButton(
                    onPressed: reproductorProvider.reproductor.pause,
                    icon: const Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 45,
                    ));
              } else {
                return IconButton(
                    onPressed: () => reproductorProvider.reproductor.seek(
                        Duration.zero,
                        index: reproductorProvider
                            .reproductor.effectiveIndices!.first),
                    icon: const Icon(
                      Icons.replay_sharp,
                      color: Colors.white,
                      size: 45,
                    ));
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        StreamBuilder<SequenceState?>(
            stream: reproductorProvider.reproductor.sequenceStateStream,
            builder: (context, snapshot) {
              return IconButton(
                  onPressed: () {
                    print("siguiente");
                    reproductorProvider.reproductor.hasNext
                        ? reproductorProvider.reproductor.seekToNext
                        : null;
                  },
                  icon: const Icon(
                    Icons.skip_next_rounded,
                    color: Colors.white,
                    size: 45,
                  ));
            }),
      ],
    );
  }
}
