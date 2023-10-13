class Artwork {
  final String? the150X150;
  final String? the480X480;
  final String? the1000X1000;

  Artwork({
    this.the150X150,
    this.the480X480,
    this.the1000X1000,
  });

  Artwork copyWith({
    String? the150X150,
    String? the480X480,
    String? the1000X1000,
  }) =>
      Artwork(
        the150X150: the150X150 ?? this.the150X150,
        the480X480: the480X480 ?? this.the480X480,
        the1000X1000: the1000X1000 ?? this.the1000X1000,
      );

  factory Artwork.fromJson(Map<String, dynamic> json) => Artwork(
        the150X150: json["150x150"],
        the480X480: json["480x480"],
        the1000X1000: json["1000x1000"],
      );

  Map<String, dynamic> toJson() => {
        "150x150": the150X150,
        "480x480": the480X480,
        "1000x1000": the1000X1000,
      };
}
