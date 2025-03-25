import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_ujikom/app/modules/dashboard/views/index_view.dart';
import 'package:mobile_ujikom/app/modules/dashboard/views/laporan_view.dart';
import 'package:mobile_ujikom/app/modules/dashboard/views/profile_view.dart';
import 'package:mobile_ujikom/app/modules/dashboard/views/pengajuan_view.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    IndexView(),
    PengajuanView(),
    LaporanView(),
    ProfileView(),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
