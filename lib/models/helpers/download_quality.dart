enum SongQualityType {
  veryLow('12kbps'),
  low('48kbps'),
  medium('96kbps'),
  high('160kbps'),
  veryHigh('320kbps');

  final String type;
  const SongQualityType(this.type);
}

extension ConvertQuality on String {
  SongQualityType toSongQualityTypeEnum() {
    switch (this) {
      case '12kbps':
        return SongQualityType.veryLow;
      case '48kbps':
        return SongQualityType.low;
      case '96kbps':
        return SongQualityType.medium;
      case '160kbps':
        return SongQualityType.high;
      case '320kbps':
        return SongQualityType.veryHigh;
      default:
        return SongQualityType.medium;
    }
  }
}
