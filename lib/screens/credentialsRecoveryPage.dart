import 'dart:convert';

import 'package:cic_wps/models/sapReturnMessage.dart';
import 'package:cic_wps/models/snackBarMessage.dart';
import 'package:cic_wps/singleton/networkManager.dart';
import 'package:cic_wps/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class CredentialsRecoveryPage extends StatefulWidget {
  const CredentialsRecoveryPage({Key key}) : super(key: key);

  static const routeName = '/CredentialsRecoveryPage';

  @override
  _CredentialsRecoveryPageState createState() =>
      _CredentialsRecoveryPageState();
}

class _CredentialsRecoveryPageState extends State<CredentialsRecoveryPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _alreadyTapped = true;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        resizeToAvoidBottomInset: true,
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Seems like you forgot something...",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text("We need your IBM mail",
                      style: TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.w500,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => _validateMail(value),
                      style: TextStyle(color: Theme.of(context).accentColor),
                      decoration: mailInputDecoration(context),
                      onSaved: (value) => _emailController.text = value),
                  SizedBox(
                    height: 15,
                  ),
                  Text("The mail will be delivered within 10 minutes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        // fontWeight: FontWeight.w500,
                      )),
                  Visibility(
                    visible: _alreadyTapped,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            onTap: () => _sendCredentialRequest(context),
                            child: Icon(LineIcons.paper_plane,
                                color: Theme.of(context).accentColor),
                          ),
                        ]),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  String _validateMail(String mail) {
    if (_emailController.text.isEmpty) {
      return 'Mail field cant\'t be empty';
    } else if (!_emailController.text.toUpperCase().contains("@")) {
      return 'Mail is not valid';
    } else {
      return null;
    }
  }

  Future<void> _sendCredentialRequest(BuildContext ctx) async {
    if (_formKey.currentState.validate()) {
      startLoadingSpinner(ctx);
      try {
        var resp =
            await NetworkManager().getForCredentials(_emailController.text);
        if (resp.statusCode >= 200 && resp.statusCode <= 300) {
          var message = SapReturnMessage.fromJson(jsonDecode(resp.body));
          Navigator.pop(ctx);
          setState(() {
            _alreadyTapped = false;
          });
          return message.returnSnackByMessage(ctx);
        } else {
          Navigator.pop(ctx);
          SnackBarMessage.genericError(ctx, "Something went wrong!");
        }
      } catch (onError) {
        Navigator.pop(ctx);
        SnackBarMessage.genericError(ctx, onError.toString());
      }
    }
  }
}
