// ignore_for_file: use_build_context_synchronously

import 'package:file_manager/Providers/AuthProvider/auth_provider.dart';
import 'package:file_manager/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(15),
              // spacing: 15,
              children: [
                SizedBox(height: 100),
                SizedBox(
                  height: 200,
                  child: Image.asset("assets/icons/logo2.png"),
                ),
                // SizedBox(height: 10),
                Text(
                  "Login Here",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: "Email",
                    label: Text("Your Email"),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Your Email";
                    }
                    if (!value.contains("@")) {
                      return "Please Enter Valid Email Address";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Consumer<AuthProvider>(
                  builder: (context, provider, child) {
                    return TextFormField(
                      controller: password,
                      obscureText: provider.visibiltyPassword,
                      decoration: InputDecoration(
                        hintText: "Your Password",
                        label: Text("Enter your password"),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            provider.showHidePassword();
                          },
                          icon: Icon(
                            provider.visibiltyPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter your password";
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 15),
                Consumer<AuthProvider>(
                  builder: (context, provider, child) {
                    return provider.loading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                bool success = await provider.login(
                                  email.text,
                                  password.text,
                                  context
                                );
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Login Successfull",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  await Future.delayed(Duration(seconds: 2));
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RouteHelper.home,
                                    (route) => false,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Invalid Ceredentials",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              }
                            },
                            
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.indigo,
                            ),
                            child: Text("Login"),
                          );
                  },
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(),
                      child: Text(
                        "Forgot your password",
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteHelper.register);
                  },
                  child: Text(
                    "Don't have an account? Register Here",
                    style: TextStyle(color: Colors.indigo),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -120,
            right: -120,

            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigo.withAlpha(128),
              ),
            ),
          ),
          Positioned(
            top: -60,
            right: -60,

            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
