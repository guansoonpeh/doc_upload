import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:doc_upload/services/FileUploader .dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class UploadUi extends StatefulWidget {
  final String title;

  const UploadUi(this.title);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadUi> {
  File? _file;
  bool _isUploading = false;
  String? _uploadStatus;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() {
        _file = File(result.files.single.path!);
        _uploadStatus = null;
      });
    }
  }


  Future<void> _uploadFile() async {
    if (_file == null) return;
    var response  =  await FileUploader.uploadFile( file: _file!!, fName: 'myfile${path.extension(_file!.path)}', directory: "A") ;

    setState(() {
      _uploadStatus = response['message'];
    });
  }

 // @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload File')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Pick File'),
            ),

            const SizedBox(height: 10),

            if (_file != null) Text('Selected: ${path.basename(_file!.path)}'),

            const SizedBox(height: 10),

            if (_file != null && !_isUploading)
              ElevatedButton(
                onPressed: _uploadFile,
                child: const Text('Upload File'),
              ),

            if (_isUploading) const CircularProgressIndicator(),

            if (_uploadStatus != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(_uploadStatus!),
              ),
          ],
        ),
      ),
    );
  }
}
