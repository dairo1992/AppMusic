import 'dart:typed_data';

import 'package:e_music/models/audioMetadata.dart';
import 'package:e_music/models/models.dart';
import 'package:e_music/providers/reproductorProvider.dart';
import 'package:e_music/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniReproductor extends ConsumerWidget {
  const MiniReproductor({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final reproductor = ref.watch(reproductorProvider);
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        context.push("/playing",
            extra: {'onlineSongs': <SongResponse>[], 'indexSong': -1});
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        color: Colors.pink.shade100,
        width: size.width,
        height: 70,
        child: StreamBuilder<SequenceState?>(
          stream: reproductor.sequenceStateStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            if (state?.sequence.isEmpty ?? true) {
              return const SizedBox();
            }
            final metadata = state!.currentSource!.tag as MediaItem;
            final image =
                metadata.artHeaders!["image"]!.contains("https") == true
                    ? "I"
                    : "L";
            return Row(
              children: [
                Hero(
                  tag: metadata.id,
                  child: SizedBox(
                    width: size.width * 0.13,
                    height: size.height * 0.07,
                    child: image == "L"
                        ? FutureBuilder<Uint8List?>(
                            future: OnAudioQuery().queryArtwork(
                                int.parse(metadata.id), ArtworkType.AUDIO,
                                format: ArtworkFormat.JPEG,
                                size: 200,
                                quality: 50),
                            builder: (context, item) {
                              if (item.data != null && item.data!.isNotEmpty) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.memory(
                                    item.data!,
                                    gaplessPlayback: false,
                                    repeat: ImageRepeat.noRepeat,
                                    scale: 1.0,
                                    width: size.width,
                                    height: size.height * 0.5,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.low,
                                    errorBuilder:
                                        (context, exception, stackTrace) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        clipBehavior: Clip.antiAlias,
                                        child: Image.asset(
                                          "assets/images/no-image.jpg",
                                          gaplessPlayback: false,
                                          repeat: ImageRepeat.noRepeat,
                                          scale: 1.0,
                                          width: size.width,
                                          height: size.height * 0.5,
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.low,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  "assets/images/no-image.jpg",
                                  gaplessPlayback: false,
                                  repeat: ImageRepeat.noRepeat,
                                  scale: 1.0,
                                  width: size.width,
                                  height: size.height * 0.5,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                ),
                              );
                            })
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              metadata.artHeaders!["image"]!,
                              fit: BoxFit.fill,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Image(
                                    image: AssetImage(
                                        "assets/images/loading.gif"));
                              },
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.46,
                  child: Text(
                    metadata.title,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: size.height * 0.12,
                  child: PlayerButtons(
                    sizeIcon: 30,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
