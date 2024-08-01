import 'package:analytics_app/screens/login_screen.dart';
import 'package:analytics_app/utils/colors.dart';
import 'package:analytics_app/widgets/button_widget.dart';
import 'package:analytics_app/widgets/text_widget.dart';
import 'package:analytics_app/widgets/textfield_widget.dart';
import 'package:analytics_app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final number = TextEditingController();

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'Signup',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextFieldWidget(
                  hasValidator: false,
                  hint: 'Enter fullname',
                  borderColor: Colors.grey,
                  label: 'Fullname',
                  controller: name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a email';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFieldWidget(
                  inputType: TextInputType.number,
                  hasValidator: false,
                  hint: 'Enter contact number',
                  borderColor: Colors.grey,
                  label: 'Contact Number',
                  controller: number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a email';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFieldWidget(
                  hasValidator: false,
                  hint: 'Enter email',
                  borderColor: Colors.grey,
                  label: 'Email',
                  controller: email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a email';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    TextFieldWidget(
                      hasValidator: false,
                      hint: 'Enter password',
                      showEye: true,
                      borderColor: Colors.grey,
                      label: 'Password',
                      isObscure: true,
                      controller: password,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ButtonWidget(
                  label: 'Register',
                  onPressed: () {
                    box.write('name', name.text);

                    box.write('email', email.text);
                    box.write('password', password.text);

                    showToast('Account created succesfully!');
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: "Already have an account?",
                      fontSize: 12,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: TextWidget(
                        color: primary,
                        fontFamily: 'Bold',
                        text: "Login",
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
