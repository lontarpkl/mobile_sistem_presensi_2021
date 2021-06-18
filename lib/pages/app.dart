import 'package:flutter/material.dart';
import 'package:flutter_api_presensi_laravel/pages/announcement/announcement.dart';
import 'package:flutter_api_presensi_laravel/pages/dashboard/dashboard.dart';
import 'package:flutter_api_presensi_laravel/pages/login/login.dart';
import 'package:flutter_api_presensi_laravel/pages/profile/profile.dart';
import 'package:flutter_api_presensi_laravel/models/model_json.dart';
import 'package:flutter_api_presensi_laravel/utils/const.dart';
import 'package:flutter_api_presensi_laravel/utils/http_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  TabController tabController;
  SharedPreferences sharedPreferences;
  String nama, nis, nisn, photo, token;

  final Future<DataStudent> futureData = HttpService().getStudent();
  var url = webURL + "/storage/";

  void initState() {
    tabController = new TabController(vsync: this, length: 2);
    read();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  read() async {
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
    if (token == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPages()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataStudent>(
      future: futureData,
      builder: (context, snapshot) {
        nama = "${snapshot.data.name.toString()}";
        return Scaffold(
          appBar: new AppBar(
            toolbarHeight: 120,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama + " | " + "${snapshot.data.kelas.kelasClass.toString()}",
                  style: TextStyle(fontSize: 18),
                ),
                Text("${snapshot.data.nis.toString()}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
              ],
            ),
            leading: MaterialButton(
              padding: EdgeInsets.only(left: 5),
              child: CircleAvatar(
                radius: 20,
                child: ClipOval(
                  child: new SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: (Image.network(
                      url + "${snapshot.data.photo.toString()}",
                      headers: {
                        'Authorization': 'Bearer $token',
                      },
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ProfilePages())),
            ),
            bottom: new TabBar(
              controller: tabController,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.5, color: Colors.white),
                insets: EdgeInsets.symmetric(horizontal: 50),
              ),
              tabs: <Widget>[
                new Tab(
                  text: 'Laporan',
                ),
                new Tab(
                  text: 'Pengumuman',
                ),
              ],
            ),
          ),
          body: new TabBarView(controller: tabController, children: <Widget>[
            new DashboardPages(),
            new AnnouncementPages(),
          ]),
        );
      },
    );
  }
}
