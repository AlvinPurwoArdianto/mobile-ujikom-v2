import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // Pastikan ImagePicker sudah diimpor
import 'dart:io'; // Untuk penggunaan File

class IndexView extends StatefulWidget {
  const IndexView({super.key});

  @override
  _IndexViewState createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> {
  File? _image; // Variabel untuk menyimpan gambar yang dipilih

  final ImagePicker _picker = ImagePicker(); // Controller untuk ImagePicker

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card Selamat Datang
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang, Nama Pegawai',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _infoRow(Icons.info, 'Status:', 'Aktif'),
                    _infoRow(Icons.work, 'Jabatan:', 'Software Engineer'),
                    _infoRow(
                        Icons.calendar_today, 'Tanggal Masuk:', '01-01-2023'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Absen
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Get.snackbar(
                      "Absen Masuk", "Anda telah absen masuk.",
                      snackPosition: SnackPosition.BOTTOM),
                  child: const Text("Absen Masuk"),
                ),
                ElevatedButton(
                  onPressed: () => Get.snackbar(
                      "Absen Pulang", "Anda telah absen pulang.",
                      snackPosition: SnackPosition.BOTTOM),
                  child: const Text("Absen Pulang"),
                ),
                ElevatedButton(
                  onPressed: _showUploadDialog,
                  child: const Text("Absen Sakit"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Kalender
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_left),
                            onPressed: () {},
                          ),
                          const Text(
                            'Kalender',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_right),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Kalender akan dirender di sini',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modal untuk mengunggah surat sakit
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

  // Row Info untuk Card
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 5),
          Text(value),
        ],
      ),
    );
  }
}
