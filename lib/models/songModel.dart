// To parse this JSON data, do
//
//     final songResponse = songResponseFromJson(jsonString);

import 'dart:convert';

import 'package:e_music/models/artworkModel.dart';
import 'package:e_music/models/models.dart';

SongResponse songResponseFromJson(String str) =>
    SongResponse.fromJson(json.decode(str));

String songResponseToJson(SongResponse data) => json.encode(data.toJson());

class SongResponse {
  final Artwork? artwork;
  final dynamic description;
  final String? genre;
  final String? id;
  final String? trackCid;
  final dynamic previewCid;
  final dynamic mood;
  final String? releaseDate;
  final RemixOf? remixOf;
  final int? repostCount;
  final int? favoriteCount;
  final dynamic tags;
  final String? title;
  final User? user;
  final int? duration;
  final bool? downloadable;
  final int? playCount;
  final String? permalink;
  final bool? isStreamable;

  SongResponse({
    this.artwork,
    this.description,
    this.genre,
    this.id,
    this.trackCid,
    this.previewCid,
    this.mood,
    this.releaseDate,
    this.remixOf,
    this.repostCount,
    this.favoriteCount,
    this.tags,
    this.title,
    this.user,
    this.duration,
    this.downloadable,
    this.playCount,
    this.permalink,
    this.isStreamable,
  });

  SongResponse copyWith({
    Artwork? artwork,
    dynamic description,
    String? genre,
    String? id,
    String? trackCid,
    dynamic previewCid,
    dynamic mood,
    String? releaseDate,
    RemixOf? remixOf,
    int? repostCount,
    int? favoriteCount,
    dynamic tags,
    String? title,
    User? user,
    int? duration,
    bool? downloadable,
    int? playCount,
    String? permalink,
    bool? isStreamable,
  }) =>
      SongResponse(
        artwork: artwork ?? this.artwork,
        description: description ?? this.description,
        genre: genre ?? this.genre,
        id: id ?? this.id,
        trackCid: trackCid ?? this.trackCid,
        previewCid: previewCid ?? this.previewCid,
        mood: mood ?? this.mood,
        releaseDate: releaseDate ?? this.releaseDate,
        remixOf: remixOf ?? this.remixOf,
        repostCount: repostCount ?? this.repostCount,
        favoriteCount: favoriteCount ?? this.favoriteCount,
        tags: tags ?? this.tags,
        title: title ?? this.title,
        user: user ?? this.user,
        duration: duration ?? this.duration,
        downloadable: downloadable ?? this.downloadable,
        playCount: playCount ?? this.playCount,
        permalink: permalink ?? this.permalink,
        isStreamable: isStreamable ?? this.isStreamable,
      );

  factory SongResponse.fromJson(Map<String, dynamic> json) => SongResponse(
        artwork:
            json["artwork"] == null ? null : Artwork.fromJson(json["artwork"]),
        description: json["description"],
        genre: json["genre"],
        id: json["id"],
        trackCid: json["track_cid"],
        previewCid: json["preview_cid"],
        mood: json["mood"],
        releaseDate: json["release_date"],
        remixOf: json["remix_of"] == null
            ? null
            : RemixOf.fromJson(json["remix_of"]),
        repostCount: json["repost_count"],
        favoriteCount: json["favorite_count"],
        tags: json["tags"],
        title: json["title"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        duration: json["duration"],
        downloadable: json["downloadable"],
        playCount: json["play_count"],
        permalink: json["permalink"],
        isStreamable: json["is_streamable"],
      );

  Map<String, dynamic> toJson() => {
        "artwork": artwork?.toJson(),
        "description": description,
        "genre": genre,
        "id": id,
        "track_cid": trackCid,
        "preview_cid": previewCid,
        "mood": mood,
        "release_date": releaseDate,
        "remix_of": remixOf?.toJson(),
        "repost_count": repostCount,
        "favorite_count": favoriteCount,
        "tags": tags,
        "title": title,
        "user": user?.toJson(),
        "duration": duration,
        "downloadable": downloadable,
        "play_count": playCount,
        "permalink": permalink,
        "is_streamable": isStreamable,
      };
}

class RemixOf {
  final dynamic tracks;

  RemixOf({
    this.tracks,
  });

  RemixOf copyWith({
    dynamic tracks,
  }) =>
      RemixOf(
        tracks: tracks ?? this.tracks,
      );

  factory RemixOf.fromJson(Map<String, dynamic> json) => RemixOf(
        tracks: json["tracks"],
      );

