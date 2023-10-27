import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock/wakelock.dart';

class WakeLockNotifier extends StateNotifier<bool> {
  WakeLockNotifier() : super(false);

  void enable() {
    state = true;
    Wakelock.enable();
  }

  void disable() {
    state = false;
    Wakelock.disable();
  }
}

final wakeLockProvider = StateNotifierProvider<WakeLockNotifier, bool>((ref) {
  return WakeLockNotifier();
});

class SwitchModel extends StateNotifier<bool> {
  SwitchModel() : super(false);

  bool get getSw {
    return state;
  }

  set sw(bool value) {
    state = state;
  }

  toogle() {
    state = !state;
  }
}

final switchProvider =
    StateNotifierProvider<SwitchModel, bool>((ref) => SwitchModel());
