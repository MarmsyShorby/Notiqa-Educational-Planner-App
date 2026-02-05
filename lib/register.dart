import 'package:flutter/material.dart';
import 'account_information.dart';

class Register extends StatefulWidget {
  final AccountInformation account;
  final Function(AccountInformation) onRegister;
  const Register({super.key, required this.account, required this.onRegister});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController confPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Create your Notiqa Account",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),

              Text(
                "Interesting Tagline",
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 12),

              TextField(
                decoration: InputDecoration(label: Text("Username")),
                controller: username,
              ),
              SizedBox(height: 12),

              TextField(
                decoration: InputDecoration(label: Text("Email Address")),
                controller: email,
              ),
              SizedBox(height: 12),

              TextField(
                decoration: InputDecoration(label: Text("Password")),
                controller: password,
              ),
              SizedBox(height: 12),

              TextField(
                decoration: InputDecoration(label: Text("Confirm Password")),
                controller: confPassword,
              ),
              SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  if (username.text.isEmpty ||
                      email.text.isEmpty ||
                      password.text.isEmpty) {
                    print("All fields must be filled out!");
                    return;
                  }

                  if (password.text != confPassword.text) {
                    print("Passwords not matching!");
                    return;
                  }

                  final registeredAccont = AccountInformation(
                    username: username.text,
                    email: email.text,
                    password: password.text,
                  );

                  widget.onRegister(registeredAccont);
                },
                child: Text("Register"),
              ),
              SizedBox(height: 24),

              Row(
                children: [
                  Text("Already have an Account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Log In"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
