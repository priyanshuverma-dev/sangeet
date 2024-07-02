enum MediaType {
  artist,
  playlist,
  song,
  album,
  radio;

  const MediaType();

  static MediaType fromString(String type) {
    switch (type) {
      case "song":
        return MediaType.song;

      case "album":
        return MediaType.album;

      case "playlist":
        return MediaType.playlist;

      case "featured_radio":
        return MediaType.radio;
      default:
        return MediaType.song;
    }
  }
}
