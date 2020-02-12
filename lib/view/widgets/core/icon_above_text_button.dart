import 'package:flutter/material.dart';

class IconAboveTextButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color textColour;
  final double opacity;
  final Function onTap;

  const IconAboveTextButton({
    this.iconData,
    this.text,
    this.opacity,
    this.textColour,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                iconData,
                color: onTap != null ? Colors.black : Colors.black26,
              ),
              // Text(
              //   text,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: textColour,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
