import 'dart:convert';
import 'package:e_music/models/models.dart';
import 'package:e_music/services/songService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class PlaylistOnlineNotifier extends StateNotifier<List<PlayListOnlineModel>> {
  PlaylistOnlineNotifier() : super([]);

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));
  final Uuid uuid = const Uuid();

  Future<bool> addPlayListOnline(String title) async {
    final exist = await secureStorage.read(key: title);
    if (exist == null) {
      final id = uuid.v4();
      final playList = PlayListOnlineModel(id: id, title: title, songs: []);
      secureStorage.write(key: title, value: jsonEncode(playList));
      state = [...state, playList];
      return true;
    } else {
      return false;
    }
  }

  void getPlayListOnline() async {
    final playList = await secureStorage.readAll();
    final List<PlayListOnlineModel> playLists = [];
    if (playList.isNotEmpty) {
      playList.forEach((key, value) {
        playLists.add(PlayListOnlineModel.fromJson(jsonDecode(value)));
      });
      state = playLists;
    }
  }

  Future<bool> addSong(String idPlayList, String idSong) async {
    final exist = await secureStorage.read(key: idPlayList);
    if (exist != null) {
      final playList = PlayListOnlineModel.fromJson(jsonDecode(exist));
      final songService = SongService();
      final SongResponse? song = await songService.getSong(idSong);
      playList.songs!.add(song!);
      await secureStorage.delete(key: idPlayList);
      await secureStorage.write(key: idPlayList, value: jsonEncode(playList));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editPlayList(String name, String newName) async {
    final exist = await secureStorage.read(key: name);
    if (exist != null) {
      PlayListOnlineModel playList =
          PlayListOnlineModel.fromJson(jsonDecode(exist));
      final playListNew = PlayListOnlineModel(
          id: playList.id, title: newName, songs: playList.songs);
      await secureStorage.delete(key: name);
      secureStorage.write(key: newName, value: jsonEncode(playListNew));
      return true;
    } else {
      return false;
    }
  }

  void deletePlaylist(String idPlayList) async {
    await secureStorage.delete(key: idPlayList);
  }
}

final playListOnloneProvider =
    StateNotifierProvider<PlaylistOnlineNotifier, List<PlayListOnlineModel>>(
        (ref) {
  return PlaylistOnlineNotifier();
});
