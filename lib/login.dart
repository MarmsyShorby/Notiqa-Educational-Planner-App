import 'package:flutter/material.dart';
import 'select_note.dart';
import 'register.dart';
import 'account_information.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  bool hidePassword = true;
  bool showError = false;

  @override //Frees allocated resources
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome to Notiqa", style: TextStyle(fontSize: 40)),

              SizedBox(height: 32),
              CircleAvatar(
                backgroundColor: Color.fromARGB(255, 201, 201, 201),
                maxRadius: 70,
                child: Icon(Icons.person, size: 100),
              ),
              SizedBox(height: 12),
              TextField(
                controller: userController,
                decoration: InputDecoration(label: Text("Username")),
              ),

              SizedBox(height: 12),
              TextField(
                controller: passwordController,

                obscureText: hidePassword, //boolean toggle to pass visibility
                decoration: InputDecoration(
                  label: Text("Password"),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                      hidePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: showError,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Username or Password is incorrect!",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final username = userController.text;
                  final password = passwordController.text;

                  if (username == "1" && password == "2") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectNote(),
                      ),
                    );
                    setState(() {
                      showError = false;
                    });
                  } else {
                    if (username.isEmpty && password.isEmpty) return;

                    setState(() {
                      showError = true;
                    });
                  }
                },
                child: Text("Log in"),
              ),

              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't Have an Account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      );
                    },
                    child: Text("Register Now"),
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
