import 'package:file_manager/Screens/Auth/login_screen.dart';
import 'package:file_manager/Screens/Auth/register_screen.dart';
import 'package:file_manager/Screens/Specific%20Folder/specific_folder_screen.dart';
import 'package:file_manager/Screens/Splash/splash_screen.dart';
import 'package:file_manager/Screens/Upload/upload_screen.dart';
import 'package:file_manager/Screens/categoryScreen/category_screen.dart';
import 'package:file_manager/Screens/main_screen.dart';
import 'package:flutter/material.dart';

class RouteHelper {
  static String splash = '/';
  static String login = '/login';
  static const String folder = '/folder';
  static const String upload = '/upload';
  static const String categoryScreen = '/category';
  static String home = '/home';
  static String register = '/register';

  static routes() {
    return {
      login: (_) => LoginPage(),
      splash: (_) => SplashScreen(),
      home: (_) => MainScreen(),
      register: (_) => RegisterScreen(),
    };
  }

  static myGenRoutes(RouteSettings settings) {
    switch (settings.name) {
      case folder:
        {
          return MaterialPageRoute(
            builder: (_) {
              final argList = settings.arguments as Map<String, dynamic>;
              return SpecificFolderScreen(
                title: argList['title'],
                folderId: argList['folderId'],
              );
            },
          );
        }
      case upload:
        {
          return MaterialPageRoute(
            builder: (_) {
              final argList = settings.arguments as Map<String, dynamic>;
              return UploadScreen(folderId: argList['folderId']);
            },
          );
        }
      case categoryScreen:
        {
          return MaterialPageRoute(
            builder: (_) {
              final argList = settings.arguments as Map<String, dynamic>;
              return CategoryScreen(title: argList['title'],type: argList['type'],);
            },
          );
        }
    }
  }
}
