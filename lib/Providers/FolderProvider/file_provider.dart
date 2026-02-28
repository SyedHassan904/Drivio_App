// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:file_manager/models/file_model.dart';
import 'package:file_manager/utils/server.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:media_scanner/media_scanner.dart';
import 'package:path/path.dart';


class FileProvider with ChangeNotifier {
  bool isLoading = false;
  Set<String> loadingFiles = {}; // store file ids currently loading

  bool isFileLoading(String fileId) => loadingFiles.contains(fileId);

  changeLoadingState(bool val) {
    isLoading = val;
    notifyListeners();
  }

  List<FileModel> files = [];

  getFilesByFolder(String folderId, String token) async {
    try {
      final response = await http.get(
        Uri.parse("${Server.serverUri}/folder/getFiles/$folderId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          // Update your local list
          files = (data['files'] as List)
              .map((fileJson) => FileModel.fromJson(fileJson))
              .toList();
          notifyListeners();
          return files;
        } else {
          print("Backend error: ${data['message']}");
        }
      } else {
        print("HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception fetching files: $e");
    } finally {
      changeLoadingState(false);
    }
  }

  Future<void> updateFileTitle(
    String fileId,
    String newTitle,
    String token,
  ) async {
    loadingFiles.add(fileId);
    notifyListeners();
    final response = await http.put(
      Uri.parse("${Server.serverUri}/folder/editFile/$fileId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"newTitle": newTitle}),
    );

    if (response.statusCode == 200) {
      final index = files.indexWhere((file) => file.id == fileId);
      if (index != -1) {
        files[index].title = newTitle;
        notifyListeners();
      }
    } else {
      throw Exception("Failed to update file title");
    }
    loadingFiles.remove(fileId);
    notifyListeners();
  }

  uploadFile({
    required PlatformFile file,
    required String title,
    required String folderId,
    required String token,
  }) async {
    changeLoadingState(true);
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${Server.serverUri}/folder/upload"),
      );

      // Headers
      request.headers['Authorization'] = "Bearer $token";

      // Text fields
      request.fields['title'] = title;
      request.fields['folderId'] = folderId;

      // File
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path!,
          filename: basename(file.path!),
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print(responseData);

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Upload error: $responseData");
        return false;
      }
    } catch (e) {
      print("Upload exception: $e");
      return false;
    } finally {
      changeLoadingState(false);
    }
  }

  downloadFile(String fileName, String fileUrl) async {
    final response = await http.get(Uri.parse(fileUrl));
    if (response.statusCode == 200) {
      final directory = Directory('/storage/emulated/0/Download');
      final filePath = "${directory.path}/$fileName";
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      await MediaScanner.loadMedia(path: filePath);
      print("Downloaded at: $filePath");
      return true;
    } else {
      print("Download failed");
      return false;
    }
  }

  deleteFile(String fileId, String token, String folderId) async {
    loadingFiles.add(fileId);
    notifyListeners();
    final response = await http.delete(
      Uri.parse("${Server.serverUri}/folder/deleteFile/$fileId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      getFilesByFolder(folderId, token);
      loadingFiles.remove(fileId);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }


   void clearFiles() {
    files = [];
    notifyListeners();
  }

 Future<void> fetchFilesByType(String type, String token) async {
  try {
    final url = Uri.parse("${Server.serverUri}/folder/files/$type");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token", // send token in header
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      files = data.map((json) => FileModel.fromJson(json)).toList();
      notifyListeners();
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized: Invalid or expired token");
    } else {
      throw Exception("Failed to fetch files: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching files: $e");
  }
}
}
