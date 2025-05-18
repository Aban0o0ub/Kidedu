import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksView extends StatelessWidget {
  const LinksView({super.key});

  final String _url = "https://youtu.be/5hG8e9jGeaA?si=jpLWW0zUanKugOOx";

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(_url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 25, left: 25, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Links:-",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color(0xff02457A),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _launchURL,
              child: Text(
                _url,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff02457A),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
