import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterapp/bottom_nav.dart';
import 'package:flutterapp/main.dart';
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
  final emailController = TextEditingController();
  bool hidePassword = true;
  bool showError = false;

  List<AccountInformation> accounts = [];

  @override //Frees allocated resources
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    final username = userController.text;
    final password = passwordController.text;

    AccountInformation? account;
    try {
      account = MyApp.accounts.firstWhere(
        (ac) => ac.username == username && ac.password == password,
      );
    } catch (e) {
      account = null;
    }

    if (account != null) {
      showError = false;
      Navigator.push(context, MaterialPageRoute(builder: (_) => BottomNav()));
    } else {
      setState(() {
        showError = true;
      });
    }
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                SizedBox(height: 20),

                Visibility(
                  visible: showError,
                  child: Column(
                    children: [
                      Text(
                        "Username or Password is incorrect!",
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    final username = userController.text;
                    final password = passwordController.text;

                    if (username.isEmpty || password.isEmpty) return;

                    _login(context);
                  },
                  child: Text("Log in"),
                ),
                SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't Have an Account?"),
                    TextButton(
                      onPressed: () async {
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
      ),
    );
  }
}
