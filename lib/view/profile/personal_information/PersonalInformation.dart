import 'package:flutter/material.dart';
import 'package:heavens_students/controller/login_controller/LoginController.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/view/profile/personal_information/widgets/GeneralInformation.dart';
import 'package:heavens_students/view/profile/personal_information/widgets/ParentDetailCard.dart';
import 'package:heavens_students/view/profile/personal_information/widgets/PersonalInformationCard.dart';
import 'package:provider/provider.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  @override
  void initState() {
    context.read<LoginController>().getStudentDetail(context);
    tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        backgroundColor: ColorConstants.primary_white,
        appBar: AppBar(
          backgroundColor: ColorConstants.primary_white,
          centerTitle: true,
          title: Text(
            "Personal Information",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            // automaticIndicatorColorAdjustment: true,
            // isScrollable: true,
            controller: tabController,
            dividerColor: Colors.transparent,
            indicatorColor: ColorConstants.dark_red2,
            indicatorWeight: 3,
            labelColor: ColorConstants.dark_red2,
            unselectedLabelColor: ColorConstants.primary_black.withOpacity(.5),
            tabs: [
              Tab(text: "Personal Information"),
              Tab(text: "Parent Details"),
              Tab(text: "Education and Identification"),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            PersonalInformationCard(
              tabController: tabController,
            ),
            ParentDetailCard(
              tabController: tabController,
            ),
            GeneralInformation(
              tabController: tabController,
            ),
          ],
        ),
      ),
    );
  }
}
