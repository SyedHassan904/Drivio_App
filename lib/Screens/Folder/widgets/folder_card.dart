import 'package:file_manager/Providers/AuthProvider/auth_provider.dart';
import 'package:file_manager/Providers/FolderProvider/folder_provider.dart';
import 'package:file_manager/utils/folder_size_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderCard extends StatefulWidget {
  final String title;
  final int items;
  final int size;
  final String id;
  final bool isEdit;
  const FolderCard({
    super.key,
    required this.title,
    required this.items,
    required this.size,
    required this.id,
    required this.isEdit,
  });

  @override
  State<FolderCard> createState() => _FolderCardState();
}

class _FolderCardState extends State<FolderCard> {
  late TextEditingController editTitleController;
  late bool isEdit;

  @override
  void initState() {
    super.initState();
    editTitleController = TextEditingController(text: widget.title);
    isEdit = widget.isEdit;
  }

  void saveTitle() {
    final provider = Provider.of<FolderProvider>(context, listen: false);
    provider.updateTitle(
      widget.id,
      editTitleController.text,
      Provider.of<AuthProvider>(context, listen: false).token!,
    );
    provider.setFolderEdit(widget.id, false);
    setState(() {
      isEdit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 5),
      child: SizedBox(
        height: isEdit ? 120 : 70,
        width: double.infinity,
        child: Card(
          child: Row(
            spacing: 8,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 60,
                  child: Image.asset("assets/images/folder2.png"),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isEdit
                        ? TextField(
                            controller: editTitleController,
                            autofocus: true,
                            onSubmitted: (_) => saveTitle(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          )
                        : Text(
                            widget.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                    Text(
                      "${widget.items} items| ${FolderSizeFormat.formatSize(widget.size)}",
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
                      if (value == "delete") {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Delete Folder"),
                            content: Text("Are you sure to delete this Folder"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("No"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Provider.of<FolderProvider>(
                                    context,
                                    listen: false,
                                  ).deleteFolder(
                                    widget.id,
                                    Provider.of<AuthProvider>(
                                      context,
                                      listen: false,
                                    ).token!,
                                  );
                                  Navigator.pop(context);
                                },
                                child: Text("yes"),
                              ),
                            ],
                          ),
                        );
                      }
                      if (value == "edit") {
                        setState(() {
                          isEdit = true;
                        });
                      }
                    },
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(value: "edit", child: Text("Edit")),
                      PopupMenuItem(value: "delete", child: Text("Delete")),
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
