import 'dart:typed_data';
import 'package:e_music/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';

class OnQueryAudioNotifier extends StateNotifier<OnAudioQuery> {
  OnQueryAudioNotifier() : super(OnAudioQuery());
}

final onQueryAudioProvider =
    StateNotifierProvider<OnQueryAudioNotifier, OnAudioQuery>((ref) {
  return OnQueryAudioNotifier();
});

final checkPermissionProvider = FutureProvider.autoDispose<bool>((ref) async {
  final driver = ref.watch(onQueryAudioProvider);
  final status = await driver.permissionsStatus();
  if (status) return true;
  final permission = await driver.permissionsRequest();
  return permission;
});

final getAudiosProvider =
    FutureProvider.family<List<SongModel>, bool>((ref, limit) async {
  final driver = ref.watch(onQueryAudioProvider);
  final List<SongModel> songs = await driver.querySongs(
    sortType: null,
    orderType: OrderType.ASC_OR_SMALLER,
    uriType: UriType.EXTERNAL,
    ignoreCase: true,
  );
  // return songs;
  // return limit
  //     ? songs
  //         .getRange(0, 10)
  //         .where((e) => e.album!.contains("WhatsApp"))
  //         .toList()
  //     : songs;
  return limit
      ? songs
          .where((song) => !song.album!.contains("WhatsApp"))
          .toList()
          .getRange(0, 10)
          .toList()
      : songs.where((song) => !song.album!.contains("WhatsApp")).toList();
});

final getArtworkProvider =
    FutureProvider.family<Uint8List?, int>((ref, id) async {
  final driver = ref.watch(onQueryAudioProvider);
  if (await driver.checkAndRequest()) {
    return driver.queryArtwork(
      id,
      ArtworkType.AUDIO,
      format: ArtworkFormat.JPEG,
      size: 200,
      quality: 50,
    );
  }
  return null;
});

final getPlayListLocalProvider =
    FutureProvider<List<PlaylistModel>>((ref) async {
  final driver = ref.watch(onQueryAudioProvider);
  return await driver.queryPlaylists();
});

final getTrackPlaylistProvider =
    FutureProvider.family<List<SongModel>, int>((ref, idPlaylist) async {
  final driver = ref.watch(onQueryAudioProvider);
  final listSong =
      await driver.queryAudiosFrom(AudiosFromType.PLAYLIST, idPlaylist);
  return listSong;
});
