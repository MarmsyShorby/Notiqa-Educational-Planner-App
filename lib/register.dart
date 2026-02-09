import 'package:flutter/material.dart';
import 'package:flutterapp/main.dart';
import 'account_information.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final confPasswordController = TextEditingController();
  final emailController = TextEditingController();
  bool showError = false;
  bool successRegister = false;
  bool hidePass = true;
  bool hideConfPass = true;
  String errorMessage = "";

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Create your Notiqa Account",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),

                //TAGLINE=====================
                Text(
                  "Less Juggling, More Doing",
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 12),

                TextField(
                  decoration: InputDecoration(label: Text("Username")),
                  controller: userController,
                ),
                SizedBox(height: 12),

                TextField(
                  decoration: InputDecoration(label: Text("Email Address")),
                  controller: emailController,
                ),
                SizedBox(height: 12),

                TextField(
                  decoration: InputDecoration(
                    label: Text("Password"),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePass = !hidePass;
                        });
                      },
                      icon: Icon(
                        hidePass ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  controller: passwordController,
                  obscureText: hidePass,
                ),
                SizedBox(height: 12),

                TextField(
                  decoration: InputDecoration(
                    label: Text("Confirm Password"),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hideConfPass = !hideConfPass;
                        });
                      },
                      icon: Icon(
                        hideConfPass ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  controller: confPasswordController,
                  obscureText: hideConfPass,
                ),
                SizedBox(height: 20),

                Visibility(
                  visible: showError,
                  child: Column(
                    children: [
                      Text(errorMessage, style: TextStyle(color: Colors.red)),
                      SizedBox(height: 20),
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    if (userController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      print("All fields must be filled out!");

                      setState(() {
                        errorMessage = "All fields must be filled out!";
                        showError = true;
                      });
                      return;
                    }

                    final alrExistsUser = MyApp.accounts.any(
                      (ac) => ac.username == userController.text,
                    );

                    final alrExistsEmail = MyApp.accounts.any(
                      (ac) => ac.email == emailController.text,
                    );

                    if (alrExistsUser) {
                      //show error
                      print("Username already exists!");

                      setState(() {
                        errorMessage = "Username already exists!";
                        showError = true;
                      });
                      return;
                    }

                    if (alrExistsEmail) {
                      //show error
                      print("Email already exists!");

                      setState(() {
                        errorMessage = "Email Address already in use!";
                        showError = true;
                      });
                      return;
                    }

                    if (!emailController.text.contains("@") ||
                        !emailController.text.contains(".")) {
                      setState(() {
                        errorMessage = "Please Enter a valid Email Address!";
                        showError = true;
                      });
                      return;
                    }

                    if (passwordController.text !=
                        confPasswordController.text) {
                      print("Passwords not matching!");

                      setState(() {
                        errorMessage = "Passwords are not matching!";
                        showError = true;
                      });
                      return;
                    }

                    //WHEN SUCCESSFUL==================
                    final registeredAccont = AccountInformation(
                      username: userController.text,
                      email: emailController.text,
                      password: confPasswordController.text,
                    );

                    MyApp.accounts.add(registeredAccont);

                    setState(() {
                      showError = false;
                      //showSucessfulRegister
                    });

                    Navigator.pop(context);
                  },
                  child: Text("Register"),
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}
