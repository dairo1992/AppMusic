import 'package:e_music/providers/reproductorProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButtons extends ConsumerWidget {
  final double sizeIcon;
  final bool? showShuffle;

  const PlayerButtons(
      {super.key, required this.sizeIcon, this.showShuffle = false});
  @override
  Widget build(BuildContext context, ref) {
    final reproductor = ref.watch(reproductorProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<SequenceState?>(
            stream: reproductor.sequenceStateStream,
            builder: (context, snapshot) {
              return reproductor.hasPrevious
                  ? IconButton(
                      onPressed: () {
                        reproductor.hasPrevious
                            ? reproductor.seekToPrevious()
                            : null;
                      },
                      icon: Icon(
                        Icons.skip_previous_rounded,
                        color: Colors.white,
                        size: sizeIcon,
                      ))
                  : Container();
            }),
        StreamBuilder<PlayerState>(
          stream: reproductor.playerStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playerState = snapshot.data;
              var procesingState = (playerState!).processingState;
              if (procesingState == ProcessingState.loading ||
                  procesingState == ProcessingState.buffering) {
                return SizedBox(
                  width: sizeIcon,
                  height: sizeIcon,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else if (!reproductor.playerState.playing) {
                return IconButton(
                    onPressed: reproductor.play,
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: sizeIcon,
                    ));
              } else if (procesingState != ProcessingState.completed) {
                return IconButton(
                    onPressed: reproductor.pause,
                    icon: Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: sizeIcon,
                    ));
              } else {
                return IconButton(
                    onPressed: () => reproductor.seek(Duration.zero,
                        index: reproductor.effectiveIndices!.first),
                    icon: Icon(
                      Icons.replay_sharp,
                      color: Colors.white,
                      size: sizeIcon,
                    ));
              }
            } else {
              return const CircularProgressIndicator(
                color: Colors.white,
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
            stream: reproductor.sequenceStateStream,
            builder: (context, snapshot) {
              return reproductor.hasNext
                  ? IconButton(
                      onPressed: () {
                        reproductor.hasNext ? reproductor.seekToNext() : null;
                      },
                      icon: Icon(
                        Icons.skip_next_rounded,
                        color: Colors.white,
                        size: sizeIcon,
                      ))
                  : Container();
            }),
        showShuffle!
            ? StreamBuilder<bool>(
                stream: reproductor.shuffleModeEnabledStream,
                builder: (context, snapshot) {
                  final shuffleModeEnabled = snapshot.data ?? false;
                  return IconButton(
                      onPressed: () async {
                        final enable = !shuffleModeEnabled;
                        if (enable) {
                          await reproductor.shuffle();
                        }
                        await reproductor.setShuffleModeEnabled(enable);
                      },
                      icon: shuffleModeEnabled
                          ? const Icon(Icons.shuffle_on_outlined, color: Colors.white)
                          : const Icon(Icons.shuffle, color: Colors.white));
                },
              )
            : const SizedBox(),
      ],
    );
  }
}
