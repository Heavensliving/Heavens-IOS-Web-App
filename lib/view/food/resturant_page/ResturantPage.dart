import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/core/widgets/CustomTextformField.dart';
import 'package:heavens_students/view/food/resturant_page/widgets/ItemCard.dart';

class ResturantPage extends StatefulWidget {
  const ResturantPage({super.key});

  @override
  State<ResturantPage> createState() => _ResturantPageState();
}

class _ResturantPageState extends State<ResturantPage> {
  TextEditingController search_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.primary_white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: search_controller,
                  hintText: "Search dishes",
                  suffixIcon: Icon(
                    Icons.search,
                    color: ColorConstants.primary_black.withOpacity(.5),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: ColorConstants.primary_black
                                  .withOpacity(.3))),
                      child: Row(
                        children: [
                          Icon(
                            Icons.eco,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Pure Veg",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: ColorConstants.primary_black
                                  .withOpacity(.3))),
                      child: Row(
                        children: [
                          Icon(
                            Icons.fastfood,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Non-Veg",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.separated(
                    // scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ItemCard(),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                    itemCount: 3)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
