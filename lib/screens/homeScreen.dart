import 'package:e_music/models/models.dart';
import 'package:e_music/providers/providers.dart';
import 'package:e_music/services/songService.dart';
import 'package:e_music/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final reproductor = ref.watch(reproductorProvider);
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
          leading: Icon(Icons.grid_view_rounded, color: Colors.white),
          avatar:
              "https://as2.ftcdn.net/v2/jpg/05/62/57/51/500_F_562575144_J8ohmiSchh1A82kVXqEr9ya50DnQEFQk.jpg",
          title: '',
        ),
        body: Column(
          children: [
            SizedBox(
              width: size.width,
              height: size.height * 0.75,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const _FiltrarMusic(),
                    _TrendingMusic(),
                    _PlayListmusic()
                  ],
                ),
              ),
            ),
            reproductor.reproductor.playerState.playing
                ? _MiniReproductor(size: size)
                : Container()
          ],
        ),
        bottomNavigationBar: const _CustomNavigationBar(),
      ),
    );
  }
}

class _MiniReproductor extends StatelessWidget {
  const _MiniReproductor({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height * 0.078,
      color: Colors.transparent,
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
          Text("Nombre de la cancion"),
          IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
        ],
      ),
    );
  }
}

class _PlayListmusic extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final playList = ref.watch(playListProvider);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SectionHeader(title: "PlayLists"),
          playList.when(
              data: (data) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: 20,
                    padding: const EdgeInsets.only(top: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PlayListCard(
                        playList: data[index],
                      );
                    },
                  ),
              error: (error, stackTrace) => Text("$error"),
              loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ))
        ],
      ),
    );
  }
}

class _TrendingMusic extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final trending = ref.watch(trendingFutureProvider);
    return trending.when(
        data: (songs) => Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: SectionHeader(title: "Tendencia Music"),
                    )
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: ListView.builder(
                      itemCount: songs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return SongCard(
                          song: songs[index],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
        error: (error, stackTrace) => Text("$error"),
        loading: () => const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ));
  }
}

class _FiltrarMusic extends StatelessWidget {
  const _FiltrarMusic({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bienvenido",
              style: GoogleFonts.montserratAlternates(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          const Text("Comienda a escuchar tu musica favorita"),
          const SizedBox(
            height: 20,
          ),
          _Searchinput()
        ],
      ),
    );
  }
}

class _Searchinput extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final TextEditingController inputSearch = TextEditingController();
    return TextFormField(
      controller: inputSearch,
      onFieldSubmitted: (value) async {
        print(inputSearch.text);
        // inputSearch.clear();
        final songList = await SongService().searchSong(inputSearch.text);
        ModalBottomSheet.moreModalBottomSheet(context, songList);
        // songList.when(
        //     data: (data) {
        //       if (data.isNotEmpty) {
        //         ModalBottomSheet.moreModalBottomSheet(context, data);
        //       }
        //     },
        //     error: (error, stackTrace) => Center(
        //           child: Text("$error"),
        //         ),
        //     loading: () => const Center(
        //           child: CircularProgressIndicator(),
        //         ));
      },
      style: const TextStyle(color: Colors.pink),
      decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          hintText: "Buscar",
          hintStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.pink),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade400,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none)),
    );
  }
}

class _CustomNavigationBar extends StatelessWidget {
  const _CustomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.deepPurple.shade800,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoritas"),
        BottomNavigationBarItem(
            icon: Icon(Icons.music_note_sharp), label: "Playing"),
        BottomNavigationBarItem(icon: Icon(Icons.people_alt), label: "Perfil"),
      ],
    );
  }
}
