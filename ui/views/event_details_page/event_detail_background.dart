import 'package:eventor/denem9-firebaseTum/core/models/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class XEventDetailsBackground extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    //VAR
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;
    final _event =Provider.of<XEvent>(context);

    //DESİGNS
    return  Align(
      alignment: Alignment.topCenter,
      child: ClipPath(
        clipper: XImageClipper(),
        child: Image.network(
          _event.imageUrl ?? "https://www.amerikickkansas.com/wp-content/uploads/2017/04/default-image.jpg",
          fit: BoxFit.cover,
          width: _screenWidth,
          height: _screenHeight * 0.5,
          color: Color(0x99000000),
          colorBlendMode: BlendMode.darken,
        ),
      ),
    );
  }
}

class XImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path _path = Path();
    Offset _curveStartingPoint = Offset(0,40);
    Offset _curveEndPoint = Offset(size.width, size.height*0.95);
    _path.lineTo(_curveStartingPoint.dx, _curveStartingPoint.dy - 5);
    _path.quadraticBezierTo(size.width * 0.2, size.height * 0.85, _curveEndPoint.dx -60, _curveEndPoint.dy +10);
    _path.quadraticBezierTo(size.width * 0.99, size.height * 0.99, _curveEndPoint.dx, _curveEndPoint.dy);
    _path.lineTo(size.width, 0);
    _path.close();
    return _path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
  
}