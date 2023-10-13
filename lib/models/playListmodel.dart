// To parse this JSON data, do
//
//     final playListResponse = playListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:e_music/models/models.dart';

PlayListResponse playListResponseFromJson(String str) => PlayListResponse.fromJson(json.decode(str));

String playListResponseToJson(PlayListResponse data) => json.encode(data.toJson());

class PlayListResponse {
    final Artwork? artwork;
    final String? description;
    final String? permalink;
    final String? id;
    final bool? isAlbum;
    final bool? isImageAutogenerated;
    final String? playlistName;
    final List<PlaylistContent>? playlistContents;
    final int? repostCount;
    final int? favoriteCount;
    final int? totalPlayCount;
    final User? user;

    PlayListResponse({
        this.artwork,
        this.description,
        this.permalink,
        this.id,
        this.isAlbum,
        this.isImageAutogenerated,
        this.playlistName,
        this.playlistContents,
        this.repostCount,
        this.favoriteCount,
        this.totalPlayCount,
        this.user,
    });

    PlayListResponse copyWith({
        Artwork? artwork,
        String? description,
        String? permalink,
        String? id,
        bool? isAlbum,
        bool? isImageAutogenerated,
        String? playlistName,
        List<PlaylistContent>? playlistContents,
        int? repostCount,
        int? favoriteCount,
        int? totalPlayCount,
        User? user,
    }) => 
        PlayListResponse(
            artwork: artwork ?? this.artwork,
            description: description ?? this.description,
            permalink: permalink ?? this.permalink,
            id: id ?? this.id,
            isAlbum: isAlbum ?? this.isAlbum,
            isImageAutogenerated: isImageAutogenerated ?? this.isImageAutogenerated,
            playlistName: playlistName ?? this.playlistName,
            playlistContents: playlistContents ?? this.playlistContents,
            repostCount: repostCount ?? this.repostCount,
            favoriteCount: favoriteCount ?? this.favoriteCount,
            totalPlayCount: totalPlayCount ?? this.totalPlayCount,
            user: user ?? this.user,
        );

    factory PlayListResponse.fromJson(Map<String, dynamic> json) => PlayListResponse(
        artwork: json["artwork"] == null ? null : Artwork.fromJson(json["artwork"]),
        description: json["description"],
        permalink: json["permalink"],
        id: json["id"],
        isAlbum: json["is_album"],
        isImageAutogenerated: json["is_image_autogenerated"],
        playlistName: json["playlist_name"],
        playlistContents: json["playlist_contents"] == null ? [] : List<PlaylistContent>.from(json["playlist_contents"]!.map((x) => PlaylistContent.fromJson(x))),
        repostCount: json["repost_count"],
        favoriteCount: json["favorite_count"],
        totalPlayCount: json["total_play_count"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "artwork": artwork?.toJson(),
        "description": description,
        "permalink": permalink,
        "id": id,
        "is_album": isAlbum,
        "is_image_autogenerated": isImageAutogenerated,
        "playlist_name": playlistName,
        "playlist_contents": playlistContents == null ? [] : List<dynamic>.from(playlistContents!.map((x) => x.toJson())),
        "repost_count": repostCount,
        "favorite_count": favoriteCount,
        "total_play_count": totalPlayCount,
        "user": user?.toJson(),
    };
}

class PlaylistContent {
    final dynamic metadataTimestamp;
    final dynamic timestamp;
    final dynamic trackId;

    PlaylistContent({
        this.metadataTimestamp,
        this.timestamp,
        this.trackId,
    });

    PlaylistContent copyWith({
        dynamic metadataTimestamp,
        dynamic timestamp,
        dynamic trackId,
    }) => 
        PlaylistContent(
            metadataTimestamp: metadataTimestamp ?? this.metadataTimestamp,
            timestamp: timestamp ?? this.timestamp,
            trackId: trackId ?? this.trackId,
        );

    factory PlaylistContent.fromJson(Map<String, dynamic> json) => PlaylistContent(
        metadataTimestamp: json["metadata_timestamp"],
        timestamp: json["timestamp"],
        trackId: json["track_id"],
    );

    Map<String, dynamic> toJson() => {
        "metadata_timestamp": metadataTimestamp,
        "timestamp": timestamp,
        "track_id": trackId,
    };
}
