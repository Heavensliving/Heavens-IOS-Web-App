import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/core/widgets/CustomButton.dart';
import 'package:heavens_students/core/widgets/CustomTextformField.dart';
import 'package:heavens_students/view/sign_In/forgot_password/ForgotPassword.dart';
import 'package:heavens_students/view/sign_In/widgets/login_card.dart';
import 'package:provider/provider.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController EmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    if (kDebugMode) {
      EmailController.text = 'john@gmail.com';
      passwordController.text = 'Johndoe@123';
    }
    super.initState();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var prov = context.watch<LoginController>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .4,
                  ),
                  Text(
                    "Sign In",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Hi! Welcome back, you’ve been missed",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: ColorConstants.primary_black.withOpacity(.5)),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color:
                                ColorConstants.primary_black.withOpacity(.9)),
                      ),
                      CustomTextField(
                        controller: EmailController,
                        hintText: "Enter Email",
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the email address';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Enter a valid email address";
                          }
                          String trimmedValue = value.replaceAll(' ', '');
                          if (trimmedValue.isEmpty) {
                            return 'Text cannot be just spaces';
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Password",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color:
                                ColorConstants.primary_black.withOpacity(.9)),
                      ),
                      CustomTextField(
                        isPassword: true,
                        controller: passwordController,
                        hintText: "Enter Password",
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ForgotPassword(email: EmailController.text),
                              ));
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color:
                                  ColorConstants.primary_black.withOpacity(.5),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Custombutton(
                    text: "Sign In",
                    child: prov.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                            color: ColorConstants.primary_white,
                          ))
                        : Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        log("pressed");
                        await context.read<LoginController>().loginData(
                            EmailController.text,
                            passwordController.text,
                            context);
                        // context
                        //     .read<LoginController>()
                        //     .getStudentDetail(context);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) =>
                        //           BottomNavigation(initialIndex: 0),
                        //     ));
                      }
                    },
                  ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  // LoginCard(
                  //   onTap: () {},
                  //   text: "Register",
                  //   Maintext: "Don’t have an account ?",
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
