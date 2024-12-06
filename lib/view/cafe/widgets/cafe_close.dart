import 'package:flutter/material.dart';

class CafeCloseed extends StatefulWidget {
  const CafeCloseed({super.key});

  @override
  State<CafeCloseed> createState() => _CafeCloseedState();
}

class _CafeCloseedState extends State<CafeCloseed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Image.asset("assets/images/cafe_closed.png")],
      ),
    );
  }
}
