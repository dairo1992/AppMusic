import 'package:e_music/models/models.dart';
import 'package:e_music/providers/reproductorProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class MiniReproductor extends ConsumerWidget {
  final SongResponse song;

  MiniReproductor({super.key, required this.song});
  @override
  Widget build(BuildContext context, ref) {
    final reproductor = ref.watch(reproductorProvider);
    final size = MediaQuery.of(context).size;
    return StreamBuilder<PlayerState>(
      stream: reproductor.playerStateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final playerState = snapshot.data;
          return playerState!.playing
              ? Container(
                  width: size.width,
                  height: size.height * 0.1,
                  color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            "assets/images/no-image.jpg",
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset("assets/images/no-image.jpg");
                            },
                          ),
                        ),
                      ),
                      Text("song.title!"),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.play_arrow)),
                    ],
                  ),
                )
              : Container();
        } else {
          return Container();
        }
      },
    );
    // return Container(
    //   width: size.width,
    //   height: size.height * 0.075,
    //   color: Colors.green,
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: [
    //       SizedBox(
    //         width: 60,
    //         height: 50,
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(15),
    //           child: Image.asset(
    //             "assets/images/no-image.jpg",
    //             errorBuilder: (context, error, stackTrace) {
    //               return Image.asset("assets/images/no-image.jpg");
    //             },
    //           ),
    //         ),
    //       ),
    //       Text("Nombre de la cancion"),
    //       IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
    //     ],
    //   ),
    // );
  }
}
