// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:file_manager/utils/server.dart';
import 'package:file_manager/models/folder_model.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FolderProvider with ChangeNotifier {
  List<FolderModel> folders = [];
  bool isLoading = false;

  changeLoadingState(bool val) {
    isLoading = val;
    notifyListeners();
  }

  showFolders(String token) async {
    changeLoadingState(true);
    folders.clear();
    try {
      final response = await http.get(
        Uri.parse("${Server.serverUri}/folder/getFolders"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      // print("${response.body}=================================>");
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        for (var folder in result['folders']) {
          final fol = FolderModel.toMap(folder);
          folders.add(fol);
        }
      }

      notifyListeners();
    } catch (e) {
      return false;
    } finally {
      changeLoadingState(false);
    }
  }

  deleteFolder(String folderID, String token) async {
    changeLoadingState(true);
    try {
      final response = await http.delete(
        Uri.parse("${Server.serverUri}/folder/deleteFolder/$folderID"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // print("${response.body}================================>");

      if (response.statusCode == 200) {
        await showFolders(token);
        notifyListeners();
        return true;
      }
    } catch (e) {
      return false;
    } finally {
      changeLoadingState(false);
    }
  }

  updateTitle(String id, String newTitle, String token) async {
    final response = await http.put(
      Uri.parse("${Server.serverUri}/folder/updateFolderTitle/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"title": newTitle}),
    );
    // print("${response.body}===============================>");
    if (response.statusCode == 200) {
      showFolders(token);
      notifyListeners();
    }
  }

  Future<void> addFolder(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    try {
      final response = await http.post(
        Uri.parse('${Server.serverUri}/folder/addFolder'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: '{"title": "$title"}',
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final result = jsonDecode(response.body);

        // Add folder to local list using backend _id
        final folderData = result['folder'];
        folders.add(
          FolderModel(
            id: folderData['_id'] as String, // backend ID
            title: folderData['title'],
            items: folderData['items'] ?? 0 ,
            size: folderData['size'] ?? 0,
            isEdit: true,
          ),
        );

        notifyListeners();
      } else {
        print("Error adding folder: ${response.body}");
        print("Error adding folder: $token");
      }
    } catch (e) {
      print("Exception adding folder: $e");
    }
  }

  void setFolderEdit(String id, bool value) {
    final folder = folders.firstWhere((f) => f.id == id);
    folder.isEdit = value;
    notifyListeners();
  }


   void clearFolders() {
    folders = [];
    notifyListeners();
  }
}
