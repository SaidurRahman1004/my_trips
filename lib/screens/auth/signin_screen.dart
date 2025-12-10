import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_trips/widgets/CenterCircularProgressIndicator.dart';
import '../../Core/constant.dart';
import 'package:email_validator/email_validator.dart';
import '../../services/auth_service.dart';
import '../../widgets/custo_snk.dart';
import '../../widgets/custom_text_field.dart';

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
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.trip_origin, size: 80, color: Colors.amber),
                const SizedBox(height: 10),
                Text(
                  AppConst.AppName,
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Save your travel memories',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 25),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
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
                          'Login',
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                            letterSpacing: 2,
                          ),
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
                          hintText: 'Enter Your Valid Password',
                          icon: Icons.lock,
                          // Changed from Icons.person for better context
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
                        const SizedBox(height: 15),
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
                                'Remember me',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Visibility(
                          visible: _isSigninProgress == false,
                          replacement:  CenterCircularProgressIndicator(),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: FilledButton(
                              onPressed: _onSignIn,
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
                                'Login',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                            onPressed: onForgetPassword,
                            child: Text(
                              'Forgot your password?',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.blueAccent,
                              ),
                            )),
                        const Divider(),
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

  void _onSignIn() {
    if (_formkey.currentState!.validate()) {
      _signIn();
    }

  }

  void _onRouteSignIn() {
    context.go('/signup');
  }

  void onForgetPassword() {}

  Future<void> _signIn() async{
    setState(() {
      _isSigninProgress = true;
    });

    try{
      final loginUser = await  _authService.loginWithEmailAndPassword(email: _emailCtrler.text.trim(), password: _PassCtrler.text);
      if (!mounted) return;
      if(loginUser != null){
        mySnkmsg('Login Successfully', context);
        context.go('/home');
      }else{
        mySnkmsg('Something Went Wrong', context);
      }
    }catch(e){
      if(!mounted){
        mySnkmsg(e.toString(), context);
      }
    }finally{
      if(mounted){
        setState(() {
          _isSigninProgress = false;
        });
      }

    }
  }
}