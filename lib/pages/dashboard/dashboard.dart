import 'package:flutter/material.dart';
import 'package:flutter_api_presensi_laravel/models/model_json.dart';
import 'package:flutter_api_presensi_laravel/pages/app.dart';
import 'package:flutter_api_presensi_laravel/utils/const.dart';
import 'package:flutter_api_presensi_laravel/utils/http_services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPages extends StatefulWidget {
  DashboardPages({Key key}) : super(key: key);

  @override
  _DashboardPagesState createState() => _DashboardPagesState();
}

class _DashboardPagesState extends State<DashboardPages> {
  _DashboardPagesState();

  SharedPreferences sharedPreferences;
  HttpService httpService;

  Future<List<DataPresensi>> futureData = HttpService().getPresensi();

  Future<DataReportPresensi> futureReport = HttpService().getReportPresensi();

  var url = webURL + "/storage/";

  @override
  void initState() {
    super.initState();
  }

  int daysInMonth(DateTime date) {
    var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = new DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: FutureBuilder(
  //       future: futureReport,
  //       builder: (context, snapshot) {
  //         var now = DateTime.now();
  //         var weekday = DateTime.now().weekday;
  //         var nowok = DateTime(now.year, now.month);
  //         var totalTanggal = daysInMonth(nowok);

  //         return Container(
  //             height: MediaQuery.of(context).size.height / 1,
  //             width: MediaQuery.of(context).size.width,
  //             margin: EdgeInsets.all(15),
  //             child: Column(
  //               children: [
  //                 Text(totalTanggal.toString()),
  //                 Card(
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(15),
  //                   ),
  //                   child: Padding(
  //                     padding: EdgeInsets.all(10),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           "Kilasan Presensi Minggu Ini",
  //                           style: TextStyle(
  //                               fontSize: 18,
  //                               fontFamily: 'Poppins',
  //                               fontWeight: FontWeight.w500),
  //                         ),
  //                         Divider(
  //                           color: Theme.of(context).accentColor,
  //                           thickness: 2,
  //                           endIndent: 100,
  //                         ),
  //                         SizedBox(
  //                           height: 5,
  //                         ),
  //                         Row(
  //                           children: [
  //                             Expanded(
  //                               flex: 75,
  //                               child: Container(
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   children: [
  //                                     CircularPercentIndicator(
  //                                       radius: 70,
  //                                       progressColor: Colors.blue,
  //                                       percent: snapshot.data.mingguMasuk / 5,
  //                                       center: Text(
  //                                           "${snapshot.data.mingguMasuk.toString()}"),
  //                                     ),
  //                                     SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                     Text("Masuk"),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                             Expanded(
  //                               flex: 75,
  //                               child: Container(
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   children: [
  //                                     CircularPercentIndicator(
  //                                       radius: 70,
  //                                       progressColor: Colors.orange,
  //                                       percent: snapshot.data.mingguPulang / 5,
  //                                       center: Text(
  //                                           "${snapshot.data.mingguPulang.toString()}"),
  //                                     ),
  //                                     SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                     Text("Pulang"),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                             Expanded(
  //                               flex: 80,
  //                               child: Container(
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   children: [
  //                                     CircularPercentIndicator(
  //                                       radius: 70,
  //                                       progressColor: Colors.amberAccent,
  //                                       percent: snapshot.data.minggu / 10,
  //                                       center: Text(
  //                                           "${snapshot.data.minggu.toString()}"),
  //                                     ),
  //                                     SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                     Text("Total Presensi"),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 8,
  //                         ),
  //                         Text(
  //                           "*Total Presensi = Jumlah masuk dan pulang",
  //                           style:
  //                               TextStyle(fontSize: 11, fontFamily: 'Poppins'),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 Card(
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(15),
  //                   ),
  //                   child: Padding(
  //                     padding: EdgeInsets.all(10),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           "Kilasan Presensi Bulan Ini",
  //                           style: TextStyle(
  //                               fontSize: 18,
  //                               fontFamily: 'Poppins',
  //                               fontWeight: FontWeight.w500),
  //                         ),
  //                         Divider(
  //                           color: Theme.of(context).accentColor,
  //                           thickness: 2,
  //                           endIndent: 100,
  //                         ),
  //                         SizedBox(
  //                           height: 5,
  //                         ),
  //                         Row(
  //                           children: [
  //                             Expanded(
  //                               flex: 75,
  //                               child: Container(
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   children: [
  //                                     CircularPercentIndicator(
  //                                       radius: 70,
  //                                       progressColor: Colors.blue,
  //                                       percent: snapshot.data.bulanMasuk / 5,
  //                                       center: Text(
  //                                           "${snapshot.data.bulanMasuk.toString()}"),
  //                                     ),
  //                                     SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                     Text("Masuk"),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                             Expanded(
  //                               flex: 75,
  //                               child: Container(
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   children: [
  //                                     CircularPercentIndicator(
  //                                       radius: 70,
  //                                       progressColor: Colors.orange,
  //                                       percent: snapshot.data.bulanPulang / 5,
  //                                       center: Text(
  //                                           "${snapshot.data.bulanPulang.toString()}"),
  //                                     ),
  //                                     SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                     Text("Pulang"),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                             Expanded(
  //                               flex: 80,
  //                               child: Container(
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   children: [
  //                                     CircularPercentIndicator(
  //                                       radius: 70,
  //                                       progressColor: Colors.amberAccent,
  //                                       percent: snapshot.data.bulan / 22,
  //                                       center: Text(
  //                                           "${snapshot.data.bulan.toString()}"),
  //                                     ),
  //                                     SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                     Text("Total Presensi"),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         SizedBox(
  //                           height: 8,
  //                         ),
  //                         Text(
  //                           "*Total Presensi = Jumlah masuk dan pulang",
  //                           style:
  //                               TextStyle(fontSize: 11, fontFamily: 'Poppins'),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ));
  //       },
  //     ),
  //   );
  // }

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
                  final String date = "${snapshot.data[index].tanggal}";
                  final DateTime dateTime = DateTime.parse(date);
                  final DateFormat formatter = DateFormat('dd-MM-yyyy');
                  final String formatted = formatter.format(dateTime);
                  return Card(
                    margin: EdgeInsets.all(10),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      title: Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 75,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 70,
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Presensi ${snapshot.data[index].keterangan} Terdeteksi!",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 100,
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "Ananda telah melakukan tap presensi ${snapshot.data[index].keterangan} pada tanggal $formatted pukul ${snapshot.data[index].jam}"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 20,
                              child: Container(
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                height: 60,
                                decoration: BoxDecoration(
                                    color:
                                        "${snapshot.data[index].kehadiran}" ==
                                                "Terlambat"
                                            ? Colors.red
                                            : Colors.green,
                                    borderRadius: BorderRadius.circular(15)),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${snapshot.data[index].kehadiran}",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
