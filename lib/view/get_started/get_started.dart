import 'package:flutter/material.dart';
import 'package:heavens_students/core/constants/constants.dart';
import 'package:heavens_students/core/constants/image_constants.dart';
import 'package:heavens_students/view/sign_In/SignIn.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Onboarding content data
  final List<Map<String, dynamic>> _onboardingPages = [
    {
      'image': ImageConstants.getstarted1,
      'title': "Live Smart, Stay Connected",
      'subtitle':
          "Heaven’s Living isn’t just about rooms — it’s about creating a connected and stress-free lifestyle for all residents. Enjoy the digital edge of managing your hostel stay effortlessly.",
    },
    {
      'image': ImageConstants.getstarted2,
      'title': "Book Your Room in Minutes",
      'subtitle':
          "Browse available rooms, view details, and book your preferred hostel room with just a few taps.",
    },
    {
      'image': ImageConstants.getstarted3,
      'title': "Manage Your Stay Like a Pro",
      'subtitle':
          "Submit service or maintenance requests anytime, track status, and handle payments seamlessly.",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Signin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for swipeable screens
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingPages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (_, index) {
              return _buildPage(_onboardingPages[index]);
            },
          ),

          // Positioned(
          //   bottom: 10,
          //   left: 1,
          //   right: 0,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: List.generate(
          //       _onboardingPages.length,
          //       (index) => Container(
          //         margin: const EdgeInsets.symmetric(horizontal: 4),
          //         width: 8,
          //         height: 8,
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: _currentPage == index
          //               ? Colors.white
          //               : Colors.white.withValues(alpha: 0.5),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  //     List.generate(
                  //   _onboardingPages.length,
                  //   (index) => Container(
                  //     margin: const EdgeInsets.symmetric(horizontal: 4),
                  //     width: 8,
                  //     height: 8,
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: _currentPage == index
                  //           ? Colors.white
                  //           : Colors.white.withValues(alpha: 0.5),
                  //     ),
                  //   ),
                  // ),

                  SizedBox(
                    width: 100,
                    child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                        separatorBuilder: (context, index) => SizedBox(
                              width: 10,
                            ),
                        itemCount: _onboardingPages.length),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_currentPage == _onboardingPages.length - 1) {
                        _navigateToSignIn();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: CircleAvatar(
                      // child: Center(
                      //   child: Text(
                      //     _currentPage == _onboardingPages.length - 1
                      //         ? "Get Started"
                      //         : "Next",
                      //     style: const TextStyle(
                      //       color: Colors.black,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 16,
                      //     ),
                      //   ),
                      // ),
                      backgroundColor: ColorConstants.cream,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> pageData) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(pageData['image']),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [
                Colors.black.withValues(alpha: 0.9),
                Colors.black.withValues(alpha: 0.4),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                pageData['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                pageData['subtitle'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }
}
