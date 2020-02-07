import 'package:flutter/material.dart';

class IconAboveTextButton extends StatelessWidget {
  final Icon icon;
  final String text;
  final Color textColour;
  final double opacity;

  const IconAboveTextButton({
    this.icon,
    this.text,
    this.opacity,
    this.textColour,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () {},
        child: Opacity(
          opacity: opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              icon,
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
