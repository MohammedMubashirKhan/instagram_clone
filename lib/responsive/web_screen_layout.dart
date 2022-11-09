import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Link(
              uri: Uri.parse(
                  "https://drive.google.com/file/d/12F7nGhcvd6RYLrw1jCCcimGgwYuT0o-v/view?usp=sharing"),
              target: LinkTarget.blank,
              builder: (context, followLink) => InkWell(
                onTap: followLink,
                child: Text(
                    "Click and Download the android apk for Inastagram clone"),
              ),
            ),
            Text("Or redude the width of the window")
          ],
        ),
      ),
    );
  }
}
