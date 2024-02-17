import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haiku/utilities/constants/app_texts.dart';
import 'package:haiku/utilities/helpers/go.dart';
import 'package:haiku/utilities/helpers/pager.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Account Settings',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              // Navigate to account settings screen
            },
          ),
          ListTile(
            title: const Text('Change Bio'),
            onTap: () {
              // Navigate to change bio screen
            },
          ),
          ListTile(
            title: const Text('Change Password'),
            onTap: () {
              // Navigate to change password screen
            },
          ),
          ListTile(
            title: const Text('Delete Account',
                style: TextStyle(color: Colors.red)),
            onTap: () {
              // Navigate to delete account screen
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Support',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              // Navigate to support screen
            },
          ),
          ListTile(
            title: const Text('Contact Us'),
            onTap: () {
              // Navigate to contact us screen
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('About',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              // Navigate to about screen
            },
          ),
          ListTile(
            title: const Text('Terms of Service'),
            onTap: () {
              // Navigate to terms of service screen
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () {
              // Navigate to privacy policy screen
            },
          ),
          const ListTile(
            title: Text('App Version 1.0.16',
                style: TextStyle(color: Colors.grey)),
          ),
          const Divider(),
          ListTile(
            title: const Text('App Settings',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              // Navigate to app settings screen
            },
          ),
          ListTile(
            title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            onTap: () {
              FirebaseAuth.instance.signOut().then((_) {
                Go.closeAll(context, Pager.home);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User Logged Out')),
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
