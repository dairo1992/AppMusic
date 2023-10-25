import 'package:e_music/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomNavigationBar extends ConsumerWidget {
  const CustomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final index = ref.watch(selectScreenProvider).index;
    return BottomNavigationBar(
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.deepPurple.shade100.withOpacity(0.5),
      elevation: 0,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.pink,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      onTap: (value) {
        ref.read(selectScreenProvider.notifier).setScreen(value);
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            activeIcon: Icon(Icons.home),
            label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.music_note_outlined),
            label: "Online",
            activeIcon: Icon(Icons.music_note_sharp)),
        BottomNavigationBarItem(
            icon: Icon(Icons.folder_shared_outlined),
            activeIcon: Icon(Icons.folder_shared_rounded),
            label: "Off line"),
      ],
    );
  }
}
