import 'package:file_manager/models/file_model.dart';

String getFileType(FileType type) {
  switch (type) {
    case FileType.doc:
      {
        return 'assets/icons/doc.png';
      }
    case FileType.image:
      {
        return 'assets/icons/image.png';
      }
    case FileType.music:
      {
        return 'assets/icons/music.png';
      }
    case FileType.video:
      {
        return 'assets/icons/video.png';
      }
  }
}
