import 'package:flutter/material.dart';

class ActionPanelWidget extends StatelessWidget {
  const ActionPanelWidget(
    this.position,
    this.slideDuration,
    this.height, {
    this.contentRight,
    this.contentLeft,
  });

  final double position;
  final Duration slideDuration;
  final double height;
  final Widget contentRight;
  final Widget contentLeft;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: position,
      curve: Curves.easeOutCubic,
      duration: slideDuration,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        child: AnimatedContainer(
          duration: slideDuration,
          height: height,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).colorScheme.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 10,
                child: contentLeft,
              ),
              contentRight,
            ],
          ),
        ),
      ),
    );
  }
}
