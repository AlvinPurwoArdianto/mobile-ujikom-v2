import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LaporanView extends StatelessWidget {
  const LaporanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Cuti'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Judul
            const Text(
              'Daftar Laporan Cuti',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // ListView untuk menampilkan daftar laporan cuti
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Bisa disesuaikan dengan jumlah laporan cuti
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text('Cuti ${index + 1}'),
                      subtitle: Text(
                          'Status: ${index % 2 == 0 ? "Disetujui" : "Menunggu"}'),
                      leading:
                          const Icon(Icons.calendar_today, color: Colors.blue),
                      onTap: () {
                        // Ketika laporan diklik, pindah ke halaman detail laporan cuti
                        _showLaporanCutiDetail(context, index + 1);
                      },
                    ),
                  );
                },
              ),
            ),

            // Tombol untuk menambahkan laporan cuti baru
            ElevatedButton(
              onPressed: () {
                _showTambahLaporanCutiDialog(context);
              },
              child: const Text("Tambah Laporan Cuti Baru"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan detail laporan cuti
  void _showLaporanCutiDetail(BuildContext context, int cutiId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detail Laporan Cuti $cutiId'),
          content: const Text('Ini adalah detail laporan cuti yang dipilih.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog tambah laporan cuti
  void _showTambahLaporanCutiDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Laporan Cuti Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Masukkan alasan cuti...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Masukkan tanggal cuti (misal: 01/01/2023)',
                ),
                keyboardType: TextInputType.datetime,
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
                // Logic untuk menambahkan laporan cuti baru
                Get.snackbar("Laporan Cuti Ditambahkan",
                    "Laporan cuti baru berhasil ditambahkan.",
                    snackPosition: SnackPosition.BOTTOM);
                Navigator.pop(context); // Menutup dialog
              },
              child: const Text("Tambah"),
            ),
          ],
        );
      },
    );
  }
}
