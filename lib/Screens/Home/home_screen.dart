// ignore_for_file: use_build_context_synchronously

import 'package:file_manager/Providers/AuthProvider/auth_provider.dart';
import 'package:file_manager/models/category_model.dart';
import 'package:file_manager/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [
    Category(title: "Docs", image: "doc.png", color: 0x110073DD, type: "doc"),
    Category(title: "Images", image: "image.png", color: 0x110073DD,type: "image"),
    Category(title: "Videos", image: "video.png", color: 0x11DD0092,type:"video"),
    Category(title: "Music", image: "music.png", color: 0x11DD0092,type:"music"),
  ];
  int cur = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 40),
          // Greeting and Name=============================>
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18, top: 4),
                    child: Text("Good Morning", style: TextStyle(fontSize: 27)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      "${Provider.of<AuthProvider>(context, listen: false).name}👋",
                      style: TextStyle(fontSize: 27),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Logout"),
                              content: Text("Are you want to logout!"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("No"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Provider.of<AuthProvider>(
                                      context,
                                      listen: false,
                                    ).logout(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Good Bye!",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Color(0xFFFFA000),
                                      ),
                                    );
                                    await Future.delayed(Duration(seconds: 2));
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteHelper.login,
                                      (route) => false,
                                    );
                                  },
                                  child: Text("Yes"),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.logout, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10),
          // Storage Circle============================>
          Padding(
            padding: const EdgeInsets.all(17.0),
            child: SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        "200GB",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        "Free",
                        style: TextStyle(
                          color: Color(0xFF707070),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: CircularProgressIndicator(
                          value: 0.68,
                          strokeWidth: 18,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation(Color(0xFF7B61FF)),
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "68%",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7B61FF),
                            ),
                          ),
                          Text(
                            "used",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF707070),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "160GB",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          "Used",
                          style: TextStyle(
                            color: Color(0xFF707070),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Categories=================================>
          ListTile(
            leading: Text(
              "Categories",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0),
            child: SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((cat) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteHelper.categoryScreen,
                        arguments: {"title": cat.title, "type":cat.type},
                      );
                    },
                    child: categoreyItem(
                      title: cat.title,
                      image: cat.image,
                      color: cat.color,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget categoreyItem({
  required String image,
  required int color,
  required String title,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 13.0),
    child: Column(
      spacing: 5,
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Color(color),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset("assets/icons/$image"),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}
