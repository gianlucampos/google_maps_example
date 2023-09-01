class CustomPlaceholder {
  String? name;
  String? adress;
  String? imageLink;
  String? imagePath;
  double? latitude;
  double? longitude;

  CustomPlaceholder({
    this.name,
    this.adress,
    this.imageLink,
    this.imagePath,
    this.latitude,
    this.longitude,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomPlaceholder &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() {
    return 'CustomPlaceholder{name: $name, latitude: $latitude, longitude: $longitude}';
  }
}
