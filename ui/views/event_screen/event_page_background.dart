import 'package:flutter/material.dart';

class XEventPageBackground extends StatelessWidget {
  //VAR
  final screenHeight;
  //CONSTRUCTUR
  const XEventPageBackground({Key key, @required this.screenHeight}) : super(key: key);
  

  
  @override
  Widget build(BuildContext context) {

  //VAR
  final themeData = Theme.of(context);

    //DESİGNS
    return ClipPath(
      clipper: XBottomShapeClipper(),
      child: Container(
        height: screenHeight * 0.5,
        color: themeData.primaryColor,
      ),
    );

  }
}

class XBottomShapeClipper extends CustomClipper<Path> {
  
  @override
  Path getClip(Size size) {
    Path _path = Path();
    Offset _curveStartPoint = Offset(0, size.height * 0.85);
    Offset _curveEndPoint = Offset(size.width, size.height * 0.85);
    _path.lineTo(_curveStartPoint.dx, _curveStartPoint.dy);
    _path.quadraticBezierTo(size.width/2, size.height, _curveEndPoint.dx, _curveEndPoint.dy);
    _path.lineTo(size.width, 0);
    return _path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}