import 'dart:convert'; // For JSON conversion
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
// import 'package:mobile_ujikom/app/data/profile_response.dart';


class IndexView extends StatefulWidget {
  const IndexView({super.key});

  @override
  _IndexViewState createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> {
  DateTime _currentDate = DateTime.now();
  String _namaPegawai = ''; // Variabel untuk menyimpan nama pegawai
  String? _userId; // Untuk menyimpan ID user
  File? _imageFile; // Untuk menyimpan file gambar
  String _absensiId = ''; // Untuk menyimpan ID absensi hari ini
  bool _hasAbsenMasuk = false; // Untuk melacak status absen masuk
  bool _hasAbsenPulang = false; // Untuk melacak status absen pulang
  List<Map<String, dynamic>> _absensiList =
      []; // List untuk menyimpan data absensi

  // Menentukan jumlah hari dalam bulan
  int get _daysInMonth {
    return DateTime(_currentDate.year, _currentDate.month + 1, 0).day;
  }

  // Menentukan hari pertama dalam bulan (0 = Minggu, 1 = Senin, dst)
  int get _firstDayIndex {
    // Dalam sistem Indonesia, minggu adalah hari pertama (indeks 0)
    return DateTime(_currentDate.year, _currentDate.month, 1).weekday % 7;
  }

  // Nama bulan
  List<String> _monthNames = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember"
  ];

