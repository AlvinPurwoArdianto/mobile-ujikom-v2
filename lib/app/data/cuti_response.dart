class CutiResponse {
  bool? success;
  String? message;
  Data? data;

  CutiResponse({this.success, this.message, this.data});

  CutiResponse.fromJson(Map<String, dynamic> json) {
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
  int? idUser;
  String? tanggalMulai;
  String? tanggalSelesai;
  String? alasan;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.idUser,
      this.tanggalMulai,
      this.tanggalSelesai,
      this.alasan,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    idUser = json['id_user'];
    tanggalMulai = json['tanggal_mulai'];
    tanggalSelesai = json['tanggal_selesai'];
    alasan = json['alasan'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_user'] = this.idUser;
    data['tanggal_mulai'] = this.tanggalMulai;
    data['tanggal_selesai'] = this.tanggalSelesai;
    data['alasan'] = this.alasan;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
