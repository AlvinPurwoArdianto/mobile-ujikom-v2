import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ujikom/app/modules/pengajuan/controllers/pengajuan_controller.dart';

class PengajuanView extends StatefulWidget {
  const PengajuanView({super.key});

  @override
  State<PengajuanView> createState() => _PengajuanViewState();
}

class _PengajuanViewState extends State<PengajuanView> {
  final PengajuanController _pengajuanController =
      Get.put(PengajuanController());
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedCategory;
  final TextEditingController _reasonController = TextEditingController();
  bool _isLoading = false;

  // Calculate min date (7 days from now as required by API)
  DateTime get _minDate => DateTime.now().add(const Duration(days: 7));

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _minDate : (_startDate ?? _minDate),
      firstDate: isStartDate ? _minDate : (_startDate ?? _minDate),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          // Reset end date if it's before the new start date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  void _submitLeaveRequest() async {
    if (_startDate == null ||
        _endDate == null ||
        _selectedCategory == null ||
        _reasonController.text.isEmpty) {
      Get.snackbar("Error", "Harap isi semua field!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Using your controller's submitLeaveRequest method
      final result = await _pengajuanController.submitLeaveRequest(
        _startDate!,
        _endDate!,
        _selectedCategory!,
        _reasonController.text,
      );

      setState(() => _isLoading = false);

      if (result != null && result['success'] == true) {
        Get.snackbar(
            "Sukses", result['message'] ?? "Pengajuan cuti berhasil dikirim!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        // Clear form after successful submission
        setState(() {
          _startDate = null;
          _endDate = null;
          _selectedCategory = null;
          _reasonController.clear();
        });
      } else {
        // Handle error
        String errorMessage = result != null
            ? (result['message'] ?? "Terjadi kesalahan")
            : "Terjadi kesalahan";

        Get.snackbar("Error", errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar("Error", "Terjadi kesalahan: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengajuan Cuti'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Tanggal Cuti",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _selectDate(context, true),
                              child: Text(_startDate == null
                                  ? "Pilih Tanggal Mulai"
                                  : DateFormat('dd MMM yyyy')
                                      .format(_startDate!)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _startDate == null
                                  ? null
                                  : () => _selectDate(context, false),
                              child: Text(_endDate == null
                                  ? "Pilih Tanggal Akhir"
                                  : DateFormat('dd MMM yyyy')
                                      .format(_endDate!)),
                            ),
                          ),
                        ],
                      ),
                      if (_startDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Catatan: Tanggal mulai cuti minimal 7 hari dari sekarang",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Kategori Cuti",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    RadioListTile(
                      title: const Text("Tahunan/Liburan"),
                      value: "Tahunan",
                      groupValue: _selectedCategory,
                      onChanged: (value) =>
                          setState(() => _selectedCategory = value as String),
                    ),
                    RadioListTile(
                      title: const Text("Acara Keluarga"),
                      value: "Acara Keluarga",
                      groupValue: _selectedCategory,
                      onChanged: (value) =>
                          setState(() => _selectedCategory = value as String),
                    ),
                    RadioListTile(
                      title: const Text("Hamil (Khusus Wanita)"),
                      value: "Hamil",
                      groupValue: _selectedCategory,
                      onChanged: (value) =>
                          setState(() => _selectedCategory = value as String),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("Alasan Cuti",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: _reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Masukkan alasan cuti...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitLeaveRequest,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.blue,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Ajukan Cuti",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


