import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class ReproductorNotifier extends StateNotifier<AudioPlayer> {
  ReproductorNotifier()
      : super(AudioPlayer(
            audioPipeline: AudioPipeline(
        )));
}

final reproductorProvider =
    StateNotifierProvider<ReproductorNotifier, AudioPlayer>((ref) {
  return ReproductorNotifier();
});

final isPlayingProvider = StreamProvider<int?>((ref) async* {
  final driver = ref.watch(reproductorProvider);
  await for (final event in driver.sequenceStream) {
    event;
    yield event != null ? event.length : 0;
  }
});
