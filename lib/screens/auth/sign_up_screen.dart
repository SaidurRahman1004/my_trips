import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Core/constant.dart';
import 'package:email_validator/email_validator.dart';
import '../../widgets/CenterCircularProgressIndicator.dart';
import '../../widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameCtrler = TextEditingController();
  final TextEditingController _emailCtrler = TextEditingController();
  final TextEditingController _PassCtrler = TextEditingController();
  final TextEditingController _ConfirmPassCtrler = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isSignupProgress = false;
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
                const Icon(Icons.trip_origin, size: 100, color: Colors.amber),
                const SizedBox(height: 10),
                Text(
                  AppConst.AppName,
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Start your travel journey',
                  style: GoogleFonts.poppins(fontSize: 25, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formkey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        Text(
                          'Create a new account',
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          'Start saving your travel memories',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _nameCtrler,
                          lableText: "Full Name",
                          hintText: 'Enter Your Full Name',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Your Name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _emailCtrler,
                          lableText: "Email Address",
                          hintText: 'Enter Email Adress',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
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
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _PassCtrler,
                          lableText: "Password",
                          hintText: 'Create Strong Password',
                          icon: Icons.lock,
                          // Changed from Icons.person
                          obscureText: true,
                          isPassword: true,
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
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _ConfirmPassCtrler,
                          lableText: "Confirm Password",
                          hintText: 'Re-Enter Password',
                          icon: Icons.lock,
                          obscureText: true,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value
                                .trim()
                                .isEmpty) {
                              return 'Please re-enter your password';
                            }
                            if (value != _PassCtrler.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
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
                              child: RichText(
                                text: TextSpan(
                                  text: 'I agree to the ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' Terms of Use and Privacy Policy',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.amber,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = _onRouteSignUp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Visibility(
                          visible: _isSignupProgress == false,
                          replacement:  CenterCircularProgressIndicator(),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: FilledButton(
                              onPressed: _onSignUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: Text(
                                'Create an account',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            text: 'Already have an account?',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            children: [
                              TextSpan(
                                text: ' Sign In',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.amber,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onRouteSignUp,
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

  void _onSignUp() {}

  void _onRouteSignUp() {}
}