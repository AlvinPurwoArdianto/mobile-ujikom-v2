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
        title: const Text('Profile'),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<ProfileResponse?>(
            future: controller.getProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.network(
                    'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
                    repeat: true,
                    width: MediaQuery.of(context).size.width / 1.5,
                  ),
                );
              }

              if (snapshot.hasError || snapshot.data == null) {
                return const Center(
                  child: Text("Gagal memuat profil"),
                );
              }

              final data = snapshot.data!.data;
              if (data == null || data.email == null || data.email!.isEmpty) {
                return const Center(child: Text("Data profil tidak tersedia"));
              }

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 80,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.namaPegawai ?? "Nama Tidak Tersedia",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.email ?? "Email Tidak Tersedia",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Status Pegawai: ${data.statusPegawai == 1 ? "Aktif" : "Tidak Aktif"}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Bergabung Sejak: ${data.tanggalMasuk ?? "-"}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
