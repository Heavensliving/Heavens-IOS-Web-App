import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';

class ImageSlider extends StatefulWidget {
  final List imageList;
  final bool? isCafe;
  const ImageSlider({super.key, required this.imageList, this.isCafe});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  Timer? timer;
  late int selectedPage = 0;
  final PageController pageController = PageController();
  late List discountOffers;

  @override
  void initState() {
    log("image list--${widget.imageList.length}");
    super.initState();
    discountOffers = widget.imageList;
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (selectedPage < discountOffers.length - 1) {
        selectedPage++;
      } else {
        selectedPage = 0;
      }
      pageController.animateToPage(
        selectedPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                selectedPage = index;
              });
            },
            itemCount: discountOffers.length,
            itemBuilder: (context, index) {
              return customCard(index);
            },
          ),
        ),
        SizedBox(height: 10),
        widget.isCafe == true || widget.imageList.length == 1
            ? SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(discountOffers.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: selectedPage == index ? 10 : 7,
                    height: selectedPage == index ? 10 : 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectedPage == index
                          ? ColorConstants.dark_red2
                          : ColorConstants.primary_black.withOpacity(0.4),
                    ),
                  );
                }),
              ),
      ],
    );
  }

  Widget customCard(final index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(discountOffers[index]), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              ColorConstants.dark_red2,
              const Color(0xffFFD0D6),
            ],
            stops: const [0.0, 1.0],
            begin: FractionalOffset.centerLeft,
            end: FractionalOffset.centerRight,
            tileMode: TileMode.repeated,
          ),
        ),
      ),
    );
  }
}
