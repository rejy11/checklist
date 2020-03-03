import 'package:flutter/material.dart';

class ActionPanelWidget extends StatelessWidget {
  const ActionPanelWidget(
    this.position,
    this.slideDuration,
    this.height,
    this.opacity,
    this.opacityDuration, {
    this.contentRight,
    this.contentLeft,
  });

  final double position;
  final double opacity;
  final Duration slideDuration;
  final Duration opacityDuration;
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
        child: AnimatedOpacity(
          opacity: opacity,
          duration: opacityDuration,
          curve: Curves.ease,
          child: AnimatedContainer(
            duration: slideDuration,
            height: height,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: contentLeft != null ? contentLeft : Container(),
                ),
                contentRight != null ? contentRight : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
