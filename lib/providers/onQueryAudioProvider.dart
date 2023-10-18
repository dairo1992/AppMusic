import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

class OnQueryAudioNotifier extends StateNotifier<OnAudioQuery> {
  OnQueryAudioNotifier() : super(OnAudioQuery());

  Future<bool> checkAndRequestPermissions({bool retry = false}) async {
    return Future.value(state.checkAndRequest(
      retryRequest: retry,
    ));
  }
}

final onQueryAudioProvider =
    StateNotifierProvider<OnQueryAudioNotifier, OnAudioQuery>((ref) {
  return OnQueryAudioNotifier();
});
