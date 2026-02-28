// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'dart:convert';

import 'package:file_manager/Providers/FolderProvider/file_provider.dart';
import 'package:file_manager/Providers/FolderProvider/folder_provider.dart';
import 'package:file_manager/models/user_model.dart';
import 'package:file_manager/utils/server.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool isLogin = false;
  bool loading = false;
  bool visibiltyPassword = true;
  String? token;
  String? name = '';

  changeLoadingState(bool val) {
    loading = val;
    notifyListeners();
  }

  Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    changeLoadingState(true);
    try {
      final response = await http.post(
        Uri.parse("${Server.serverUri}/user/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        //Save token in both AuthProvider and SharedPreferences
        token = result['token']; //update token here
        name = result['user']['name'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token!);
        await prefs.setString("name", name!);

        // Update AuthProvider state
        isLogin = true;
        notifyListeners();

        //Clear old data
        // ignore: use_build_context_synchronously
        Provider.of<FolderProvider>(context, listen: false).clearFolders();
        Provider.of<FileProvider>(context, listen: false).clearFiles();

        //Fetch new user's folders
        await Provider.of<FolderProvider>(
          context,
          listen: false,
        ).showFolders(token!); // now token is valid

        return true;
      } else {
        return false;
      }
    } catch (e) {
      // print("Login error: $e");
      return false;
    } finally {
      changeLoadingState(false);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    changeLoadingState(true);
    try {
      final response = await http.post(
        Uri.parse("${Server.serverUri}/user/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );
      // print("Status: ${response.statusCode}==========================>");
      // print("Response body: ${response.body}=========================>");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      changeLoadingState(false);
    }
  }

  fethPrefernces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    name =  prefs.getString("name");
    if (token != null) {
      isLogin = true;
    } else {
      isLogin = false;
    }
    notifyListeners();
  }

  logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('name');
    Provider.of<FileProvider>(context, listen: false).clearFiles();
    Provider.of<FolderProvider>(context, listen: false).clearFolders();
    name = '';
    token = null;
    isLogin = false;
    notifyListeners();
  }

  showHidePassword() {
    visibiltyPassword = !visibiltyPassword;
    notifyListeners();
  }

  Future<UserModel?> getUserData(String token) async {
  try {
    final response = await http.get(
      Uri.parse("${Server.serverUri}/user/me"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['success'] == true) {
        // Option 1: return a map
        // return data['user'];

        // Option 2: return a UserModel instance
        return UserModel.fromJson(data['user']);
      }
    } else {
      // ignore: avoid_print
      print("Error fetching user data: ${response.statusCode}");
    }
  } catch (e) {
    // ignore: avoid_print
    print("Exception in getUserData: $e");
  }
  return null;
}
}
