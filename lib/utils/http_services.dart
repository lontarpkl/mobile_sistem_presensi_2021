import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_api_presensi_laravel/models/model_json.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_api_presensi_laravel/utils/const.dart';

class HttpService {
  String nis, password, slug;

  var jsonResponse, status, slugs;

  login(nis, password) async {
    String loginURL = apiURL + "/login";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map data = {
      'nis': nis,
      'password': password,
    };

    var response = await http.post(Uri.parse(loginURL), body: data);

    debugPrint(response.statusCode.toString());
    status = response.body.contains('message');

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (status) {
        print('data : ${jsonResponse["message"]}');
      } else {
        sharedPreferences.setString("token", jsonResponse['success']['token']);
        sharedPreferences.setString("user", nis);
        await FirebaseMessaging()
            .subscribeToTopic(sharedPreferences.getString('user'));
        await FirebaseMessaging().subscribeToTopic('pengumuman');
      }
    } else {
      return status;
    }
  }

  logout() async {
    String logoutURL = apiURL + "/logout";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');

    http.Response response = await http.post(Uri.parse(logoutURL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    jsonResponse = json.decode(response.body);
    var msg = response.body.contains('message');
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      await FirebaseMessaging()
          .unsubscribeFromTopic(sharedPreferences.getString("user"));
      await FirebaseMessaging().unsubscribeFromTopic("pengumuman");
      sharedPreferences.remove('token');
      sharedPreferences.remove('user');
      print(jsonResponse['message']);
    }
    print(msg);
    return jsonResponse;
    // print(msg);
  }

  changePassword(String oldPassword, newPassword, cNewPassword) async {
    String passwordURL = apiURL + "/change-password";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');

    Map data = {
      'old_password': oldPassword,
      'new_password': newPassword,
      'confirm_password': cNewPassword,
    };

    var response = await http.post(Uri.parse(passwordURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data);

    debugPrint(response.statusCode.toString());
    var msg = response.body.contains('message');

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse['message']);
      return jsonResponse;
    } else {
      print(msg);
    }
  }

  Future<List<DataPresensi>> getPresensi() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');

    String dataURl = apiURL + "/presences";

    final response = await http.get(Uri.parse(dataURl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return dataPresensiFromJson(response.body);
  }

  //function untuk mengambil data siswa
  Future<DataStudent> getStudent() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');

    String dataURl = apiURL + "/details";

    final response = await http.get(Uri.parse(dataURl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    return dataStudentFromJson(response.body);
  }

  //function untuk mengambil data pengumuman
  Future<List<DataAnnouncement>> getAnnouncement() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');

    String dataURl = apiURL + "/posts";

    final response = await http.get(Uri.parse(dataURl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    return dataAnnouncementFromJson(response.body);
  }

  Future<DataReportPresensi> getReportPresensi() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');

    String dataURl = apiURL + "/report";

    final response = await http.get(Uri.parse(dataURl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    return dataReportPresensiFromJson(response.body);
  }
}
