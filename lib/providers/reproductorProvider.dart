import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class ReproductorNotifier extends StateNotifier<AudioPlayer> {
  ReproductorNotifier() : super(AudioPlayer());
}

final reproductorProvider =
    StateNotifierProvider<ReproductorNotifier, AudioPlayer>((ref) {
  return ReproductorNotifier();
});