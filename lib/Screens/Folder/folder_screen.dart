import 'package:file_manager/Providers/AuthProvider/auth_provider.dart';
import 'package:file_manager/Providers/FolderProvider/folder_provider.dart';
import 'package:file_manager/Screens/Folder/widgets/folder_card.dart';
import 'package:file_manager/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? token = Provider.of<AuthProvider>(context, listen: false).token;
      Provider.of<FolderProvider>(context, listen: false).showFolders(token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "My Folders",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Consumer<FolderProvider>(
        builder: (context, provider, child) {
          return provider.isLoading
              ? Center(child: CircularProgressIndicator())
              : provider.folders.isEmpty
              ? Center(child: Text("No folders available"))
              : ListView(
                  children: [
                    SizedBox(height: 30),
                    for (var folder in provider.folders)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteHelper.folder,
                            arguments: {
                              "title": folder.title,
                              "folderId": folder.id,
                            },
                          );
                        },
                        child: FolderCard(
                          title: folder.title,
                          items: folder.items,
                          size: folder.size,
                          id: folder.id,
                          isEdit: folder.isEdit,
                        ),
                      ),
                  ],
                );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<FolderProvider>(
            context,
            listen: false,
          ).addFolder("New Folder");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
