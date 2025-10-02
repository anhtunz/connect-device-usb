class ImageConstants {
  ImageConstants._init();
  static ImageConstants? _instance;
  static ImageConstants get instance => _instance ??= ImageConstants._init();

  String get logo => getImage("");

  String getImage(String name) => "assets/images/$name.png";
}
