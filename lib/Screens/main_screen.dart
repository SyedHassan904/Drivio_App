import 'package:file_manager/Screens/Folder/folder_screen.dart';
import 'package:file_manager/Screens/Home/home_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> screens = [HomeScreen(), FolderScreen()];
  int cur = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[cur],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            cur = value;
          });
        },
        currentIndex: cur,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/HomeIcon.png",
              color: cur == 0 ? Color(0xFF7747FD) : null,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 30,
              width: 30,
              child: Image.asset(
                "assets/icons/folder.png",
                color: cur == 1 ? Color(0xFF7747FD) : null,
              ),
            ),
            label: "",
          ),
        ],
      ),
    );
  }
}
