import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/pager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final Uri termsUrl = Uri.parse(AppTexts.urlTermsOfService);
  final Uri privacyUrl = Uri.parse(AppTexts.urlPrivacyPolicy);

  @override
  Widget build(BuildContext context) {
    Future<void> _launchUrl(Uri uri) async {
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
    }

    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'nasir.hasanov55@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Haiku Support Request',
      }),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.settings),
      ),
      body: ListView(
        children: <Widget>[
          const ListTile(
            title: Text(AppTexts.accountSettings,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text(AppTexts.changeBio),
            onTap: () {
              Go.to(context, Pager.changeBio);
            },
          ),
          ListTile(
            title: const Text(AppTexts.changePassword),
            onTap: () {
              Go.to(context, Pager.changePassword);
            },
          ),
          ListTile(
            title: const Text(AppTexts.deleteAccount,
                style: TextStyle(color: Colors.red)),
            onTap: () {
              Go.to(context, Pager.deleteAccount);
            },
          ),
          const Divider(),
          const ListTile(
            title: Text(AppTexts.support,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text(AppTexts.contactUs),
            onTap: () {
              _launchUrl(emailLaunchUri);
            },
          ),
          const Divider(),
          const ListTile(
            title: Text(AppTexts.about,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text(AppTexts.termsOfService),
            onTap: () {
              _launchUrl(termsUrl);
            },
          ),
          ListTile(
            title: const Text(AppTexts.privacyPolicy),
            onTap: () {
              _launchUrl(privacyUrl);
            },
          ),
          FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                return  ListTile(
                  title: Text('${AppTexts.appVersion} ${snapshot.data?.version}',
                      style: const TextStyle(color: Colors.grey)),
                );
              }),
          const Divider(),
          const ListTile(
            title: Text(AppTexts.appSettings,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text(AppTexts.signOut, style: TextStyle(color: Colors.red)),
            onTap: () {
              FirebaseAuth.instance.signOut().then((_) {
                Go.closeAll(context, Pager.home);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppTexts.userLoggedOut)),
                );
              }).catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AppTexts.anErrorOccurred)),
                );
                Go.back(context);
              });
            },
          ),
        ],
      ),
    );
  }
}
