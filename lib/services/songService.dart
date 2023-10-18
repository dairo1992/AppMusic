import 'dart:async';
import 'package:e_music/config/dbConexion.dart';
import 'package:e_music/models/models.dart';
import 'package:flutter/foundation.dart';

class SongService {
  final db = Conexion().getConexion();

  Future<SongResponse?> getSong(String id) async {
    try {
      final resp = await db.get("tracks/$id?app_name=E_Music");
      final response = SongResponse.fromJson(resp.data["data"]);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("$e");
      }
      return null;
    }
  }

  Future<List<SongResponse>> getPlayListSong(List<String> listid) async {
    List<SongResponse> lista = [];
    Completer<List<SongResponse>> c = Completer();
    for (var e in listid) {
      try {
        final resp = await db.get("tracks/$e?app_name=E_Music");
        final response = SongResponse.fromJson(resp.data["data"]);
        lista.add(response);
        c.complete(lista);
      } catch (e) {}
    }
    return c.future;
  }

  Future<List<SongResponse>> searchSong(String query) async {
    try {
      final resp = await db.get(
          "https://blockdaemon-audius-discovery-01.bdnodes.net/v1/tracks/search?app_name=EXAMPLEAPP",
          queryParameters: {"query": query});
      Iterable i = (resp.data["data"]);
      final response =
          List<SongResponse>.from(i.map((e) => SongResponse.fromJson(e)));
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("$e");
      }
      return [];
    }
  }
}
