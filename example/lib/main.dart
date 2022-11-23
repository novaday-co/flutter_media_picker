import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Media Picker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedImagePath;

  void _showMediaPickerModal() async {
    selectedImagePath = await MediaPicker.showMediaPickerModal(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(selectedImagePath != null) SizedBox(
              height: 200,
              width: 200,
              child: Image.file(File(selectedImagePath!),),
            ),
            TextButton(
              onPressed: _showMediaPickerModal,
              child: const Text("show media picker modal"),
            ),
          ],
        ),
      ),
    );
  }
}
