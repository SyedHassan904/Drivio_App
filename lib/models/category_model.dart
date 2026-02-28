enum FileType { image, doc, music, video }
class Category {
  final String title;
  final String image;
  final int color;
  final String type;

  Category({required this.type, required this.title, required this.image, required this.color});
}