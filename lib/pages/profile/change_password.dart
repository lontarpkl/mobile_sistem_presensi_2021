import 'package:flutter/material.dart';
import 'package:flutter_api_presensi_laravel/utils/http_services.dart';

class ChangePasswords extends StatefulWidget {
  ChangePasswords({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswords> {
  bool _passwordVisible = true;
  bool _passwordVisible2 = true;
  bool _passwordVisible3 = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordOld = TextEditingController();
  final TextEditingController _passwordNew = TextEditingController();
  final TextEditingController _cPasswordNew = TextEditingController();

  HttpService _httpService;

  @override
  void initState() {
    _passwordVisible = false;
    _passwordVisible2 = false;
    _passwordVisible3 = false;
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
      appBar: AppBar(
        title: Text(
          "Ubah Sandi",
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(15),
            children: [
              Text(
                "Sandi Lama",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _passwordOld,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18)),
                  hintText: "Masukan sandi lama",
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
                ),
                validator: (passOld) {
                  if (passOld.isEmpty) {
                    return 'Harap masukan sandi lama';
                  }
                  _passwordOld.text = passOld;
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Sandi Baru",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _passwordNew,
                obscureText: !_passwordVisible2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18)),
                  hintText: "Masukan sandi baru",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible2
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible2 = !_passwordVisible2;
                      });
                    },
                  ),
                ),
                validator: (passNew) {
                  if (passNew.isEmpty) {
                    return 'Harap masukan sandi baru';
                  }
                  _passwordNew.text = passNew;
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Konfirmasi sandi baru",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _cPasswordNew,
                obscureText: !_passwordVisible3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18)),
                  hintText: "Masukan kembali sandi baru",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible3
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible3 = !_passwordVisible3;
                      });
                    },
                  ),
                ),
                validator: (cPassNew) {
                  if (cPassNew.isEmpty) {
                    return 'Harap masukan kembali sandi baru';
                  }
                  _cPasswordNew.text = cPassNew;
                  if (cPassNew != _passwordNew.text) {
                    return 'Sandi baru tidak sama!';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    child: Text("Reset"),
                    textColor: Colors.white,
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    onPressed: () {
                      _passwordOld.clear();
                      _passwordNew.clear();
                      _cPasswordNew.clear();
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  MaterialButton(
                    child: Text(_isLoading ? 'Harap tunggu...' : 'Ubah Sandi!'),
                    textColor: Colors.white,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    onPressed: () async {
                      setState(() {
                        _isLoading = false;
                      });
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        await _httpService
                            .changePassword(_passwordOld.text,
                                _passwordNew.text, _cPasswordNew.text)
                            .whenComplete(() {
                          showMsg("msg");
                        });
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
