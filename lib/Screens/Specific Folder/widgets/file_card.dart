// ignore_for_file: use_build_context_synchronously

import 'package:file_manager/Providers/AuthProvider/auth_provider.dart';
import 'package:file_manager/Providers/FolderProvider/file_provider.dart';
import 'package:file_manager/models/file_model.dart';
import 'package:file_manager/utils/date_function.dart';
import 'package:file_manager/utils/show_specific_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FileCard extends StatefulWidget {
  final FileModel file;
  const FileCard({super.key, required this.file});

  @override
  State<FileCard> createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  late TextEditingController editTitle;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    editTitle = TextEditingController(text: widget.file.title);
  }

  void saveTitle() async {
    String token = Provider.of<AuthProvider>(context, listen: false).token!;
    await Provider.of<FileProvider>(
      context,
      listen: false,
    ).updateFileTitle(widget.file.id, editTitle.text, token);
    setState(() {
      isEdit = false;
    });
  }

  void downloadFilde() async {
    bool success = await Provider.of<FileProvider>(
      context,
      listen: false,
    ).downloadFile(widget.file.title, widget.file.fileUrl);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Download Successful",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void deleteFile() async {
    String token = Provider.of<AuthProvider>(context, listen: false).token!;
    bool success = await Provider.of<FileProvider>(
      context,
      listen: false,
    ).deleteFile(widget.file.id, token, widget.file.folderId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("File Deleted", style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.amberAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<FileProvider>(
          context,
          listen: false,
        ).isFileLoading(widget.file.id)
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
            child: SizedBox(
              height: isEdit ? 120 : 70,
              width: double.infinity,
              child: Card(
                child: Row(
                  spacing: 6,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Color(0x110073DD),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(getFileType(widget.file.type)),
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isEdit
                              ? TextField(
                                  controller: editTitle,
                                  autofocus: true,
                                  onSubmitted: (_) => saveTitle(),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                )
                              : Text(
                                  widget.file.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          Text(
                            formatDateTime(widget.file.createdAt),
                            style: TextStyle(color: Color(0xFF707070)),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PopupMenuButton(
                          onSelected: (value) {
                            if (value == "edit") {
                              setState(() {
                                isEdit = true;
                              });
                            }
                            if (value == "download") {
                              downloadFilde();
                            }
                            if (value == "delete") {
                              deleteFile();
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(value: "edit",child: Text("Edit"),),
                            PopupMenuItem(
                              value: "download",
                              child: Text("download"),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              child: Text("delete"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
