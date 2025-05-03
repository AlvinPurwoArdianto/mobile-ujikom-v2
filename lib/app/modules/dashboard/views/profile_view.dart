import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_ujikom/app/data/profile_response.dart';
import 'package:mobile_ujikom/app/modules/profile/controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pegawai'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.defaultDialog(
                title: "Konfirmasi Logout",
                middleText: "Apakah Anda yakin ingin keluar?",
                textCancel: "Batal",
                textConfirm: "Logout",
                confirmTextColor: Colors.white,
                onConfirm: () {
                  controller.logout();
                  Get.back();
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<ProfileResponse?>(
        future: controller.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.network(
                'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
                width: MediaQuery.of(context).size.width / 1.5,
              ),
            );
          }

          if (snapshot.hasError || snapshot.data == null || snapshot.data!.data == null) {
            return const Center(child: Text("Gagal memuat data profil"));
          }

          final data = snapshot.data!.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.person, size: 60, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data.namaPegawai ?? "Nama Tidak Tersedia",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(data.email ?? "Email tidak tersedia", style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // SECTION: Info Pribadi
                _buildSection("Informasi Pribadi", [
                  _buildDetailRow("Tempat, Tanggal Lahir", "${data.tempatLahir ?? "-"}, ${data.tanggalLahir ?? "-"}"),
                  _buildDetailRow("Jenis Kelamin", data.jenisKelamin ?? "-"),
                  _buildDetailRow("Tanggal Masuk", data.tanggalMasuk ?? "-"),
                ]),

                // SECTION: Alamat
                _buildSection("Alamat", [
                  _buildDetailRow("Alamat", data.alamat ?? "-"),
                  _buildDetailRow("Kelurahan", data.kelurahan ?? "-"),
                  _buildDetailRow("Kecamatan", data.kecamatan ?? "-"),
                  _buildDetailRow("Kabupaten", data.kabupaten ?? "-"),
                  _buildDetailRow("Provinsi", data.provinsi ?? "-"),
                ]),

                // SECTION: Info Pekerjaan
                _buildSection("Informasi Pekerjaan", [
                  _buildDetailRow("Status Pegawai", data.statusPegawai == 1 ? "Aktif" : "Tidak Aktif"),
                  _buildDetailRow("Gaji", "Rp ${data.gaji?.toStringAsFixed(0) ?? '-'}"),
                  _buildDetailRow("Admin", data.isAdmin == 1 ? "Ya" : "Tidak"),
                ]),

                // SECTION: Meta Data
                _buildSection("Informasi Sistem", [
                  _buildDetailRow("Akun Dibuat", data.createdAt ?? "-"),
                  _buildDetailRow("Update Terakhir", data.updatedAt ?? "-"),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text("$title:", style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
