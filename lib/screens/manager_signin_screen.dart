import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rim/constants.dart';
import 'package:rim/custom_widgets/custom_button.dart';
import 'package:rim/screens/forgot_password_screen.dart';
import 'package:rim/screens/home_screen.dart';
import 'package:rim/screens/verify_email_screen.dart';
import 'package:rim/services/shared_preferences_repository.dart';
import 'package:rim/size_config.dart';

class ManagerSignInScreen extends StatefulWidget {
  static const String id = 'manager_signin_screen';

  const ManagerSignInScreen({Key? key}) : super(key: key);

  @override
  State<ManagerSignInScreen> createState() => _ManagerSignInScreenState();
}

class _ManagerSignInScreenState extends State<ManagerSignInScreen> {
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';
  String _errorText = '';
  bool isLoading = false;

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        dismissible: false,
        color: Colors.grey.shade700,
        progressIndicator: const CircularProgressIndicator(
          color: Colors.black,
        ),
        child: PopScope(
          canPop: !isLoading,
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 4 * SizeConfig.widthMultiplier!,
                vertical: 2 * SizeConfig.heightMultiplier!,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_sharp),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: Text(
                      'Manager Sign In',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.textMultiplier! * 4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Text(' '),
                  ),
                  SizedBox(
                    height: 12 * SizeConfig.heightMultiplier!,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        style: TextStyle(
                          fontSize: 1.4 * SizeConfig.textMultiplier!,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) {
                          _email = val;
                        },
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            fontSize: 1.4 * SizeConfig.textMultiplier!,
                            color: const Color(0xffbdbdbd),
                          ),
                          filled: true,
                          fillColor: const Color(0xfff6f6f6),
                          border: kOutlineBorder,
                          enabledBorder: kOutlineBorder,
                          focusedBorder: kOutlineBorder,
                        ),
                      ),
                      SizedBox(
                        height: 1.6 * SizeConfig.heightMultiplier!,
                      ),
                      TextField(
                        style: TextStyle(
                          fontSize: 1.4 * SizeConfig.textMultiplier!,
                        ),
                        obscuringCharacter: '*',
                        obscureText: _obscureText,
                        onChanged: (val) {
                          _password = val;
                        },
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontSize: 1.4 * SizeConfig.textMultiplier!,
                            color: const Color(0xffbdbdbd),
                          ),
                          filled: true,
                          fillColor: const Color(0xfff6f6f6),
                          border: kOutlineBorder,
                          enabledBorder: kOutlineBorder,
                          focusedBorder: kOutlineBorder,
                          suffix: GestureDetector(
                            onTap: _toggleObscure,
                            child: Text(
                              _obscureText ? 'Show' : 'Hide',
                              style: TextStyle(
                                color: const Color(0xff5db075),
                                fontSize: 1.4 * SizeConfig.textMultiplier!,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _errorText.isNotEmpty,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.heightMultiplier! * 4),
                          child: Text(
                            _errorText,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5 * SizeConfig.heightMultiplier!,
                      ),
                      CustomButton(
                        backgroundColor: const Color(0xff5db075),
                        text: 'Sign In',
                        onPressed: () async {
                          setState(() {
                            _errorText = '';
                            isLoading = true;
                          });
                          try {
                            await _auth.signInWithEmailAndPassword(
                                email: _email, password: _password);
                            _auth.currentUser!.getIdToken().then((value) {
                              SharedPreferencesRepository().save(
                                  SharedPreferencesRepository.accessTokenKey,
                                  value);
                            });
                            if (context.mounted) {
                              if (_auth.currentUser!.emailVerified) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  HomeScreen.id,
                                  (route) => false,
                                );
                              } else {
                                final user = FirebaseAuth.instance.currentUser;
                                await user!.sendEmailVerification();
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    VerifyEmailScreen.id,
                                    (route) => false,
                                  );
                                }
                              }
                            }
                            setState(() {
                              isLoading = false;
                            });
                          } catch (e) {
                            setState(() {
                              _errorText = e.toString();
                              _errorText = _errorText.replaceAll(
                                  RegExp('\\[.*?\\]'), '');
                              isLoading = false;
                            });
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(ForgotPasswordScreen.id);
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 1.5 * SizeConfig.textMultiplier!,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
