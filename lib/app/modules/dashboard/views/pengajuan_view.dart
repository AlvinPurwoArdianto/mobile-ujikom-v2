import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PengajuanView extends StatefulWidget {
  const PengajuanView({super.key});

  @override
  State<PengajuanView> createState() => _PengajuanViewState();
}

class _PengajuanViewState extends State<PengajuanView> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedCategory;
  final TextEditingController _reasonController = TextEditingController();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  void _submitLeaveRequest() {
    if (_startDate == null ||
        _endDate == null ||
        _selectedCategory == null ||
        _reasonController.text.isEmpty) {
      Get.snackbar("Error", "Harap isi semua field!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } else {
      Get.snackbar("Sukses", "Pengajuan cuti berhasil dikirim!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
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
                            onPressed: () => _selectDate(context, false),
                            child: Text(_endDate == null
                                ? "Pilih Tanggal Akhir"
                                : DateFormat('dd MMM yyyy').format(_endDate!)),
                          ),
                        ),
                      ],
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
                    title: const Text("Tahunan"),
                    value: "Tahunan",
                    groupValue: _selectedCategory,
                    onChanged: (value) =>
                        setState(() => _selectedCategory = value as String),
                  ),
                  RadioListTile(
                    title: const Text("Sakit"),
                    value: "Sakit",
                    groupValue: _selectedCategory,
                    onChanged: (value) =>
                        setState(() => _selectedCategory = value as String),
                  ),
                  RadioListTile(
                    title: const Text("Izin Lainnya"),
                    value: "Izin Lainnya",
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitLeaveRequest,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Colors.blue,
                ),
                child: const Text("Ajukan Cuti",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
