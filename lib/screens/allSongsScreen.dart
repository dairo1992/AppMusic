import 'package:e_music/providers/providers.dart';
import 'package:e_music/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AllSongsScreen extends ConsumerWidget {
  const AllSongsScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final onQueryAudio = ref.watch(getAudiosProvider(false));
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
        appBar: CustomAppBar(
          title: "Tu Música",
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
        ),
        body: onQueryAudio.when(
            data: (songs) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: CustomScrollView(
                        slivers: [
                          SliverGrid.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemCount: songs.length,
                            itemBuilder: (context, i) {
                              final artworkAsync =
                                  ref.watch(getArtworkProvider(songs[i].id));
                              return artworkAsync.when(
                                  data: (data) {
                                    if (data != null) {
                                      return GestureDetector(
                                          onTap: () => context.push("/playing",
                                                  extra: {
                                                    'localSongs': songs,
                                                    'indexSong': i
                                                  }),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 70,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius
                                                            .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    20)),
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: MemoryImage(
                                                          data,
                                                          scale: 1.0,
                                                        ))),
                                              ),
                                              SizedBox(
                                                height: 30,
                                                child: Text(
                                                  songs[i].title,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ));
                                    }
                                    return GestureDetector(
                                        onTap: () => context.push("/playing",
                                                extra: {
                                                  'localSongs': songs,
                                                  'indexSong': i
                                                }),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 70,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              20)),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          "assets/images/no-image.jpg"))),
                                            ),
                                            SizedBox(
                                              height: 30,
                                              child: Text(
                                                songs[i].title,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ));
                                  },
                                  error: (error, stackTrace) => Center(
                                        child: Text("$error"),
                                      ),
                                  loading: () => const Center(
                                        child: CircularProgressIndicator(),
                                      ));
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
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
