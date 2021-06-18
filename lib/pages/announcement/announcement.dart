import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_presensi_laravel/models/model_json.dart';
import 'package:flutter_api_presensi_laravel/pages/announcement/announcement_details.dart';
import 'package:flutter_api_presensi_laravel/pages/app.dart';
import 'package:flutter_api_presensi_laravel/utils/const.dart';
import 'package:flutter_api_presensi_laravel/utils/http_services.dart';
import 'package:html/parser.dart' show parse;
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementPages extends StatefulWidget {
  AnnouncementPages({Key key}) : super(key: key);

  @override
  _AnnouncementPagesState createState() => _AnnouncementPagesState();
}

class _AnnouncementPagesState extends State<AnnouncementPages> {
  HttpService httpService;
  Future<List<DataAnnouncement>> futureData = HttpService().getAnnouncement();

  var url = webURL + "/storage/";
  String token;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    readToken();
    super.initState();
  }

  readToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
  }

  Future<Null> _onRefreshData() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (a, b, c) => App(),
        transitionDuration: Duration(seconds: 0),
      ),
    );
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefreshData,
        child: FutureBuilder(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final content = parse('${snapshot.data[index].content}');
                  final String parsedContent =
                      parse(content.body.text).documentElement.text;
                  return Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: NetworkImage(
                              url + "${snapshot.data[index].thumbnail}",
                              headers: {
                                'Authorization': 'Bearer $token',
                              }),
                          fit: BoxFit.cover),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Frost(
                        frostColor: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailAnnouncement(
                                  slug: "${snapshot.data[index].slug}",
                                ),
                              ),
                            );
                          },
                          title: Padding(
                            // padding: EdgeInsets.only(
                            //     top: 100, bottom: 10, left: 0, right: 10),
                            padding: EdgeInsets.all(0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data[index].title}",
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    // color: Brightness.light != true
                                    //     ? Colors.white
                                    //     : Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  parsedContent,
                                  maxLines: 3,
                                  style: TextStyle(fontSize: 15
                                      // color: Brightness.light != true
                                      //     ? Colors.white
                                      //     : Colors.black,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
