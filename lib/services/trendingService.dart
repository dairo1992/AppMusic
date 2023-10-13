import 'package:e_music/config/dbConexion.dart';
import 'package:e_music/models/models.dart';
import 'package:flutter/foundation.dart';

class TrendingService {
  final db = Conexion().getConexion();

  Future<List<SongResponse>> getTrending() async {
    try {
      final resp = await db.get("tracks/trending?app_name=E_Music");
      Iterable i = (resp.data["data"]);
      final response =
          List<SongResponse>.from(i.map((e) => SongResponse.fromJson(e)));
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("$e");
      }
      return <SongResponse>[];
    }
  }

  Future<List<PlayListResponse>> getPlayList() async {
    try {
      final resp = await db.get("playlists/trending?app_name=E_Music");
      Iterable i = (resp.data["data"]);
      final response = List<PlayListResponse>.from(
          i.map((e) => PlayListResponse.fromJson(e)));
      return response;
    } catch (e) {
      if (kDebugMode) {
        print("$e");
      }
      return <PlayListResponse>[];
    }
  }
}
