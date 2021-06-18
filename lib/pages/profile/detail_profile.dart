import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_api_presensi_laravel/models/model_json.dart';
import 'package:flutter_api_presensi_laravel/utils/const.dart';
import 'package:flutter_api_presensi_laravel/utils/http_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailProfile extends StatefulWidget {
  DetailProfile({Key key}) : super(key: key);

  @override
  _DetailProfileState createState() => _DetailProfileState();
}

class _DetailProfileState extends State<DetailProfile> {
  String nama, nis, nisn, photo, token;
  File _image;

  var url = webURL + "/storage/";
  final _picker = ImagePicker();
  final Future<DataStudent> futureData = HttpService().getStudent();

  Future<void> _pickImageFromCamera() async {
    final PickedFile pickedFile =
        await _picker.getImage(source: ImageSource.camera);
    setState(() {
      this._image = File(pickedFile.path);
      print(_image.path);
    });
    uploadPhoto();
  }

  Future<void> _pickImageFromGallery() async {
    final PickedFile pickedFile =
        await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      this._image = File(pickedFile.path);
      print(_image.path);
    });
    uploadPhoto();
  }

  Future<void> uploadPhoto() async {
    String uploadURL = apiURL + "/photo-profile";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');

    var request = new http.MultipartRequest('POST', Uri.parse(uploadURL));
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("photo", _image.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();
    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    showMsg(responseString);
  }

  showMsg(msg) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Siswa"),
        centerTitle: true,
      ),
      body: FutureBuilder<DataStudent>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Stack(children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 100,
                            child: ClipOval(
                              child: new SizedBox(
                                width: 180.0,
                                height: 180.0,
                                child: (_image != null)
                                    ? Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        url + "${snapshot.data.photo}",
                                        headers: {
                                          'Authorization': 'Bearer $token',
                                        },
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            child: MaterialButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Icon(
                                Icons.camera_alt,
                                size: 22,
                              ),
                              padding: EdgeInsets.all(2),
                              shape: CircleBorder(),
                              onPressed: () => showModalBottomSheet(
                                context: context,
                                builder: (context) => SingleChildScrollView(
                                  controller: ModalScrollController.of(context),
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          title: Text("Kamera"),
                                          subtitle: Text(
                                              "Ambil foto dari kamera anda"),
                                          leading: Icon(Icons.camera_alt),
                                          onTap: () async {
                                            _pickImageFromCamera();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ListTile(
                                          title: Text("Galeri"),
                                          subtitle: Text(
                                              "Ambil foto dari galeri hp anda"),
                                          leading: Icon(Icons.image_rounded),
                                          onTap: () async {
                                            _pickImageFromGallery();
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    _item("Nama", "${snapshot.data.name}"),
                    _item("NISN", "${snapshot.data.nisn}"),
                    _item("NIS", "${snapshot.data.nis}"),
                    _item("Kelas", "${snapshot.data.kelas.kelasClass}"),
                    _item("Jenis Kelamin",
                        snapshot.data.gender == 0 ? "Laki-Laki" : "Perempuan"),
                    _item("Alamat", "${snapshot.data.address}"),
                    _item(
                        "Nomor HP Orang Tua", "${snapshot.data.parentsPhone}"),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _item(String title, body) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, bottom: 2, top: 2, right: 10),
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            height: 60,
            // height: MediaQuery.of(context).size.height / 15,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).backgroundColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: LayoutBuilder(
              builder: (context, constraint) {
                return Container(
                  alignment: Alignment.centerLeft,
                  height: constraint.maxHeight,
                  child: Text(
                    body,
                    maxLines: 2,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
