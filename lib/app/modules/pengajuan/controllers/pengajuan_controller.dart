import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class PengajuanController extends GetxController {
  // Observable count untuk contoh
  final count = 0.obs;
  final GetStorage _storage = GetStorage();

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

  // Fungsi untuk login
  Future<String?> login(String email, String password) async {
    final String baseUrl = 'http://127.0.0.1:8000/api';

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _storage.write('auth_token', data['token']); // Menyimpan token
        return null; // Berhasil login
      } else {
        return 'Login failed'; // Jika gagal login
      }
    } catch (e) {
      return 'Connection error: $e';
    }
  }

  // Helper function untuk mengkonversi kategori
  String mapCategoryToApi(String uiCategory) {
    switch (uiCategory) {
      case 'Tahunan':
        return 'liburan';
      case 'Acara Keluarga':
        return 'acara_keluarga';
      case 'Hamil':
        return 'hamil';
      default:
        return uiCategory.toLowerCase();
    }
  }

  // Fungsi untuk mengajukan cuti
  Future<Map<String, dynamic>> submitLeaveRequest(DateTime startDate,
      DateTime endDate, String category, String reason) async {
    final String? token = _storage.read('auth_token');

    if (token == null) {
      return {'success': false, 'message': 'User not authenticated'};
    }

    // Format tanggal sesuai yang diharapkan API
    final dateFormat = DateFormat('yyyy-MM-dd');

    // Convert kategori
    String apiCategory = mapCategoryToApi(category);

    final String baseUrl = 'http://127.0.0.1:8000/api';

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cuti'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'tanggal_cuti': dateFormat.format(startDate),
          'tanggal_selesai': dateFormat.format(endDate),
          'kategori_cuti': apiCategory,
          'alasan': reason,
        }),
      );

      // Parse response
      Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Cuti berhasil diajukan',
          'data': responseData['data']
        };
      } else {
        // Parse validation errors if present
        if (responseData['errors'] != null && responseData['errors'] is Map) {
          String firstError = responseData['errors'].values.first[0];
          return {'success': false, 'message': firstError};
        }

        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to submit leave request'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  void increment() => count.value++;
}
