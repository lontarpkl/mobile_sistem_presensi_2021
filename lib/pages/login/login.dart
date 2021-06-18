import 'package:flutter/material.dart';
import 'package:flutter_api_presensi_laravel/pages/app.dart';
import 'package:flutter_api_presensi_laravel/utils/http_services.dart';
import 'package:page_transition/page_transition.dart';

class LoginPages extends StatefulWidget {
  LoginPages({Key key}) : super(key: key);

  @override
  LoginPagesState createState() => LoginPagesState();
}

class LoginPagesState extends State<LoginPages> {
  HttpService httpServices = new HttpService();

  final TextEditingController _nisController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _passwordVisible = true;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
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
      key: _scaffoldKey,
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
                child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          child: Icon(
                            Icons.card_membership,
                            size: 50.0,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Aplikasi Presensi",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.only(
                      top: 50,
                      left: 20,
                      right: 20,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: _nisController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                ),
                                labelText: "NIS ",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal),
                              ),
                              validator: (nisValue) {
                                if (nisValue.isEmpty) {
                                  return 'Harap masukan NIS';
                                }
                                _nisController.text = nisValue;
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: !_passwordVisible,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                labelText: "Password",
                                hintStyle: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal),
                              ),
                              validator: (passValue) {
                                if (passValue.isEmpty) {
                                  return 'Harap masukan Password';
                                }
                                _passwordController.text = passValue;
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  child: Text(
                                    _isLoading ? 'Harap tunggu...' : 'Masuk',
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    httpServices
                                        .login(
                                            _nisController.text
                                                .trim()
                                                .toLowerCase(),
                                            _passwordController.text.trim())
                                        .whenComplete(() {
                                      if (httpServices.status) {
                                        showMsg(
                                            "Tidak dapat masuk, \nHarap periksa NIS dan Password");
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      } else {
                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType.fade,
                                                child: App()));
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
