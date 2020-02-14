import 'package:flutter/material.dart';

class IconAboveTextButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color textColour;
  final double opacity;
  final Function onTap;
  final bool showText;

  const IconAboveTextButton({
    this.iconData,
    this.text,
    this.opacity,
    this.textColour,
    this.onTap,
    this.showText,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                iconData,
                color: onTap != null ? textColour : Colors.white30,
              ),
              if (showText)
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColour,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
