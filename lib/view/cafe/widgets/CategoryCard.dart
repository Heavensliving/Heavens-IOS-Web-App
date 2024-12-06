import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';

class CategoryCard extends StatefulWidget {
  final bool? isSelected;
  final String category_name;
  const CategoryCard({super.key, this.isSelected, required this.category_name});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
          color: widget.isSelected == true
              ? ColorConstants.dark_red
              : ColorConstants.primary_white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorConstants.dark_red)),
      child: Center(
        child: Text(
          widget.category_name,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: widget.isSelected == true
                  ? ColorConstants.primary_white
                  : ColorConstants.dark_red),
        ),
      ),
    );
  }
}
