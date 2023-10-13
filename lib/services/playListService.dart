import 'package:e_music/config/dbConexion.dart';
import 'package:e_music/models/models.dart';

class PlayListService {
  final db = Conexion().getConexion();

  Future<List<SongResponse>> getPlayListTracks(String id) async {
    try {
      final resp = await db.get("playlists/$id/tracks?app_name=E_Music");
      Iterable i = (resp.data["data"]);
      final response =
          List<SongResponse>.from(i.map((e) => SongResponse.fromJson(e)));
      return response;
    } catch (e) {
      return [];
    }
  }
}
