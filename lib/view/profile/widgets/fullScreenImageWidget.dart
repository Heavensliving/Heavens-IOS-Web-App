import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final double blurSigma;
  final double imageRadiusFactor;

  const FullScreenImage({
    Key? key,
    required this.imageUrl,
    this.blurSigma = 20.0,
    this.imageRadiusFactor = 0.4,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required String imageUrl,
    double blurSigma = 20.0,
    double imageRadiusFactor = 0.4,
  }) {
    showDialog(
      context: context,
      builder: (context) => FullScreenImage(
        imageUrl: imageUrl,
        blurSigma: blurSigma,
        imageRadiusFactor: imageRadiusFactor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.width * imageRadiusFactor,
            backgroundImage: CachedNetworkImageProvider(imageUrl),
          ),
        ),
      ),
    );
  }
}
