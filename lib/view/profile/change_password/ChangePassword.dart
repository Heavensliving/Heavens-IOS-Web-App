import 'package:flutter/material.dart';
import 'package:heavens_students/core/widgets/CustomButton.dart';
import 'package:heavens_students/core/widgets/CustomTextformField.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController current_psd_controller = TextEditingController();
  TextEditingController new_psd_controller = TextEditingController();
  TextEditingController confirm_psd_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            // fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current Password",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
                CustomTextField(
                    controller: current_psd_controller,
                    hintText: "Enter Current Password"),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "New Password",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
                CustomTextField(
                    controller: new_psd_controller,
                    hintText: "Enter New Password"),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Confrim New Password",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
                CustomTextField(
                    controller: confirm_psd_controller,
                    hintText: "Enter Confrim Password"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Custombutton(
                padding: EdgeInsets.symmetric(vertical: 5),
                text: "UPDATE",
              ),
            )
          ],
        ),
      ),
    );
  }
}
