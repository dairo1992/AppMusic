import 'package:e_music/models/models.dart';
import 'package:e_music/providers/providers.dart';
import 'package:e_music/screens/screens.dart';
import 'package:e_music/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  final SongResponse? song;
  const HomeScreen({super.key, this.song});

  @override
  Widget build(BuildContext context, ref) {
    final index = ref.watch(selectScreenProvider).index;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.pinkAccent.shade400.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8),
          ])),
      child: Scaffold(
        appBar: const CustomAppBar(
          // leading: IconButton(
          //     onPressed: () {
          //       // Wakelock.enable();
          //     },
          //     icon: const Icon(Icons.grid_view_rounded, color: Colors.white)),
          avatar:
              "https://as2.ftcdn.net/v2/jpg/05/62/57/51/500_F_562575144_J8ohmiSchh1A82kVXqEr9ya50DnQEFQk.jpg",
          title: '',
        ),
        body: SingleChildScrollView(child: selectedScreen(index)),
        bottomNavigationBar: const CustomNavigationBar(),
      ),
    );
  }
}

Widget selectedScreen(tab) {
  switch (tab) {
    case 0:
      return const Center(
        child: Column(
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text("Desarrollado por:"),
            Text("Dairo Rafael Barrios Ramos"),
            Text("dairo.barrios.ramos@gmail.com"),
            SizedBox(
              height: 50,
            ),
            Text("uso de api AUDIUS"),
            SizedBox(
              height: 50,
            ),
            Text("Derechos Reservados"),
            Text("2023"),
          ],
        ),
      );

    case 1:
      return const OnlineScreen();

    case 2:
      return OfflineScreen();

    default:
      return const Center(
        child: Text("pagina incio"),
      );
  }
}
