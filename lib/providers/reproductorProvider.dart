import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class ReproductorState {
  bool isPlaying;
  AudioPlayer reproductor;

  ReproductorState({required this.isPlaying, required this.reproductor});
}

class Reproductor2Notifier extends StateNotifier<ReproductorState> {
  Reproductor2Notifier()
      : super(ReproductorState(reproductor: AudioPlayer(), isPlaying: false));

  void addUrl(String id) async {
    state.reproductor.setUrl(
        "https://discoveryprovider3.audius.co/v1/tracks/$id/stream?app_name=E_Music");
    state.reproductor.play();
    state.isPlaying = true;
  }

}

final reproductorProvider =
    StateNotifierProvider<Reproductor2Notifier, ReproductorState>((ref) {
  return Reproductor2Notifier();
});