  // Status absensi untuk tanggal di kalender
  Map<String, String> _absensiData = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Memanggil fungsi untuk mengambil data user
    _checkTodayAbsensi(); // Cek status absensi hari ini
  }

  Future<void> _fetchUserData() async {
    final String? token = GetStorage().read('auth_token');

    if (token == null) {
      Get.snackbar("Error", "User not authenticated",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final url = 'http://127.0.0.1:8000/api/profile';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _namaPegawai = data['name'] ?? 'Nama tidak ditemukan';
          _userId = data['id']?.toString();
        });
        _fetchMonthlyAbsensi();
        _fetchAbsensiList();
      } else {
        setState(() {
          _namaPegawai = 'Pegawai';
        });
      }
    } catch (error) {
      setState(() {
        _namaPegawai = 'Pegawai';
      });
    }
  }


  // Fungsi untuk mengambil data absensi bulan ini
  Future<void> _fetchMonthlyAbsensi() async {
    if (_userId == null) return;

    final url =
        'http://127.0.0.1:8000/api/absensi/monthly/${_currentDate.year}/${_currentDate.month}/${_userId}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Map<String, String> absensiMap = {};

        for (var item in data['absensi']) {
          String tanggal = item['tanggal_absen'];
          String status = item['status'];
          absensiMap[tanggal] = status;
        }

        setState(() {
          _absensiData = absensiMap;
        });
      }
    } catch (error) {
      print('Error mengambil data absensi: $error');
    }
  }

  // Fungsi untuk mengambil daftar absensi (seperti tabel di Laravel)
  Future<void> _fetchAbsensiList() async {
    if (_userId == null) return;

    final url = 'http://127.0.0.1:8000/api/absensi/list/${_userId}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _absensiList = List<Map<String, dynamic>>.from(data['absensi']);
        });
      }
    } catch (error) {
      print('Error mengambil daftar absensi: $error');
    }
  }

  // Cek status absensi hari ini
  Future<void> _checkTodayAbsensi() async {
    if (_userId == null) return;

    final today = DateTime.now().toString().split(' ')[0]; // Format: YYYY-MM-DD
    final url = 'http://127.0.0.1:8000/api/absensi/check/$today/${_userId}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['exists']) {
          setState(() {
            _absensiId = data['absensi']['id'].toString();
            _hasAbsenMasuk = true;
            _hasAbsenPulang = data['absensi']['jam_keluar'] != null;
          });
        }
      }
    } catch (error) {
      print('Error mengecek absensi: $error');
    }
  }

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Dialog untuk absen sakit
  void _showSakitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Upload Surat Izin Sakit"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _imageFile != null
                  ? Image.file(_imageFile!, height: 100)
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
                if (_imageFile != null) {
                  _absenSakit();
                  Navigator.pop(context);
                } else {
                  Get.snackbar("Peringatan", "Pilih gambar terlebih dahulu",
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
              child: const Text("Kirim"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk Absen Masuk
  Future<void> _absenMasuk() async {
    if (_userId == null) {
      Get.snackbar("Error", "ID User tidak ditemukan",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Jika sudah absen masuk, tampilkan pesan
    if (_hasAbsenMasuk) {
      Get.snackbar("Informasi", "Anda sudah melakukan absen masuk hari ini",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final url = 'http://127.0.0.1:8000/api/absensi';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_user': _userId,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        setState(() {
          _absensiId = data['absensi']['id'].toString();
          _hasAbsenMasuk = true;
        });

        Get.snackbar("Berhasil", data['success'] ?? "Berhasil Absen Masuk",
            snackPosition: SnackPosition.BOTTOM);

        // Refresh data absensi
        _fetchMonthlyAbsensi();
        _fetchAbsensiList();
        _checkTodayAbsensi();
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar("Gagal", data['error'] ?? "Gagal Absen Masuk",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Fungsi untuk Absen Pulang
  Future<void> _absenPulang() async {
    if (_absensiId.isEmpty || !_hasAbsenMasuk) {
      Get.snackbar("Error", "Anda belum absen masuk hari ini",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (_hasAbsenPulang) {
      Get.snackbar("Informasi", "Anda sudah melakukan absen pulang hari ini",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final url = 'http://127.0.0.1:8000/api/absensi/${_absensiId}';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _hasAbsenPulang = true;
        });

        Get.snackbar("Berhasil", data['success'] ?? "Berhasil Absen Pulang",
            snackPosition: SnackPosition.BOTTOM);

        // Refresh data absensi
        _fetchMonthlyAbsensi();
        _fetchAbsensiList();
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar("Gagal", data['error'] ?? "Gagal Absen Pulang",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Fungsi untuk Absen Sakit
  Future<void> _absenSakit() async {
    if (_userId == null) {
      Get.snackbar("Error", "ID User tidak ditemukan",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (_imageFile == null) {
      Get.snackbar("Error", "Bukti sakit diperlukan",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final url = 'http://127.0.0.1:8000/api/absensi/sakit';

    try {
      // Membuat request multipart untuk upload gambar
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer YOUR_ACCESS_TOKEN';

      // Menambahkan user ID
      request.fields['id_user'] = _userId!;

      // Menambahkan file gambar
      request.files.add(await http.MultipartFile.fromPath(
        'photo',
        _imageFile!.path,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        Get.snackbar("Berhasil", data['success'] ?? "Berhasil Absen Sakit",
            snackPosition: SnackPosition.BOTTOM);

        // Reset image file
        setState(() {
          _imageFile = null;
          _hasAbsenMasuk = true; // Karena absen sakit dianggap sudah absen
          _hasAbsenPulang = true; // Absen sakit otomatis selesai
        });

        // Refresh data absensi
        _fetchMonthlyAbsensi();
        _fetchAbsensiList();
        _checkTodayAbsensi();
      } else {
        Get.snackbar("Gagal", data['error'] ?? "Gagal Absen Sakit",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e",
          snackPosition: SnackPosition.BOTTOM);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        'Selamat Datang, ${_namaPegawai}',
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

              // Card Tombol Absensi (seperti di Laravel)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Absensi Hari Ini',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Tombol Absen Masuk
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _hasAbsenMasuk ? null : _absenMasuk,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                _hasAbsenMasuk
                                    ? 'Sudah Absen Masuk'
                                    : 'Absen Masuk',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          // Tombol Absen Pulang
                          Expanded(
                            child: ElevatedButton(
                              onPressed: (_hasAbsenMasuk && !_hasAbsenPulang)
                                  ? _absenPulang
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                _hasAbsenPulang
                                    ? 'Sudah Absen Pulang'
                                    : (!_hasAbsenMasuk
                                        ? 'Belum Absen Masuk'
                                        : 'Absen Pulang'),
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Tombol Absen Sakit
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (_hasAbsenMasuk || _hasAbsenPulang)
                              ? null
                              : _showSakitDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            (_hasAbsenMasuk || _hasAbsenPulang)
                                ? 'Sudah Absen Hari Ini'
                                : 'Absen Sakit',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Kalender (seperti sebelumnya)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Column(
                  children: [
                    // Judul kalender dengan navigasi
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_left),
                            onPressed: () {
                              setState(() {
                                _currentDate = DateTime(
                                  _currentDate.year,
                                  _currentDate.month - 1,
                                  1,
                                );
                                // Refresh data absensi saat bulan berubah
                                _fetchMonthlyAbsensi();
                              });
                            },
                          ),
                          Text(
                            '${_monthNames[_currentDate.month - 1]} ${_currentDate.year}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_right),
                            onPressed: () {
                              setState(() {
                                _currentDate = DateTime(
                                  _currentDate.year,
                                  _currentDate.month + 1,
                                  1,
                                );
                                // Refresh data absensi saat bulan berubah
                                _fetchMonthlyAbsensi();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    // Hari-hari dalam seminggu
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          _dayNameWidget("Minggu"),
                          _dayNameWidget("Senin"),
                          _dayNameWidget("Selasa"),
                          _dayNameWidget("Rabu"),
                          _dayNameWidget("Kamis"),
                          _dayNameWidget("Jumat"),
                          _dayNameWidget("Sabtu"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Grid kalender
                    _buildCalendarGrid(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tabel Riwayat Absensi (seperti di Laravel)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Riwayat Absensi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('No')),
                            DataColumn(label: Text('Tanggal')),
                            DataColumn(label: Text('Jam Masuk')),
                            DataColumn(label: Text('Jam Pulang')),
                            DataColumn(label: Text('Status')),
                          ],
                          rows: List.generate(
                            _absensiList.length,
                            (index) => DataRow(
                              cells: [
                                DataCell(Text('${index + 1}')),
                                DataCell(Text(_formatDate(
                                    _absensiList[index]['tanggal_absen']))),
                                DataCell(Text(_formatTime(
                                    _absensiList[index]['jam_masuk']))),
                                DataCell(Text(_formatTime(
                                    _absensiList[index]['jam_keluar']))),
                                DataCell(Text(
                                    _absensiList[index]['status'] ?? 'Hadir')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tambahkan padding di bawah untuk scrolling yang lebih baik
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Format tanggal untuk tampilan
  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}-${date.month}-${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  // Format waktu untuk tampilan
  String _formatTime(String? timeStr) {
    if (timeStr == null) return '-';
    try {
      final time = DateTime.parse(timeStr);
      return '${time.hour.toString().padLeft(2, '0')}.${time.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      if (timeStr.contains(':')) {
        return timeStr;
      }
      return '-';
    }
  }

  // Widget untuk nama hari
  Widget _dayNameWidget(String dayName) {
    return Expanded(
      child: Center(
        child: Text(
          dayName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // Membangun grid kalender
  Widget _buildCalendarGrid() {
    // Hitung jumlah baris yang dibutuhkan
    int totalDays = _daysInMonth + _firstDayIndex;
    int rowCount = (totalDays / 7).ceil();

    return GridView.count(
      shrinkWrap:
          true, // Penting! Ini membuat GridView mengambil ukuran sesuai kontennya
      physics:
          NeverScrollableScrollPhysics(), // Mencegah GridView di-scroll secara terpisah
      crossAxisCount: 7, // 7 hari dalam seminggu
      childAspectRatio: 1.0, // Sel berbentuk persegi
      padding: EdgeInsets.all(8.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      children: List.generate(rowCount * 7, (index) {
        // Cek apakah indeks kurang dari indeks hari pertama
        if (index < _firstDayIndex) {
          return Container(color: Colors.transparent);
        }

        // Hitung hari dari indeks
        int day = index - _firstDayIndex + 1;

        // Pastikan hari tidak melebihi jumlah hari dalam bulan
        if (day > _daysInMonth) {
          return Container(color: Colors.transparent);
        }

        // Tanggal untuk hari ini dalam format YYYY-MM-DD untuk pencocokan dengan API
        final dateKey =
            "${_currentDate.year}-${_currentDate.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

        // Ambil status dari data absensi jika ada
        final status = _absensiData[dateKey] ??
            _getDefaultStatusForDay(
                DateTime(_currentDate.year, _currentDate.month, day));

        return Container(
          decoration: BoxDecoration(
            color: _getCellColor(status),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black12, width: 0.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Nomor hari
              Text(
                "$day",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: _getTextColor(status),
                ),
              ),
              // Status
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    color: _getTextColor(status),
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Get default status for a specific day based on current date
  String _getDefaultStatusForDay(DateTime date) {
    // Tanggal saat ini
    final now = DateTime.now();

    // Jika tanggal yang diperiksa adalah masa depan
    if (date.isAfter(now)) {
      return ""; // Kosong untuk tanggal yang belum terjadi
    }

    // Contoh logika status berdasarkan hari dalam seminggu
    switch (date.weekday) {
      case DateTime.saturday:
      case DateTime.sunday:
        // Akhir pekan - biasanya libur
        return "Libur";
      default:
        // Untuk hari yang telah lewat tapi tidak ada data
        return date.isBefore(now) ? "Alfa" : "";
    }
  }

  // Get the background color for a cell based on status
  Color _getCellColor(String status) {
    switch (status) {
      case "Hadir":
        return Colors.green.shade100;
      case "Sakit":
        return Colors.orange.shade100;
      case "Telat":
        return Colors.yellow.shade100;
      case "Alfa":
        return Colors.red.shade100;
      case "Libur":
        return Colors.grey.shade100;
      default:
        return Colors.grey.shade50;
    }
  }

  // Get text color based on status
  Color _getTextColor(String status) {
    switch (status) {
      case "Hadir":
        return Colors.green.shade800;
      case "Sakit":
        return Colors.orange.shade800;
      case "Telat":
        return Colors.yellow.shade800;
      case "Alfa":
        return Colors.red.shade800;
      case "Libur":
        return Colors.grey.shade700;
      default:
        return Colors.black87;
    }
  }

  // Info row widget for the Welcome Card
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
