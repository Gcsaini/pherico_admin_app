import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_page;
import 'package:pherico_admin_app/config/my_color.dart';
import 'package:pherico_admin_app/resources/auth_methods.dart';
import 'package:pherico_admin_app/screens/home.dart';
import 'package:pherico_admin_app/widgets/auth/auth_card.dart';
import 'package:pherico_admin_app/widgets/auth/auth_input.dart';
import 'package:pherico_admin_app/widgets/auth/auth_submit_button.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  String error = '';
  final GlobalKey<FormState> _globalKey = GlobalKey();
  Map<String, String> loginData = {'email': '', 'password': ''};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          key: UniqueKey(),
          opacity: 0.3,
          child: Stack(
            children: [
              AuthCard(
                form: authCard(context),
                title: 'Login',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget authCard(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          error.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.red),
                    overflow: TextOverflow.visible,
                  ),
                )
              : Container(),
          AuthInput(
            label: 'Enter Email',
            keyName: 'email',
            hint: 'Enter Email',
            prefixIcon: const Icon(Icons.email),
            onValidate: (onValidate) {
              return null;
            },
            onSaved: (onSavedVal) {
              loginData['email'] = onSavedVal;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          AuthInput(
            label: 'Enter Password',
            keyName: 'password',
            hint: 'Enter Password',
            type: 'password',
            prefixIcon: const Icon(Icons.key),
            hidePassword: hidePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              color: greyColor,
              icon:
                  Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
            ),
            onValidate: (onValidate) {
              return null;
            },
            onSaved: (onSaved) {
              loginData['password'] = onSaved;
            },
          ),
          const SizedBox(
            height: 22,
          ),
          AuthSubmitButton(
            buttonName: 'Login',
            onSubmit: () async {
              if (validateAndSave()) {
                setState(() {
                  error = '';
                });
                if (loginData['email']!.length < 12) {
                  setState(() {
                    error = 'Please Enter Email';
                  });
                } else if (!loginData['email']!.contains('@')) {
                  setState(() {
                    error = 'Please Enter Valid Email';
                  });
                } else if (loginData['password']!.length < 6) {
                  setState(() {
                    error = 'Please Enter Valid Password';
                  });
                } else {
                  setState(() {
                    error = '';
                    isApiCallProcess = true;
                  });
                  String res = await AuthMethods().loginUser(
                      email: loginData['email']!,
                      password: loginData['password']!);
                  if (res != 'success') {
                    setState(() {
                      error = res.split(']')[1];
                      isApiCallProcess = false;
                    });
                  } else {
                    setState(() {
                      error = '';
                      isApiCallProcess = false;
                    });
                    get_page.Get.to(() => const Home(),
                        transition: get_page.Transition.leftToRight);
                  }
                }
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = _globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
