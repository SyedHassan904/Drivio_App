enum FileType { image, doc, music, video }

class FileModel {
  String title, id;
  DateTime createdAt;
  FileType type;
  String folderId;
  String userId;
  String fileUrl;
  int size;

  FileModel({
    required this.folderId,
    required this.id,
    required this.title,
    required this.createdAt,
    required this.type,
    required this.fileUrl,
    required this.userId,
    required this.size
  });

  factory FileModel.fromJson(Map<String, dynamic> file) {
    return FileModel(
      folderId: file['folderId'],
      userId: file['userId'],
      id: file['_id'],
      title: file['title'],
      size: file['size'],
      fileUrl: file['fileUrl'],
      createdAt: DateTime.parse(file['createdAt']),
      type: FileType.values.firstWhere((e) => e.name == file['type']),
    );
  }
}
