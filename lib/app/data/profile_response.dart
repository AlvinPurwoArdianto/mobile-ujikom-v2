class ProfileResponse {
  bool? success;
  String? message;
  Data? data;

  ProfileResponse({this.success, this.message, this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class Data {
  int? id;
  String? namaPegawai;
  String? tempatLahir;
  String? tanggalLahir;
  String? jenisKelamin;
  String? alamat;
  String? tanggalMasuk;
  double? gaji;
  int? statusPegawai;
  int? idJabatan;
  String? provinsi;
  String? kabupaten;
  String? kecamatan;
  String? kelurahan;
  String? email;
  String? emailVerifiedAt;
  int? isAdmin;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.namaPegawai,
    this.tempatLahir,
    this.tanggalLahir,
    this.jenisKelamin,
    this.alamat,
    this.tanggalMasuk,
    this.gaji,
    this.statusPegawai,
    this.idJabatan,
    this.provinsi,
    this.kabupaten,
    this.kecamatan,
    this.kelurahan,
    this.email,
    this.emailVerifiedAt,
    this.isAdmin,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      namaPegawai: json['nama_pegawai'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'],
      jenisKelamin: json['jenis_kelamin'],
      alamat: json['alamat'],
      tanggalMasuk: json['tanggal_masuk'],
      gaji: (json['gaji'] as num?)?.toDouble(),
      statusPegawai: json['status_pegawai'],
      idJabatan: json['id_jabatan'],
      provinsi: json['provinsi'],
      kabupaten: json['kabupaten'],
      kecamatan: json['kecamatan'],
      kelurahan: json['kelurahan'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      isAdmin: json['is_admin'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_pegawai': namaPegawai,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir,
      'jenis_kelamin': jenisKelamin,
      'alamat': alamat,
      'tanggal_masuk': tanggalMasuk,
      'gaji': gaji,
      'status_pegawai': statusPegawai,
      'id_jabatan': idJabatan,
      'provinsi': provinsi,
      'kabupaten': kabupaten,
      'kecamatan': kecamatan,
      'kelurahan': kelurahan,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'is_admin': isAdmin,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
