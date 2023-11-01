import 'package:flutter_riverpod/flutter_riverpod.dart';
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
