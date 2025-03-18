import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pengajuan_controller.dart';

class PengajuanView extends GetView<PengajuanController> {
  const PengajuanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PengajuanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PengajuanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
