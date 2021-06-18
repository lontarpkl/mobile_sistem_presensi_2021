// To parse this JSON data, do
//
//     final dataPresensi = dataPresensiFromJson(jsonString);

import 'dart:convert';

List<DataPresensi> dataPresensiFromJson(String str) => List<DataPresensi>.from(
    json.decode(str).map((x) => DataPresensi.fromJson(x)).toList());

String dataPresensiToJson(List<DataPresensi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataPresensi {
  DataPresensi({
    this.id,
    this.rfidId,
    this.tanggal,
    this.jam,
    this.kehadiran,
    this.keterangan,
  });

  int id;
  String rfidId;
  String tanggal;
  String jam;
  String kehadiran;
  String keterangan;

  factory DataPresensi.fromJson(Map<String, dynamic> json) => DataPresensi(
        id: json["id"],
        rfidId: json["rfid_id"],
        tanggal: json["tanggal"],
        jam: json["jam"],
        kehadiran: json["kehadiran"],
        keterangan: json["keterangan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rfid_id": rfidId,
        "tanggal": tanggal,
        "jam": jam,
        "kehadiran": kehadiran,
        "keterangan": keterangan,
      };
}

// To parse this JSON data, do
//
//     final dataStudent = dataStudentFromJson(jsonString);

DataStudent dataStudentFromJson(String str) =>
    DataStudent.fromJson(json.decode(str));

String dataStudentToJson(DataStudent data) => json.encode(data.toJson());

class DataStudent {
  DataStudent({
    this.id,
    this.nis,
    this.nisn,
    this.rfid,
    this.name,
    this.photo,
    this.gender,
    this.idClass,
    this.address,
    this.parentsPhone,
    this.kelas,
  });

  int id;
  String nis;
  String nisn;
  String rfid;
  String name;
  String photo;
  int gender;
  String idClass;
  String address;
  String parentsPhone;
  Kelas kelas;

  factory DataStudent.fromJson(Map<String, dynamic> json) => DataStudent(
        id: json["id"],
        nis: json["nis"],
        nisn: json["nisn"],
        rfid: json["rfid"],
        name: json["name"],
        photo: json["photo"],
        gender: json["gender"],
        idClass: json["id_class"],
        address: json["address"],
        parentsPhone: json["parents_phone"],
        kelas: Kelas.fromJson(json["kelas"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nis": nis,
        "nisn": nisn,
        "rfid": rfid,
        "name": name,
        "photo": photo,
        "gender": gender,
        "id_class": idClass,
        "address": address,
        "parents_phone": parentsPhone,
        "kelas": kelas.toJson(),
      };
}

class Kelas {
  Kelas({
    this.id,
    this.kelasClass,
  });

  int id;
  String kelasClass;

  factory Kelas.fromJson(Map<String, dynamic> json) => Kelas(
        id: json["id"],
        kelasClass: json["class"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "class": kelasClass,
      };
}

// To parse this JSON data, do
//
//     final dataAnnouncement = dataAnnouncementFromJson(jsonString);

List<DataAnnouncement> dataAnnouncementFromJson(String str) =>
    List<DataAnnouncement>.from(
        json.decode(str).map((x) => DataAnnouncement.fromJson(x)));

String dataAnnouncementToJson(List<DataAnnouncement> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataAnnouncement {
  DataAnnouncement({
    this.id,
    this.title,
    this.content,
    this.thumbnail,
    this.author,
    this.slug,
  });

  int id;
  String title;
  String content;
  String thumbnail;
  String author;
  String slug;

  factory DataAnnouncement.fromJson(Map<String, dynamic> json) =>
      DataAnnouncement(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        thumbnail: json["thumbnail"],
        author: json["author"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "thumbnail": thumbnail,
        "author": author,
        "slug": slug,
      };
}

// To parse this JSON data, do
//
//     final DataDetailsAnnouncement = DataDetailsAnnouncementFromJson(jsonString);

DataDetailsAnnouncement dataDetailsAnnouncementFromJson(String str) =>
    DataDetailsAnnouncement.fromJson(json.decode(str));

String dataDetailsAnnouncementToJson(DataDetailsAnnouncement data) =>
    json.encode(data.toJson());

class DataDetailsAnnouncement {
  DataDetailsAnnouncement({
    this.id,
    this.title,
    this.content,
    this.thumbnail,
    this.author,
    this.slug,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String title;
  String content;
  String thumbnail;
  String author;
  String slug;
  DateTime createdAt;
  DateTime updatedAt;

  factory DataDetailsAnnouncement.fromJson(Map<String, dynamic> json) =>
      DataDetailsAnnouncement(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        thumbnail: json["thumbnail"],
        author: json["author"],
        slug: json["slug"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "thumbnail": thumbnail,
        "author": author,
        "slug": slug,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

// To parse this JSON data, do
//
//     final dataReportPresensi = dataReportPresensiFromJson(jsonString);

DataReportPresensi dataReportPresensiFromJson(String str) =>
    DataReportPresensi.fromJson(json.decode(str));

String dataReportPresensiToJson(DataReportPresensi data) =>
    json.encode(data.toJson());

class DataReportPresensi {
  DataReportPresensi({
    this.minggu,
    this.mingguMasuk,
    this.mingguPulang,
    this.bulan,
    this.bulanMasuk,
    this.bulanPulang,
  });

  int minggu;
  int mingguMasuk;
  int mingguPulang;
  int bulan;
  int bulanMasuk;
  int bulanPulang;

  factory DataReportPresensi.fromJson(Map<String, dynamic> json) =>
      DataReportPresensi(
        minggu: json["minggu"],
        mingguMasuk: json["minggu_masuk"],
        mingguPulang: json["minggu_pulang"],
        bulan: json["bulan"],
        bulanMasuk: json["bulan_masuk"],
        bulanPulang: json["bulan_pulang"],
      );

  Map<String, dynamic> toJson() => {
        "minggu": minggu,
        "minggu_masuk": mingguMasuk,
        "minggu_pulang": mingguPulang,
        "bulan": bulan,
        "bulan_masuk": bulanMasuk,
        "bulan_pulang": bulanPulang,
      };
}
