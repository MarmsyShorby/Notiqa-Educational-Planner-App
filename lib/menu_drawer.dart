import 'package:flutter/material.dart';
import 'account_information.dart';
import 'login.dart';

Drawer accountDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(currentAccountId ?? "Guest"),
          accountEmail: Text("${currentAccountId ?? 'guest'}@example.com"),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
          ),
          decoration: BoxDecoration(color: Colors.deepPurple),
        ),

        ListTile(
          leading: Icon(Icons.logout, color: Colors.red),
          title: Text("Logout", style: TextStyle(color: Colors.red)),
          onTap: () {
            logout(); // clear current user data
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Login()),
            );
          },
        ),

        const SizedBox(height: 20),
      ],
    ),
  );
}
