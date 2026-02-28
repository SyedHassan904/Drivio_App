// ignore_for_file: use_build_context_synchronously

import 'package:file_manager/Providers/AuthProvider/auth_provider.dart';
import 'package:file_manager/Providers/FolderProvider/file_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatefulWidget {
  final String folderId;
  const UploadScreen({super.key, required this.folderId});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  PlatformFile? selectedFile;
  final TextEditingController titleController = TextEditingController();

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
        titleController.text = selectedFile!.name; // default title
      });
    }
  }

  void saveFile() async {
    if (selectedFile == null) return;

    bool success = await Provider.of<FileProvider>(context, listen: false)
        .uploadFile(
          file: selectedFile!,
          title: titleController.text,
          folderId: widget.folderId,
          token: Provider.of<AuthProvider>(context, listen: false).token!,
        );
    // print("Saved: ${titleController.text}");
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("File Saved!", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
    else{
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("SomeThing went wrong", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Files")),
      body: Consumer<FileProvider>(
        builder: (context, provider, child) {
          return provider.isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 40),
                            SizedBox(
                              height: 120,
                              child: Image.asset(
                                "assets/icons/upload_file.png",
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Upload Your Files",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: 6),
                            ElevatedButton(
                              onPressed: pickFile,
                              child: const Text("Pick File"),
                            ),

                            const SizedBox(height: 20),

                            if (selectedFile != null) ...[
                              Text(
                                "Selected: ${selectedFile!.name}",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),

                              const SizedBox(height: 20),

                              TextField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  labelText: "Change File Title",
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: saveFile,
                                child: const Text("Save File"),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
