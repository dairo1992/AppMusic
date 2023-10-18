import 'package:e_music/providers/reproductorProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButtons extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final reproductor = ref.watch(reproductorProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<SequenceState?>(
            stream: reproductor.sequenceStateStream,
            builder: (context, snapshot) {
              return IconButton(
                  onPressed: () {
                    print("anterior");
                    reproductor.hasPrevious ? reproductor.seekToPrevious() : null;
                  },
                  icon: const Icon(
                    Icons.skip_previous_rounded,
                    color: Colors.white,
                    size: 45,
                  ));
            }),
        StreamBuilder<PlayerState>(
          stream: reproductor.playerStateStream,
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
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else if (!reproductor.playerState.playing) {
                return IconButton(
                    onPressed: reproductor.play,
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 45,
                    ));
              } else if (procesingState != ProcessingState.completed) {
                return IconButton(
                    onPressed: reproductor.pause,
                    icon: const Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 45,
                    ));
              } else {
                return IconButton(
                    onPressed: () => reproductor.seek(Duration.zero,
                        index: reproductor.effectiveIndices!.first),
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
            stream: reproductor.sequenceStateStream,
            builder: (context, snapshot) {
              return IconButton(
                  onPressed: () {
                    print("siguiente");
                    reproductor.hasNext ? reproductor.seekToNext() : null;
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
