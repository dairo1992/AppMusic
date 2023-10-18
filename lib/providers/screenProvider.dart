import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedScreen {
  int index;

  SelectedScreen({required this.index});

  SelectedScreen copyWith({int? index}) {
    return SelectedScreen(index: index ?? this.index);
  }
}

class SelectedScreenNotifier extends StateNotifier<SelectedScreen> {
  SelectedScreenNotifier() : super(SelectedScreen(index: 1));

  void setScreen(int tab) {
    if (tab != state.index) {
      state = SelectedScreen(index: tab);
    }
  }
}

final selectScreenProvider =
    StateNotifierProvider<SelectedScreenNotifier, SelectedScreen>((ref) {
  return SelectedScreenNotifier();
});
