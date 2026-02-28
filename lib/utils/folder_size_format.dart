class FolderSizeFormat {
  static String formatSize(int bytes) {
    if (bytes >= 1024 * 1024) {
      return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
    }
    if (bytes >= 1024) return "${(bytes / 1024).toStringAsFixed(2)} KB";
    return "$bytes B";
  }
}
