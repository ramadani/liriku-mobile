import 'package:flutter/material.dart';

class ImagePlaceholder extends StatelessWidget {
  final double width;
  final double height;

  const ImagePlaceholder({Key key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      width: width,
      height: height,
      child: Center(
        child: Image.asset(
          'assets/images/ic_logo.png',
          height: height / 1.2,
        ),
      ),
    );
  }
}
