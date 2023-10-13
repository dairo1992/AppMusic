class CoverPhoto {
  final String? the640X;
  final String? the2000X;

  CoverPhoto({
    this.the640X,
    this.the2000X,
  });

  CoverPhoto copyWith({
    String? the640X,
    String? the2000X,
  }) =>
      CoverPhoto(
        the640X: the640X ?? this.the640X,
        the2000X: the2000X ?? this.the2000X,
      );

  factory CoverPhoto.fromJson(Map<String, dynamic> json) => CoverPhoto(
        the640X: json["640x"],
        the2000X: json["2000x"],
      );

  Map<String, dynamic> toJson() => {
        "640x": the640X,
        "2000x": the2000X,
      };
}
