import 'package:e_music/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ModalBottomSheet {
  static void moreModalBottomSheet(
      {required BuildContext context,
      required List<dynamic> songList,
      required String origen}) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: size.height * 0.6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.pinkAccent.shade400.withOpacity(0.8),
                    Colors.deepPurple.shade200.withOpacity(0.8),
                  ]),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(40.0),
                topLeft: Radius.circular(40.0),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Resultados",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.54,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: songList.length,
                      itemBuilder: (context, i) {
                        return SeachCard(
                          songList: songList,
                          origen: origen,
                          index: i,
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
