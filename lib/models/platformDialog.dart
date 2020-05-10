import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

void showDialogByPlatform(
    BuildContext context, Function func, DateTime weekEnd) {
  showPlatformDialog(
    context: context,
    builder: (_) => PlatformAlertDialog(
      title: Text("Pay Attention!", style: TextStyle(color: Colors.red)),
      content: Text(
        "You will convalidate the week that ends on the $weekEnd",
      ),
      actions: <Widget>[
        PlatformDialogAction(
          child: PlatformText(
            "Upload",
          ),
          onPressed: () {
            func(context);

            Navigator.of(context).pop();
          },
        ),
        PlatformDialogAction(
          child: PlatformText(
            "Cancel",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      ios: (_) => CupertinoAlertDialogData(
        content: Text(
          "You will convalidate the week that ends on the $weekEnd",
        ),
      ),
    ),
  );
}
