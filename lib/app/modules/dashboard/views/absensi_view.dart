import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AbsensiView extends StatefulWidget {
  const AbsensiView({super.key});

  @override
  State<AbsensiView> createState() => _AbsensiViewState();
}

class _AbsensiViewState extends State<AbsensiView> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Upload Bukti Sakit"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _image != null
                  ? Image.file(_image!, height: 100)
                  : const Text("Pilih gambar untuk diunggah"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text("Pilih Gambar"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_image != null) {
                  Get.snackbar("Berhasil", "Bukti sakit telah diunggah.",
                      snackPosition: SnackPosition.BOTTOM);
                  Navigator.pop(context);
                }
              },
              child: const Text("Upload"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.snackbar(
                  "Absen Masuk", "Anda telah absen masuk.",
                  snackPosition: SnackPosition.BOTTOM),
              child: const Text("Absen Masuk"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Get.snackbar(
                  "Absen Pulang", "Anda telah absen pulang.",
                  snackPosition: SnackPosition.BOTTOM),
              child: const Text("Absen Pulang"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showUploadDialog,
              child: const Text("Absen Sakit"),
            ),
          ],
        ),
      ),
    );
  }
}
