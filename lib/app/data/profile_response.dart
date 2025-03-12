class ProfileResponse {
  bool? success;
  String? message;
  Data? data;

  ProfileResponse({this.success, this.message, this.data});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
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
  Null? gaji;
  int? statusPegawai;
  int? idJabatan;
  String? provinsi;
  Null? kabupaten;
  Null? kecamatan;
  Null? kelurahan;
  String? email;
  Null? emailVerifiedAt;
  int? isAdmin;
  String? createdAt;
  String? updatedAt;
  Jabatan? jabatan;

  Data(
      {this.id,
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
      this.jabatan});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaPegawai = json['nama_pegawai'];
    tempatLahir = json['tempat_lahir'];
    tanggalLahir = json['tanggal_lahir'];
    jenisKelamin = json['jenis_kelamin'];
    alamat = json['alamat'];
    tanggalMasuk = json['tanggal_masuk'];
    gaji = json['gaji'];
    statusPegawai = json['status_pegawai'];
    idJabatan = json['id_jabatan'];
    provinsi = json['provinsi'];
    kabupaten = json['kabupaten'];
    kecamatan = json['kecamatan'];
    kelurahan = json['kelurahan'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    isAdmin = json['is_admin'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    jabatan =
        json['jabatan'] != null ? new Jabatan.fromJson(json['jabatan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_pegawai'] = this.namaPegawai;
    data['tempat_lahir'] = this.tempatLahir;
    data['tanggal_lahir'] = this.tanggalLahir;
    data['jenis_kelamin'] = this.jenisKelamin;
    data['alamat'] = this.alamat;
    data['tanggal_masuk'] = this.tanggalMasuk;
    data['gaji'] = this.gaji;
    data['status_pegawai'] = this.statusPegawai;
    data['id_jabatan'] = this.idJabatan;
    data['provinsi'] = this.provinsi;
    data['kabupaten'] = this.kabupaten;
    data['kecamatan'] = this.kecamatan;
    data['kelurahan'] = this.kelurahan;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['is_admin'] = this.isAdmin;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.jabatan != null) {
      data['jabatan'] = this.jabatan!.toJson();
    }
    return data;
  }
}

class Jabatan {
  int? id;
  String? namaJabatan;
  int? potonganGaji;
  String? createdAt;
  String? updatedAt;

  Jabatan(
      {this.id,
      this.namaJabatan,
      this.potonganGaji,
      this.createdAt,
      this.updatedAt});

  Jabatan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaJabatan = json['nama_jabatan'];
    potonganGaji = json['potongan_gaji'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama_jabatan'] = this.namaJabatan;
    data['potongan_gaji'] = this.potonganGaji;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
