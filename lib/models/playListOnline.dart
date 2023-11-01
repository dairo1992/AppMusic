import 'dart:convert';

import 'package:e_music/models/models.dart';

PlayListOnlineModel playListOnlineModelFromJson(String str) =>
    PlayListOnlineModel.fromJson(json.decode(str));

String playListOnlineModelToJson(PlayListOnlineModel data) =>
    json.encode(data.toJson());

class PlayListOnlineModel {
  final String? id;
  final String? title;
  final List<SongResponse>? songs;

  PlayListOnlineModel({
    this.id,
    this.title,
    this.songs,
  });

  PlayListOnlineModel copyWith({
    String? id,
    String? title,
    List<SongResponse>? songs,
  }) =>
      PlayListOnlineModel(
        id: id ?? this.id,
        title: title ?? this.title,
        songs: songs ?? this.songs,
      );

  factory PlayListOnlineModel.fromJson(Map<String, dynamic> json) =>
      PlayListOnlineModel(
        id: json["id"],
        title: json["title"],
        songs: json["songs"] == null
            ? []
            : List<SongResponse>.from(
                json["songs"].map((x) => SongResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "songs": songs == null ? [] : List<dynamic>.from(songs!.map((x) => x)),
      };
}
