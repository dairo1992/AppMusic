import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FiltrarMusic extends StatelessWidget {
  const FiltrarMusic({
    super.key,
  });

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
      onFieldSubmitted: (value) async {},
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