  Map<String, dynamic> toJson() => {
        "tracks": tracks,
      };
}

class User {
  final int? albumCount;
  final String? artistPickTrackId;
  final String? bio;
  final CoverPhoto? coverPhoto;
  final int? followeeCount;
  final int? followerCount;
  final bool? doesFollowCurrentUser;
  final String? handle;
  final String? id;
  final bool? isVerified;
  final String? location;
  final String? name;
  final int? playlistCount;
  final Artwork? profilePicture;
  final int? repostCount;
  final int? trackCount;
  final bool? isDeactivated;
  final bool? isAvailable;
  final String? ercWallet;
  final String? splWallet;
  final int? supporterCount;
  final int? supportingCount;
  final dynamic totalAudioBalance;

  User({
    this.albumCount,
    this.artistPickTrackId,
    this.bio,
    this.coverPhoto,
    this.followeeCount,
    this.followerCount,
    this.doesFollowCurrentUser,
    this.handle,
    this.id,
    this.isVerified,
    this.location,
    this.name,
    this.playlistCount,
    this.profilePicture,
    this.repostCount,
    this.trackCount,
    this.isDeactivated,
    this.isAvailable,
    this.ercWallet,
    this.splWallet,
    this.supporterCount,
    this.supportingCount,
    this.totalAudioBalance,
  });

  User copyWith({
    int? albumCount,
    String? artistPickTrackId,
    String? bio,
    CoverPhoto? coverPhoto,
    int? followeeCount,
    int? followerCount,
    bool? doesFollowCurrentUser,
    String? handle,
    String? id,
    bool? isVerified,
    String? location,
    String? name,
    int? playlistCount,
    Artwork? profilePicture,
    int? repostCount,
    int? trackCount,
    bool? isDeactivated,
    bool? isAvailable,
    String? ercWallet,
    String? splWallet,
    int? supporterCount,
    int? supportingCount,
    dynamic totalAudioBalance,
  }) =>
      User(
        albumCount: albumCount ?? this.albumCount,
        artistPickTrackId: artistPickTrackId ?? this.artistPickTrackId,
        bio: bio ?? this.bio,
        coverPhoto: coverPhoto ?? this.coverPhoto,
        followeeCount: followeeCount ?? this.followeeCount,
        followerCount: followerCount ?? this.followerCount,
        doesFollowCurrentUser:
            doesFollowCurrentUser ?? this.doesFollowCurrentUser,
        handle: handle ?? this.handle,
        id: id ?? this.id,
        isVerified: isVerified ?? this.isVerified,
        location: location ?? this.location,
        name: name ?? this.name,
        playlistCount: playlistCount ?? this.playlistCount,
        profilePicture: profilePicture ?? this.profilePicture,
        repostCount: repostCount ?? this.repostCount,
        trackCount: trackCount ?? this.trackCount,
        isDeactivated: isDeactivated ?? this.isDeactivated,
        isAvailable: isAvailable ?? this.isAvailable,
        ercWallet: ercWallet ?? this.ercWallet,
        splWallet: splWallet ?? this.splWallet,
        supporterCount: supporterCount ?? this.supporterCount,
        supportingCount: supportingCount ?? this.supportingCount,
        totalAudioBalance: totalAudioBalance ?? this.totalAudioBalance,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        albumCount: json["album_count"],
        artistPickTrackId: json["artist_pick_track_id"],
        bio: json["bio"],
        coverPhoto: json["cover_photo"] == null
            ? null
            : CoverPhoto.fromJson(json["cover_photo"]),
        followeeCount: json["followee_count"],
        followerCount: json["follower_count"],
        doesFollowCurrentUser: json["does_follow_current_user"],
        handle: json["handle"],
        id: json["id"],
        isVerified: json["is_verified"],
        location: json["location"],
        name: json["name"],
        playlistCount: json["playlist_count"],
        profilePicture: json["profile_picture"] == null
            ? null
            : Artwork.fromJson(json["profile_picture"]),
        repostCount: json["repost_count"],
        trackCount: json["track_count"],
        isDeactivated: json["is_deactivated"],
        isAvailable: json["is_available"],
        ercWallet: json["erc_wallet"],
        splWallet: json["spl_wallet"],
        supporterCount: json["supporter_count"],
        supportingCount: json["supporting_count"],
        totalAudioBalance: json["total_audio_balance"],
      );

  Map<String, dynamic> toJson() => {
        "album_count": albumCount,
        "artist_pick_track_id": artistPickTrackId,
        "bio": bio,
        "cover_photo": coverPhoto?.toJson(),
        "followee_count": followeeCount,
        "follower_count": followerCount,
        "does_follow_current_user": doesFollowCurrentUser,
        "handle": handle,
        "id": id,
        "is_verified": isVerified,
        "location": location,
        "name": name,
        "playlist_count": playlistCount,
        "profile_picture": profilePicture?.toJson(),
        "repost_count": repostCount,
        "track_count": trackCount,
        "is_deactivated": isDeactivated,
        "is_available": isAvailable,
        "erc_wallet": ercWallet,
        "spl_wallet": splWallet,
        "supporter_count": supporterCount,
        "supporting_count": supportingCount,
        "total_audio_balance": totalAudioBalance,
      };
}
