import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_presensi_laravel/pages/login/login.dart';
import 'package:flutter_api_presensi_laravel/models/model_json.dart';
import 'package:flutter_api_presensi_laravel/pages/profile/detail_profile.dart';
import 'package:flutter_api_presensi_laravel/utils/http_services.dart';
import 'package:flutter_api_presensi_laravel/utils/const.dart';

class ProfilePages extends StatefulWidget {
  @override
  _ProfilePagesState createState() => _ProfilePagesState();
}

class _ProfilePagesState extends State<ProfilePages> {
  String nama, nis, nisn, photo, token;
  File _image;

  var url = webURL + "/storage/";
  final Future<DataStudent> futureData = HttpService().getStudent();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            _profil(),
            SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Pengaturan",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                        fontFamily: 'Poppins'),
                  ),
                ),
                // _listItem(
                //   title: "Ubah Sandi",
                //   icon: Icons.lock,
                //   onTap: () => Navigator.of(context).push(MaterialPageRoute(
                //       builder: (context) => ChangePasswords())),
                // ),
                _listItem(
                  title: "Logout",
                  icon: Icons.logout,
                  onTap: () => AwesomeDialog(
                      context: context,
                      dialogType: DialogType.WARNING,
                      headerAnimationLoop: false,
                      animType: AnimType.SCALE,
                      title: 'Perhatian!',
                      desc: 'Yakin untuk melakukan Logout?..',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        await HttpService().logout();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginPages()),
                            (Route<dynamic> route) => false);
                      })
                    ..show(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _listItem({IconData icon, String title, GestureTapCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: <Widget>[
            Icon(icon),
            Padding(
              padding: EdgeInsets.only(left: 50),
              child: Text(
                title,
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            )
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  _profil() {
    return FutureBuilder<DataStudent>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 4,
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailProfile(),
                ),
              ),
              title: Column(
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
                              color: Theme.of(context).scaffoldBackgroundColor),
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
                    ]),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "${snapshot.data.name}",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${snapshot.data.kelas.kelasClass}",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
