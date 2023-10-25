import 'package:e_music/providers/providers.dart';
import 'package:e_music/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FiltrarMusic extends StatelessWidget {
  final String origen;

  const FiltrarMusic({super.key, required this.origen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Bienvenido",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          const Text("Comienda a escuchar tu musica favorita"),
          const SizedBox(
            height: 20,
          ),
          _Searchinput(
            origen: origen,
          )
        ],
      ),
    );
  }
}

class _Searchinput extends ConsumerWidget {
  final String origen;

  _Searchinput({super.key, required this.origen});
  @override
  Widget build(BuildContext context, ref) {
    final TextEditingController inputSearch = TextEditingController();
    return TextFormField(
      controller: inputSearch,
      onFieldSubmitted: (value) async {
        final List<dynamic> songs = await searchSong(value, ref);
        ModalBottomSheet.moreModalBottomSheet(
            context: context, songList: songs, origen: origen);
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

Future<List<dynamic>> searchSong(String query, WidgetRef ref) async {
  final result = await ref
      .watch(onQueryAudioProvider)
      .queryWithFilters(query, WithFiltersType.AUDIOS);
  return result;
}
