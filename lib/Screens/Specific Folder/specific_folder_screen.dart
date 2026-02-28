// ignore_for_file: use_build_context_synchronously

import 'package:file_manager/Providers/AuthProvider/auth_provider.dart';
import 'package:file_manager/Providers/FolderProvider/file_provider.dart';
import 'package:file_manager/Providers/FolderProvider/folder_provider.dart';
import 'package:file_manager/Screens/Specific%20Folder/widgets/file_card.dart';
import 'package:file_manager/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpecificFolderScreen extends StatefulWidget {
  final String title;
  final String folderId;
  const SpecificFolderScreen({
    super.key,
    required this.title,
    required this.folderId,
  });

  @override
  State<SpecificFolderScreen> createState() => _SpecificFolderScreenState();
}

class _SpecificFolderScreenState extends State<SpecificFolderScreen> {
  late Future<void> _filesFuture;
  @override
  void initState() {
    super.initState();
    final token = Provider.of<AuthProvider>(context, listen: false).token!;
    _filesFuture = Provider.of<FileProvider>(
      context,
      listen: false,
    ).getFilesByFolder(widget.folderId, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () async {
            await Provider.of<FolderProvider>(context,listen: false).showFolders(
              Provider.of<AuthProvider>(context, listen: false).token!,
            );
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
      ),
      body: Consumer<FileProvider>(
        builder: (context, provider, child) {
          return FutureBuilder(
            future: _filesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (provider.files.isEmpty) {
                return Center(
                  child: Text(
                    "Empty",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }

              return ListView(
                children: [
                  SizedBox(height: 30),
                  for (var file in provider.files) FileCard(file: file),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            RouteHelper.upload,
            arguments: {"folderId": widget.folderId},
          );
          final token = Provider.of<AuthProvider>(
            context,
            listen: false,
          ).token!;
          await Provider.of<FileProvider>(
            context,
            listen: false,
          ).getFilesByFolder(widget.folderId, token);
        },

        child: Icon(Icons.add),
      ),
    );
  }
}
