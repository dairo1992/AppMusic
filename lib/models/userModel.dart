import 'package:e_music/models/artworkModel.dart';
import 'package:e_music/models/models.dart';

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
  final int? totalAudioBalance;

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
    int? totalAudioBalance,
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
