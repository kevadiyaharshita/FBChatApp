import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  double x = 0, y = 0;
  double alignmentX = 0, alignmentY = 0;
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    double width = s.width;
    double height = s.height;
    GlobalKey key = GlobalKey();

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Exmpalw"),
      // ),
      body: Center(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                RenderBox box =
                    key?.currentContext?.findRenderObject() as RenderBox;
                Offset position =
                    box.localToGlobal(Offset(50, 50)); //this is global position
                setState(() {
                  y = position.dy;
                  x = position.dx;
                });
                alignmentX = (x - width / 2) / (width / 2);
                alignmentY = (y - height / 2) / (height / 2);
                print("Positin : $alignmentX");
                print("Y Position : $alignmentY");
              },
              child: Align(
                // alignment: Alignment(alignmentX, alignmentY),
                child: Container(
                  width: 100,
                  height: 100,
                  key: key,
                  color: Colors.red,
                  child: ListTile(
                    title: Text("hello"),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(alignmentX, alignmentY),
              child: Text("hellooo"),
            ),
          ],
        ),
      ),
    );
  }
}
