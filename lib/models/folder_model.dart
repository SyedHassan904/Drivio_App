class FolderModel {
  String title;
  int items;
  int size;
  String id;
  bool isEdit;

  FolderModel({
    required this.id,
    required this.title,
    this.items = 0,
    this.size = 0,
    this.isEdit = false,
  });

  factory FolderModel.toMap(Map map) {
    return FolderModel(
      id: map['_id'],
      title: map['title'],
      items: map['items'],
      size: map['size'],
      isEdit: map['isEdit'],
    );
  }
}
