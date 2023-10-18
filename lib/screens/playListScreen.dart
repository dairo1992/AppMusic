import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:e_music/models/models.dart';
import 'package:e_music/providers/providers.dart';
import 'package:e_music/widgets/widgets.dart';

class PlayListScreen extends ConsumerWidget {
  final PlayListResponse playList;

  PlayListScreen({super.key, required this.playList});

  @override
  Widget build(BuildContext context, ref) {
    final (tracks) = ref.watch(playListTrackProvider(playList.id!));
    final size = MediaQuery.of(context).size;
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
          avatar:
              "https://as2.ftcdn.net/v2/jpg/05/62/57/51/500_F_562575144_J8ohmiSchh1A82kVXqEr9ya50DnQEFQk.jpg",
          title: 'PlayList',
        ),
        body: tracks.when(
            data: (data) => SingleChildScrollView(
                  child: Column(
                    children: [
                      _PlayListInformation(playList: playList),
                      _buttonsPlayAndShuffles(playList: data),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              context.push("/playing",
                                  extra: {'idSong': data[index].id});
                            },
                            child: ListTile(
                              leading: Text(
                                "${index + 1}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  "${data[index].title} - ${data[index].duration}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                              trailing: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
            error: (error, stackTrace) => Center(
                  child: Text("$error"),
                ),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )),
      ),
    );
  }
}

class _buttonsPlayAndShuffles extends StatelessWidget {
  List<SongResponse> playList;
  _buttonsPlayAndShuffles({
    Key? key,
    required this.playList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            List<String> lista = [];
            playList.forEach((e) {
              lista.add(e.id!);
            });
            context.push("/playing", extra: {'idSong': lista});
          },
          child: Container(
            height: 50,
            width: size.width * 0.4,
            decoration: BoxDecoration(
                color: Colors.pink, borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text("Play",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.play_arrow, color: Colors.white)
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        Container(
          height: 50,
          width: size.width * 0.4,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text("Play",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.pink)),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.play_arrow, color: Colors.pink)
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayListInformation extends StatelessWidget {
  const _PlayListInformation({
    super.key,
    required this.playList,
  });

  final PlayListResponse playList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                playList.artwork!.the480X480!,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset("assets/images/no-image.jpg");
                },
              )),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          height: 55,
          child: Text(
            playList.playlistName!,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
