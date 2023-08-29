class CustomPlaceholder {
  String name;
  String adress;
  String? imageLink;
  String? imagePath;
  double latitude;
  double longitude;

  CustomPlaceholder({
    required this.name,
    required this.adress,
    this.imageLink,
    this.imagePath,
    required this.latitude,
    required this.longitude,
  });
}
