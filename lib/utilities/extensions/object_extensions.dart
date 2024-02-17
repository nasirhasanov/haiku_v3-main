extension ObjectExtensions on Object?{
  String? get valueOrNull => (this == null) ? null : '$this';
}