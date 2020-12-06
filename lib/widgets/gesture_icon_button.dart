import 'package:flutter/material.dart';

class GestureIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final double size;
  GestureIconButton({
    Key key,
    @required this.icon,
    @required this.onTap,
    this.size,
    this.color
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Icon(icon, color: color, size: size,),
      ),
    );
  }
}
