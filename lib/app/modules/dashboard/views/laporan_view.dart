import 'package:flutter/material.dart';

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
}
