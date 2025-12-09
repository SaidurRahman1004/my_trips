import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Core/constant.dart';
import 'package:email_validator/email_validator.dart';

import '../../widgets/CenterCircularProgressIndicator.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final TextEditingController _emailCtrler = TextEditingController();
  final TextEditingController _PassCtrler = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isSigninProgress = false;
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.trip_origin, size: 100, color: Colors.amber),
                SizedBox(height: 10),
                Text(
                  AppConst.AppName,
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Save your travel memories',
                  style: GoogleFonts.poppins(fontSize: 25, color: Colors.grey),
                ),
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Form(
                    key: _formkey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        Text(
                          'Login',
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailCtrler,
                          validator: (value) {
                            if (value == null || value
                                .trim()
                                .isEmpty) {
                              return 'Please enter your email';
                            } else if (!EmailValidator.validate(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: "Email Address",
                            hintText: 'Enter Email Adress',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _PassCtrler,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value
                                .trim()
                                .isEmpty) {
                              return 'Please enter your password';
                            } else if (value
                                .trim()
                                .length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: "Password",
                            hintText: 'Enter Your Valid Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: _agreeToTerms,
                              activeColor: Colors.amber,
                              onChanged: (bool? value) {
                                setState(() {});
                                _agreeToTerms = value ?? false;
                              },
                            ),
                            Expanded(
                              child: Text(
                                'Remember me', style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey,
                              ),),),
                          ],
                        ),

                        SizedBox(height: 30),
                        Visibility(
                          visible: _isSigninProgress == false,
                          replacement: CenterCircularProgressIndicator(),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: FilledButton(
                              onPressed: _onSignIn,
                              child: Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(onPressed: onForgetPassword, child: Text(
                            'Forgot your password?',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.blueAccent,
                            ),

                        )),

                        Divider(),
                        RichText(
                          text: TextSpan(
                            text: 'New users? ',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            children: [
                              TextSpan(
                                text: ' Register Now',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.amber,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onRouteSignIn,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSignIn() {}

  void _onRouteSignIn() {}

  void onForgetPassword() {
  }
}
