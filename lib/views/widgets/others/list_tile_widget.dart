import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListTileWidget extends StatelessWidget {
  final String text;
  final String img;
  final VoidCallback? onTap;
  final Color cardColor;
  final Color? titleTextColor;

  const ListTileWidget({
    Key? key,
    required this.text,
    required this.img,
    required this.onTap,
    required this.cardColor,
    this.titleTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      child: ListTile(
        onTap: onTap,
        title: Text(text),
        trailing: SvgPicture.asset(
          img,
        ),
      ),
    );
  }
}
