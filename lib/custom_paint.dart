import 'package:flutter/material.dart';


class MyCustomPaint extends StatefulWidget {
  const MyCustomPaint({Key? key}) : super(key: key);

  @override
  State<MyCustomPaint> createState() => _MyCustomPaintState();
}

class _MyCustomPaintState extends State<MyCustomPaint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Text('Custom Painter'),
      ),
      backgroundColor: Colors.white70,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Hello"),
          Row(
            children: [
              Container(
                height:600,
                width: 40,
                child: CustomPaint(
                  painter: DrawRect(title: 'fjf'),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}


class DrawRect extends CustomPainter {
  final String title;
 DrawRect({required this.title});
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xffffffff)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset(18, 100) & const Size(70, 150), paint1);

    canvas.drawRect(Offset(95, 100) & const Size(250, 150), paint1);
    var paint2 = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5;

    canvas.drawLine(Offset(89,size.height * 0.17), Offset(size.width * 0.42, size.height * 0.17 ), paint2);


    canvas.drawLine(Offset(345,size.height * 0.17), Offset(95, size.height * 0.17 ), paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}