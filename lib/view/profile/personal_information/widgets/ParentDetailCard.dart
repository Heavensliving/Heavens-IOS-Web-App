import 'package:flutter/material.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/controller/profile_controller/ProfileController.dart';
import 'package:heavens_students/core/widgets/CustomButton.dart';
import 'package:heavens_students/core/widgets/CustomTextformField.dart';
import 'package:provider/provider.dart';

class ParentDetailCard extends StatefulWidget {
  final TabController tabController;
  const ParentDetailCard({super.key, required this.tabController});
  @override
  State<ParentDetailCard> createState() => _ParentDetailCardState();
}

class _ParentDetailCardState extends State<ParentDetailCard> {
  TextEditingController name_controller = TextEditingController();
  TextEditingController phone_controller = TextEditingController();
  TextEditingController occupation_controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  init() async {
    var prov = context.watch<LoginController>().studentDetailModel?.student;
    name_controller.text = prov?.parentName ?? "";
    occupation_controller.text = prov?.parentOccupation ?? "";
    phone_controller.text = prov?.parentNumber ?? "";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    init();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read<ProfileController>();
    var login_controller =
        context.watch<LoginController>().studentDetailModel?.student;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Guardian Name",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
                CustomTextField(
                  enabled:
                      login_controller!.profileCompletionPercentage == "100"
                          ? false
                          : true,
                  controller: name_controller,
                  hintText: "Enter Guardian Name",
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? 'Enter name'
                        : null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Guardian Phone Number",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
                CustomTextField(
                  enabled: login_controller.profileCompletionPercentage == "100"
                      ? false
                      : true,
                  maxLength: 10,
                  controller: phone_controller,
                  hintText: "Enter phone",
                  keyboardType: TextInputType.number,
                  prefix: Text("   +91 ",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the phone number';
                    }

                    RegExp regex = RegExp(r'^\d{10}$');
                    if (!regex.hasMatch(value)) {
                      return "Enter a valid phone number";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Occupation",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
                CustomTextField(
                  enabled: login_controller.profileCompletionPercentage == "100"
                      ? false
                      : true,
                  controller: occupation_controller,
                  hintText: "Enter Occupation",
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? 'Enter occupation'
                        : null;
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Custombutton(
                onTap: () async {
                  if (login_controller.profileCompletionPercentage == "100") {
                    widget.tabController.animateTo(2);
                  } else {
                    if (formKey.currentState!.validate()) {
                      var phone = phone_controller.text;
                      int phoneNumber = int.parse(phone);
                      await provider.addParentDetails(
                        name_controller.text,
                        phoneNumber,
                        occupation_controller.text,
                        "70",
                        widget.tabController,
                      );
                      context.read<LoginController>().getStudentDetail(context);
                    }
                  }
                },
                text: "Next",
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
