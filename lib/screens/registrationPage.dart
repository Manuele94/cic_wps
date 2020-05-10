import 'dart:convert';

import 'package:cic_wps/models/sapReturnMessage.dart';
import 'package:cic_wps/models/snackBarMessage.dart';
import 'package:cic_wps/singleton/networkManager.dart';
import 'package:cic_wps/utilities/constants.dart';
import 'package:cic_wps/utilities/sapMessageType.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key key}) : super(key: key);
  static const routeName = '/RegistrationPage';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tempPswController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _newPswController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _authData;

  // List<Step> _steps = [];
  int _currentStep;
  int _stepsLenght;

  @override
  void dispose() {
    _emailController.dispose();
    _tempPswController.dispose();
    _idController.dispose();
    _newPswController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _currentStep = 0;
    _stepsLenght = 0;
    _authData = {"id": "", "psw": ""};

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Welcome! Let's get started.",
          style: TextStyle(
            color: Theme.of(context).textTheme.headline5.color,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Form(
          key: _formKey,
          child: Theme(
            data: ThemeData(
                canvasColor: Theme.of(context).scaffoldBackgroundColor),
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              steps: _createSteps(),
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _currentStep == 1 // this is the last step
                          ? RaisedButton.icon(
                              icon: Icon(
                                LineIcons.save,
                                color: Colors.white,
                              ),
                              onPressed: () =>
                                  _temporaryPswCheckBeforeStepForward(context),
                              label: Text('Save',
                                  style: TextStyle(color: Colors.white)),
                              color: Theme.of(context).accentColor,
                            )
                          : RaisedButton.icon(
                              icon: Icon(
                                LineIcons.arrow_right,
                                color: Colors.white,
                              ),
                              onPressed: () =>
                                  _emailCheckBeforeStepForward(context),
                              label: Text('Continue',
                                  style: TextStyle(color: Colors.white)),
                              color: Theme.of(context).accentColor,
                            ),
                      FlatButton.icon(
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Back',
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline5.color),
                        ),
                        onPressed: _stepBackward,
                      )
                    ],
                  ),
                );
              },
            ),
          )),
    );
  }

  void _stepForward() {
    _emailController.text = "@IBM.COM";
    setState(() {
      if (_currentStep < _stepsLenght - 1) {
        _currentStep++;
      }
    });
  }

  Future<void> _emailCheckBeforeStepForward(BuildContext ctx) async {
    if (_formKey.currentState.validate()) {
      startLoadingSpinner(ctx);
      try {
        var response =
            await NetworkManager().getForRegistration(_emailController.text);
        if (response.statusCode >= 200 && response.statusCode <= 300) {
          var message = SapReturnMessage.fromJson(jsonDecode(response.body));
          if (message.getCode == SapMessageType.E.value ||
              message.getCode == SapMessageType.W.value) {
            Navigator.pop(ctx);
            message.returnSnackByMessage(ctx);
          } else {
            setState(() {
              if (_currentStep < _stepsLenght - 1) {
                _currentStep++;
              }
            });
            Navigator.pop(ctx);
            message.returnSnackByMessage(ctx);
          }
        } else {
          Navigator.pop(ctx);
          SnackBarMessage.genericError(ctx, "Something went wrong!");
        }
      } catch (e) {
        Navigator.pop(ctx);
        SnackBarMessage.genericError(ctx, e.toString());
      }
    }
  }

  Future<void> _temporaryPswCheckBeforeStepForward(BuildContext ctx) async {
    if (_formKey.currentState.validate()) {
      _authData["id"] = _idController.text.toUpperCase();
      _authData["psw"] = _tempPswController.text;
      startLoadingSpinner(ctx);
      try {
        var response = await NetworkManager().getForLogin(_authData);
        if (response.statusCode >= 200 && response.statusCode <= 300) {
          var message = SapReturnMessage.fromJson(jsonDecode(response.body));
          if (message.getCode == SapMessageType.E.value ||
              message.getCode == SapMessageType.W.value) {
            Navigator.pop(ctx);
            return message.returnSnackByMessage(ctx);
          } else if (message.getCode == SapMessageType.X.value) {
            _authData["psw"] = _newPswController.text;
            var response = await NetworkManager().postForPswUpdate(_authData);
            var message = SapReturnMessage.fromJson(jsonDecode(response.body));
            Navigator.pop(ctx);
            return message.returnSnackByMessage(ctx);
          }
        }
      } catch (error) {
        Navigator.pop(ctx);
        SnackBarMessage.genericError(ctx, "Something goes wrong!");
      }
    }
  }

  void _stepBackward() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  String _validateMail(String mail) {
    if (_emailController.text.isEmpty) {
      return 'Mail field cant\'t be empty';
    } else if (!_emailController.text.toUpperCase().contains("@IBM.COM") &&
        !_emailController.text.toUpperCase().contains("@IT.IBM.COM")) {
      return 'Mail must have an IBM domain';
    } else {
      return null;
    }
  }

  List<Step> _createSteps() {
    final List<Step> _localSteps = [
      //STEP 1 - INOLTRO EMAIL
      Step(
          isActive: _currentStep == 0 ? true : false,
          title: Text("First Step",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              )),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FittedBox(
                child: Row(
                  children: <Widget>[
                    Text("If you already had your temporary Password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          // fontWeight: FontWeight.w500,
                        )),
                    FlatButton(
                      onPressed: _stepForward,
                      child: Text("Go Forward",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).accentColor,
                            // fontWeight: FontWeight.w500,
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                  controller: _emailController,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => _validateMail(value),
                  style: TextStyle(color: Theme.of(context).accentColor),
                  decoration: mailInputDecorationReg(context),
                  onChanged: (value) => _emailController.text = value),
              SizedBox(height: 5),
              Text(
                  "You will receive an email with your temporary password needed for the next step.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey
                      // fontWeight: FontWeight.w500,
                      )),
            ],
          )),
      //STEP 2 - DEFINIZIONE PASSWORD

      Step(
          isActive: _currentStep == 1 ? true : false,
          title: Text("Second Step",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              )),
          content: Column(
            children: [
              TextFormField(
                  controller: _idController,
                  textAlign: TextAlign.left,
                  validator: (value) =>
                      value.isEmpty ? 'ID cant\' be empty' : null,
                  style: TextStyle(color: Theme.of(context).accentColor),
                  decoration: idInputDecoration(context),
                  onChanged: (value) => _idController.text = value),
              SizedBox(height: 15),
              TextFormField(
                  controller: _tempPswController,
                  textAlign: TextAlign.left,
                  // validator: (value) => _validateMail(value),
                  style: TextStyle(color: Theme.of(context).accentColor),
                  decoration: temporaryPswInputDecoration(context),
                  onChanged: (value) => _tempPswController.text = value),
              SizedBox(height: 5),
              Text(
                  "You had this password by mail. It will be valid only for 15 minutes.\nIf it expires, start again the process.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey
                      // fontWeight: FontWeight.w500,
                      )),
              SizedBox(height: 10),
              TextFormField(
                  controller: _newPswController,
                  textAlign: TextAlign.left,
                  // validator: (value) => _validateMail(value),
                  style: TextStyle(color: Theme.of(context).accentColor),
                  decoration: pswInputDecoration(context),
                  onChanged: (value) => _newPswController.text = value),
              SizedBox(height: 5),
              Text("This will be your password for daily use.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey
                      // fontWeight: FontWeight.w500,
                      )),
            ],
          ))
    ];

    _stepsLenght = _localSteps.length;

    return _localSteps;
  }
}
