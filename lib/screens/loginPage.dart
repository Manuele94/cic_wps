import 'dart:convert';

import 'package:cic_wps/models/sapReturnMessage.dart';
import 'package:cic_wps/models/snackBarMessage.dart';
import 'package:cic_wps/models/user.dart';
import 'package:cic_wps/screens/homePage.dart';
import 'package:cic_wps/singleton/dbManager.dart';
import 'package:cic_wps/singleton/networkManager.dart';
import 'package:cic_wps/utilities/constants.dart';
import 'package:cic_wps/utilities/sapMessageType.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:local_auth/local_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  static const routeName = '/LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _idController = TextEditingController();
  // final TextEditingController _pswController = TextEditingController();
  String _idText;
  String _pswText;
  final LocalAuthentication _auth = LocalAuthentication();
  // double _deviceWidth;
  Future<Map> _checkUserInfo;
  Future<bool> _canCheckBiometrics;
  Map<String, String> _authData;

  @override
  void initState() {
    super.initState();
    // _deviceWidth = MediaQuery.of(context).size.width;
    _idText = "";
    _pswText = "";
    _authData = {"id": "", "psw": ""};
    _checkUserInfo = _checkSavedUserInfo();
    _canCheckBiometrics = _checkBiometrics();
    // var futures = useMemoized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Container(
                  //   height: 270,
                  //   child: Container(
                  //     width: double.maxFinite,
                  //     child: Stack(
                  //       fit: StackFit.expand,
                  //       children: <Widget>[
                  //         Positioned(
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(top: 20),
                  //             child: Container(
                  //               decoration: BoxDecoration(
                  //                 image: DecorationImage(
                  //                   fit: BoxFit.fitWidth,
                  //                   image: AssetImage(
                  //                       "assets/images/loginPageBackgroundpng.png"),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Image.asset(
                    'assets/icon/ClearLogo.png',
                    height: 150,
                    width: 150,
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Padding(
                  // padding: EdgeInsets.symmetric(horizontal: 20.0),

                  Text(
                    "WorkPlaceStatus",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 35,
                      fontFamily: "IndieFlower",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // _pageHandler(context),
                  FutureBuilder(
                      future:
                          Future.wait([_checkUserInfo, _canCheckBiometrics]),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        // if (snapshot.hasError &&
                        //     snapshot.connectionState ==
                        //         ConnectionState.done) {
                        //   return Center(
                        //     child: const Text("Something went Wrong",
                        //         style: TextStyle(color: Colors.red)),
                        //   );
                        // } else
                        if (snapshot.connectionState == ConnectionState.done) {
                          var username = snapshot.hasData
                              ? snapshot.data[0]["username"]
                              : null;
                          var password = snapshot.hasData
                              ? snapshot.data[0]["password"]
                              : null;

                          if (username != null &&
                              password != null &&
                              snapshot.data[1] == true) {
                            // // se ho i dati e posso fare il fastLogin
                            // _idController.text = username.toString();
                            // _pswController.text = password.toString();
                            _idText = username.toString();
                            _pswText = password.toString();
                            return _authUi(username);
                          } else {
                            //se non posso usare il fastLogin
                            if (username != null && snapshot.data[1] == false) {
                              // _idController.text = username.toString();
                              _idText = username.toString();
                            } else {
                              // _idController.text = "";
                              // _pswController.text = "";
                              _idText = "";
                              _pswText = "";
                            }
                          }
                          return _noAuthUi();
                        } else {
                          return Align(
                              alignment: Alignment.center,
                              child: loaderSpinner(context));
                        }
                      })

                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _authUi(String id) {
    return Column(
      children: <Widget>[
        Text(
          "HI $id",
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 25,
            fontFamily: "IndieFlower",
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _checkUserInfo = null;
              _idText = "";
              _pswText = "";
              // _idController.text = "";
              // _pswController.text = "";
            });
          },
          child: Text(
            "Not you?",
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: 40,
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 70),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).accentColor,
          ),
          child: InkWell(
            onTap: () {
              // _authData["psw"] = _pswController.text;
              // _authData["id"] = _idController.text;
              _authData["id"] = _idText;
              _authData["psw"] = _pswText;
              _pushFastLoginButton(context);
            },
            child: Center(
              child: Text(
                "Fast Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _noAuthUi() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(children: <Widget>[
        TextFormField(
          // initialValue: _idText,
          // controller: _idController,
          maxLength: 8,
          validator: (value) => value.isEmpty ? 'ID cant\' be empty' : null,
          style: TextStyle(color: Theme.of(context).accentColor),
          decoration: idInputDecoration(context),
          onSaved: (value) => _authData["id"] = value.toUpperCase(),
        ),

        TextFormField(
          // initialValue: _pswText,
          // controller: _pswController,
          obscureText: true,
          maxLength: 15,
          validator: (value) =>
              value.isEmpty ? 'Password cant\'t be empty' : null,
          style: TextStyle(color: Theme.of(context).accentColor),
          decoration: pswInputDecoration(context),
          onSaved: (value) => _authData["psw"] = value,
        ),

        // SizedBox(
        //   height: 5.0,
        // ),
        Center(
          child: FlatButton(
            onPressed: null,
            child: Text(
              "Forgot Password?",
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          height: 40,
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).accentColor,
          ),
          child: InkWell(
            onTap: () => _pushLoginButton(context),
            child: Center(
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Divider(height: 5, color: Theme.of(context).accentColor),
              ),
              SizedBox(
                width: 3,
              ),
              Text("OR",
                  style: TextStyle(color: Theme.of(context).accentColor)),
              SizedBox(
                width: 3,
              ),
              Expanded(
                child: Divider(
                  height: 5,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ),
        Center(
            child: FlatButton(
          onPressed: null,
          child: Text(
            "Create Account",
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        )),
      ]),
    );
  }

  Future<bool> _checkBiometrics() async {
    bool canCheckBio = false;
    try {
      canCheckBio = await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return false; //per non usare setState inutilmente
    return canCheckBio;
  }

  Future<bool> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await _auth.authenticateWithBiometrics(
          localizedReason: "Waiting for you to scan..",
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return false; //per non usare setState inutilmente
    return authenticated;
  }

  Future<Map> _checkSavedUserInfo() async {
    var empty = Map();
    try {
      final dbUser = await DbManager.getData("user");
      var user = dbUser.first;
      return user;
    } catch (e) {
      return empty;
    }
  }

  Future<void> _pushLoginButton(BuildContext ctx) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      startLoadingSpinner(ctx);
      try {
        var response = await NetworkManager().getForLogin(_authData);
        if (response.statusCode >= 200 && response.statusCode <= 300) {
          var user = User.fromJson(jsonDecode(response.body));
          var message = SapReturnMessage.fromJson(jsonDecode(response.body));
          if (message.getCode == SapMessageType.E.value ||
              message.getCode == SapMessageType.W.value) {
            Navigator.pop(ctx);
            return message.returnSnackByMessage(ctx);
          } else {
            // if (user.password == _pswController.text) {
            await DbManager.insert('user', {
              'id': 0,
              // 'username': user.username,
              'username': _authData["id"],
              'sUser': "",
              // 'password': user.password
              'password': _authData["psw"]
            });
            Navigator.pop(ctx);
            Navigator.of(context).pushReplacementNamed(HomePage.routeName);
          }
        }
      } catch (error) {
        Navigator.pop(ctx);
        SnackBarMessage.genericError(ctx, "Something goes wrong!");
      }
    }
  }

  Future<void> _pushFastLoginButton(BuildContext ctx) async {
    if (await _authenticate()) {
      _pushLoginButton(ctx);
    }
  }
}
