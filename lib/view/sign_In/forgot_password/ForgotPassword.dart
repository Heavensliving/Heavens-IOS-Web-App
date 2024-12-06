import 'package:flutter/material.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/core/widgets/CustomButton.dart';
import 'package:heavens_students/core/widgets/CustomTextformField.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatelessWidget {
  final String email;
  const ForgotPassword({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final TextEditingController email_controller =
        TextEditingController(text: email);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    var provider = context.watch<LoginController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                CircleAvatar(
                    radius: 100,
                    backgroundColor: ColorConstants.dark_red,
                    child: Center(
                      child: SizedBox(
                        height: 130,
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
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
                      errorText: context.watch<LoginController>().error_message,
                      controller: email_controller,
                      hintText: "Enter Email"),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Custombutton(
                    child: provider.isLoading
                        ? CircularProgressIndicator(
                            color: ColorConstants.primary_white,
                          )
                        : Text(
                            "Submit",
                            style: TextStyle(
                                color: ColorConstants.primary_white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        provider.forgotpsd(email_controller.text, context);
                      }
                    },
                    text: "Submit",
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
