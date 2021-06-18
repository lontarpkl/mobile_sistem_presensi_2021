import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_presensi_laravel/models/model_json.dart';
import 'package:flutter_api_presensi_laravel/utils/const.dart';
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class DetailAnnouncement extends StatelessWidget {
  DetailAnnouncement({Key key, this.slug}) : super(key: key);
  String slug, token;
  var url = webURL + "/storage/";
  SharedPreferences sharedPreferences;

  readToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
  }

  //function untuk mengambil data detail pengumuman berupa slug
  Future<DataDetailsAnnouncement> getDetailAnnouncement() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');

    String dataURl = apiURL + "/posts/detail/$slug";

    final response = await http.get(Uri.parse(dataURl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // print(response.body);
    return dataDetailsAnnouncementFromJson(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<DataDetailsAnnouncement>(
        future: getDetailAnnouncement(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //mencoba parse text yang ada tag html nya
            final content = parse('${snapshot.data.content}');
            final String parsedContent =
                parse(content.body.text).documentElement.text;
            //mencoba parse tanggal dari json dan hanya mengambil tanggal
            final String date = "${snapshot.data.updatedAt}";
            final DateTime dateTime = DateTime.parse(date);
            final DateFormat formatter = DateFormat('dd-MM-yyyy');
            final String formatted = formatter.format(dateTime);
            return ListView(children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            url + "${snapshot.data.thumbnail}",
                            headers: {
                              'Authorization': 'Bearer $token',
                            },
                          ),
                          fit: BoxFit.cover),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 5,
                      ),
                      child: Frost(
                        blur: 10,
                        frostColor: Theme.of(context).backgroundColor,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "${snapshot.data.title}",
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_circle_rounded,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("${snapshot.data.author}"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    formatted,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      parsedContent,
                      textAlign: TextAlign.justify,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              )
            ]);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
