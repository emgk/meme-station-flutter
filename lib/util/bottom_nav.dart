// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:memestation/pages/postmeme.dart';

class BottomNav extends StatelessWidget {
  final Function switchTab;
  final int currentTabIndex;

  BottomNav({
    Key? key,
    required this.switchTab,
    required this.currentTabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width, 80),
          painter: BottomCustomPainer(),
        ),
        Center(
          heightFactor: 0.6,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => PostMeme()),
              );
            },
            backgroundColor: Colors.grey.shade600,
            child: Icon(
              Icons.upload_rounded,
              color: Colors.black,
            ),
            elevation: 10,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: 0 == currentTabIndex ? Colors.blue : Colors.white,
                ),
                onPressed: () {
                  switchTab(0);
                },
              ),
              IconButton(
                icon: Icon(Icons.bookmark,
                    color: 1 == currentTabIndex ? Colors.blue : Colors.white),
                onPressed: () {
                  switchTab(1);
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.20,
              ),
              IconButton(
                icon: Icon(Icons.public,
                    color: 2 == currentTabIndex ? Colors.blue : Colors.white),
                onPressed: () {
                  switchTab(2);
                },
              ),
              IconButton(
                icon: Icon(Icons.person,
                    color: 3 == currentTabIndex ? Colors.blue : Colors.white),
                onPressed: () {
                  switchTab(3);
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}

class BottomCustomPainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 20);

    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
