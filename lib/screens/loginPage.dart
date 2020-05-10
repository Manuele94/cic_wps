import 'dart:convert';

import 'package:cic_wps/models/sapReturnMessage.dart';
import 'package:cic_wps/models/snackBarMessage.dart';
import 'package:cic_wps/models/user.dart';
import 'package:cic_wps/screens/credentialsRecoveryPage.dart';
import 'package:cic_wps/screens/homePage.dart';
import 'package:cic_wps/screens/registrationPage.dart';
import 'package:cic_wps/singleton/dbManager.dart';
import 'package:cic_wps/singleton/networkManager.dart';
import 'package:cic_wps/utilities/constants.dart';
import 'package:cic_wps/utilities/sapMessageType.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  static const routeName = '/LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pswController = TextEditingController();
  // String _idText;
  // String _pswText;
  final LocalAuthentication _auth = LocalAuthentication();
  Future<Map> _checkUserInfo;
  Future<bool> _canCheckBiometrics;
  Map<String, String> _authData;

  @override
  void initState() {
    super.initState();
    // _idText = "";
    // _pswText = "";
    _authData = {"id": "", "psw": ""};
    _checkUserInfo = _checkSavedUserInfo();
    _canCheckBiometrics = _checkBiometrics();
  }

  @override
  void dispose() {
    _idController.dispose();
    _pswController.dispose();
    super.dispose();
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
                  SizedBox(
                    height: 10,
                  ),
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
                  FutureBuilder(
                      future:
                          Future.wait([_checkUserInfo, _canCheckBiometrics]),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          var id = snapshot.data[0]["username"];
                          var password = snapshot.data[0]["password"];

                          if (snapshot.data[1] == false && id != null) {
                            //No Fast Login capability
                            _idController.text = id;
                            return _noAuthUi();
                          }

                          if (id != null && password != null) {
                            // Fast Login capability
                            _idController.text = id;
                            _pswController.text = password;
                            return _authUi(id);
                          }

                          if (id == null && password == null) {
                            //
                            _idController.text = "";
                            _pswController.text = "";
                            return _noAuthUi();
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column();
                        } else {
                          return _noAuthUi();
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
              // _idText = "";
              // _pswText = "";
              _idController.text = "";
              _pswController.text = "";
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
              _authData["psw"] = _pswController.text;
              _authData["id"] = _idController.text;
              // _authData["id"] = _idText;
              // _authData["psw"] = _pswText;
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
          controller: _idController,
          maxLength: 8,
          validator: (value) => value.isEmpty ? 'ID cant\' be empty' : null,
          style: TextStyle(color: Theme.of(context).accentColor),
          decoration: idInputDecoration(context),
          onSaved: (value) =>
              value.isNotEmpty ? _authData["id"] = value.toUpperCase() : null,
        ),
        TextFormField(
          // initialValue: _pswText,
          controller: _pswController,
          obscureText: true,
          maxLength: 15,
          validator: (value) =>
              value.isEmpty ? 'Password cant\'t be empty' : null,
          style: TextStyle(color: Theme.of(context).accentColor),
          decoration: pswInputDecoration(context),
          onSaved: (value) =>
              value.isNotEmpty ? _authData["psw"] = value : null,
        ),
        Center(
          child: FlatButton(
            onPressed: () => Navigator.of(context)
                .pushNamed(CredentialsRecoveryPage.routeName),
            child: Text(
              "Credential Recovery",
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
          onPressed: () =>
              Navigator.of(context).pushNamed(RegistrationPage.routeName),
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
          var responseUser = User.fromJson(jsonDecode(response.body));
          var message = SapReturnMessage.fromJson(jsonDecode(response.body));
          if (message.getCode == SapMessageType.E.value ||
              message.getCode == SapMessageType.W.value ||
              message.getCode == SapMessageType.O.value) {
            Navigator.pop(ctx);
            return message.returnSnackByMessage(ctx);
          } else {
            // if (user.password == _pswController.text) {
            await DbManager.insert('user', {
              'id': 0,
              'username': _authData["id"],
              'sUser': "",
              'password': _authData["psw"],
              'locationOfBelonging': responseUser.getIdLocation
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
