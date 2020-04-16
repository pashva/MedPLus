
import 'package:flutter/material.dart';



class mainpageui extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return CustomPaint(
      child: Container(


        height: height,
      ),
      painter: CurvePainter(),
    );
  }
}

class CurvePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    paint.color = Colors.lightBlue[200];
    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}