import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:e_music/models/models.dart';
import 'package:e_music/providers/providers.dart';
import 'package:e_music/widgets/widgets.dart';

class PlayListScreen extends ConsumerWidget {
  final PlayListOnlineModel? playListonline;
  final PlaylistModel? playListLocal;

  const PlayListScreen({super.key, this.playListonline, this.playListLocal});

  @override
  Widget build(BuildContext context, ref) {
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                _PlayListInformation(
                    title: playListonline != null
                        ? playListonline!.title!
                        : playListLocal!.playlist),
                playListLocal == null
                    ? _ButtonsPlayAndShuffles(
                        playListOnline: playListonline!.songs!)
                    : ref
                        .watch(getTrackPlaylistProvider(playListLocal!.id))
                        .when(
                          data: (data) =>
                              _ButtonsPlayAndShuffles(playListLocal: data),
                          error: (error, stackTrace) => Text("$error"),
                          loading: () => CircularProgressIndicator(),
                        ),
                playListonline != null
                    ? OnlineList(playList: playListonline!)
                    : LocalList(playList: playListLocal!)
              ],
            ),
          )),
    );
  }
}

class LocalList extends ConsumerWidget {
  final PlaylistModel playList;

  const LocalList({super.key, required this.playList});

  @override
  Widget build(BuildContext context, ref) {
    final songs = ref.watch(getTrackPlaylistProvider(playList.id));
    return songs.when(
        data: (data) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.push("/playing",
                        extra: {'localSongs': data, 'indexSong': index});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "${index + 1}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 230,
                          child: Text(
                            data[index].title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Text(
                          "${Duration(milliseconds: data[index].duration!).toString().split(":")[1]} : ${Duration(milliseconds: data[index].duration!).toString().split(":")[2].split(".")[0]}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        error: (error, stackTrace) => Text("$error"),
        loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ));
  }
}

class OnlineList extends StatelessWidget {
  final PlayListOnlineModel playList;

  const OnlineList({super.key, required this.playList});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: playList.songs!.length,
      itemBuilder: (context, index) {
        final String duration;
        if (playList.songs![index].duration.toString().length >= 4) {
          duration =
              "${playList.songs![index].duration.toString().substring(0, 2)} : ${playList.songs![index].duration.toString().substring(2)}";
        } else {
          duration =
              "${playList.songs![index].duration.toString().substring(0, 1)} : ${playList.songs![index].duration.toString().substring(1)}";
        }
        return GestureDetector(
          onTap: () {
            context.push("/playing",
                extra: {'onlineSongs': playList.songs, 'indexSong': index});
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "${index + 1}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 230,
                  child: Text(
                    "${playList.songs![index].title}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Text(
                  duration,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ButtonsPlayAndShuffles extends StatelessWidget {
  List<SongResponse>? playListOnline;
  List<SongModel>? playListLocal;
  _ButtonsPlayAndShuffles({
    Key? key,
    this.playListOnline,
    this.playListLocal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            context.push("/playing", extra: {
              (playListOnline != null ? 'onlineSongs' : 'localSongs'):
                  playListOnline ?? playListLocal,
              'indexSong': 0
            });
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
        GestureDetector(
          onTap: () {
            context.push("/playing", extra: {
              (playListOnline != null ? 'onlineSongs' : 'localSongs'):
                  playListOnline ?? playListLocal,
              'indexSong': 0,
              'shuffle': true
            });
          },
          child: Container(
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
                const Icon(Icons.shuffle_outlined, color: Colors.pink)
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayListInformation extends StatelessWidget {
  final String title;

  const _PlayListInformation({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset("assets/images/playlist-music-modern.jpg")),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          height: 55,
          child: Text(
            title,
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
