import 'package:e_music/models/models.dart';
import 'package:e_music/providers/providers.dart';
import 'package:e_music/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PlayListScreen extends ConsumerWidget {
  final PlayListResponse playList;

  PlayListScreen({super.key, required this.playList});

  @override
  Widget build(BuildContext context, ref) {
    final tracks = ref.watch(playListTrackProvider(playList.id!));
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
                      _PlayOrShuffleSwith(),
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

class _PlayOrShuffleSwith extends StatefulWidget {
  @override
  State<_PlayOrShuffleSwith> createState() => _PlayOrShuffleSwithState();
}

class _PlayOrShuffleSwithState extends State<_PlayOrShuffleSwith> {
  bool isPlay = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          isPlay = !isPlay;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 50,
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Stack(children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              left: isPlay ? 0 : size.width * 0.45,
              child: Container(
                  height: 50,
                  width: size.width * 0.5,
                  decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(15))),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text("Play",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        !isPlay ? Colors.pink : Colors.white)),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.play_arrow,
                          color: !isPlay ? Colors.pink : Colors.white)
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text("Shuffle",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        isPlay ? Colors.pink : Colors.white)),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.shuffle_sharp,
                          color: isPlay ? Colors.pink : Colors.white)
                    ],
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
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
