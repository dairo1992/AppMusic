import 'package:e_music/config/dbConexion.dart';
import 'package:e_music/models/models.dart';

class PlayListService {
  final db = Conexion().getConexion();
// CONSULTA LAS PLAYLIST LOCALES(SECURE STORAGE)
  Future<List<SongResponse>> getPlayListTracks(String id) async {
    try {
      final resp = await db.get("playlists/$id/tracks?app_name=E_Music");
      if (resp.toString().startsWith("<!DOCTYPE")) {
        return [];
      }
      Iterable i = (resp.data["data"]);
      final response =
          List<SongResponse>.from(i.map((e) => SongResponse.fromJson(e)));
      return response;
    } catch (e) {
      return [];
    }
  }

  // Future<bool> createPlayListOnline()async{}

// CONSULTA LAS PLAYLIST EN TENDENCIA
  // Future<List<SongResponse>> getPlayListTracks(String id) async {
  //   try {
  //     final resp = await db.get("playlists/$id/tracks?app_name=E_Music");
  //     if (resp.toString().startsWith("<!DOCTYPE")) {
  //       return [];
  //     }
  //     Iterable i = (resp.data["data"]);
  //     final response =
  //         List<SongResponse>.from(i.map((e) => SongResponse.fromJson(e)));
  //     return response;
  //   } catch (e) {
  //     return [];
  //   }
  // }
}
