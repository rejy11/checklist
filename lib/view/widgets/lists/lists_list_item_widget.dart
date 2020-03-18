import 'dart:math';

import 'package:checklist/enums/repeat_reminder.dart';
import 'package:checklist/models/list_reminder_model.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../container/injection_container.dart';
import '../../../models/list_model.dart';
import '../../../providers/lists_provider.dart';
import '../../../services/local_notification_service.dart';
import '../../screens/list_reminder_screen.dart';

class ListsListItemWidget extends StatefulWidget {
  final LocalNotificationService localNotificationService = serviceLocator();
  final ListModel list;
  final Function onLongPress;
  final Function onTap;
  final bool selectListMode;
  final bool selected;

  ListsListItemWidget(
    this.selectListMode,
    this.selected, {
    Key key,
    this.list,
    this.onLongPress,
    this.onTap,
  }) : super(key: key);

  @override
  _ListsListItemWidgetState createState() => _ListsListItemWidgetState();
}

class _ListsListItemWidgetState extends State<ListsListItemWidget>
    with TickerProviderStateMixin {
  AnimationController _slideController,
      _heartPulseController,
      _arrowAnimationController;
  Animation<Offset> _offset;
  Animation<double> _heartPulseAnimation, _arrowAnimation;
  double _containerHeight;
  bool _isContainerExpanded;
  double expandedContentOpacity;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.05, 0)).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.ease,
      ),
    );

    _heartPulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );
    _heartPulseAnimation = Tween<double>(begin: 35, end: 40).animate(
      CurvedAnimation(
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
        parent: _heartPulseController,
      ),
    );

    _arrowAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _arrowAnimation = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _arrowAnimationController,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeIn,
      ),
    );

    // _containerHeight = 90;
    _isContainerExpanded = false;
    expandedContentOpacity = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: _containerHeight,
        child: Card(
          color: Colors.white54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
          elevation: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: InkWell(
              onTap: () {
                if (widget.selectListMode) {
                  Provider.of<ListsProvider>(context, listen: false)
                      .toggleListSelected(widget.list);
                } else {
                  widget.onTap();
                }
              },
              onLongPress: () {
                Provider.of<ListsProvider>(context, listen: false)
                    .toggleListSelected(widget.list);
                widget.onLongPress();
              },
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      widget.selectListMode
                          ? _buildCheckBoxContainer(context)
                          : _buildFavouriteWidget(context),
                      _buildTopContent(
                        context,
                        widget.list.name,
                        widget.list.dateTimeCreated,
                        widget.list.reminder != null,
                      ),
                      Expanded(child: SizedBox()),
                      _buildExpandButton(),
                    ],
                  ),
                  _isContainerExpanded
                      ? _buildExpandedContent(context, widget.list.reminder)
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildExpandButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Opacity(
        opacity: widget.selectListMode ? 0.0 : 0.3,
        child: AnimatedBuilder(
            animation: _arrowAnimationController,
            builder: (ctx, child) {
              return Transform.rotate(
                angle: _arrowAnimation.value,
                child: IconButton(
                  icon: Icon(MaterialCommunityIcons.chevron_down),
                  color: Colors.black,
                  onPressed: () async {
                    if (!_isContainerExpanded) {
                      await _arrowAnimationController.forward();
                    } else {
                      await _arrowAnimationController.reverse();
                    }
                    setState(() {
                      _isContainerExpanded = !_isContainerExpanded;

                      // _isContainerExpanded
                      //     ? _containerHeight = 190
                      //     : _containerHeight = 90;
                      _isContainerExpanded
                          ? expandedContentOpacity = 1.0
                          : expandedContentOpacity = 0.0;
                    });
                  },
                ),
              );
            }),
      ),
    );
  }

  Column _buildTopContent(
    BuildContext context,
    String listName,
    DateTime dateCreated,
    bool reminderSet,
  ) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              reminderSet
                  ? Row(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.6,
                          child: Icon(
                            MaterialCommunityIcons.alarm,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 5),
                      ],
                    )
                  : SizedBox(),
              FittedBox(
                fit: BoxFit.contain,
                child: Opacity(
                  opacity: 0.7,
                  child: Text(
                    listName,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          child: Opacity(
            opacity: 0.4,
            child: Text(
              '${DateFormat.yMMMd().format(dateCreated)}',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container _buildCheckBoxContainer(BuildContext context) {
    return Container(
      width: 80,
      child: CircularCheckBox(
        value: widget.selected,
        inactiveColor: Colors.black26,
        onChanged: (value) {
          Provider.of<ListsProvider>(context, listen: false)
              .toggleListSelected(widget.list);
        },
      ),
    );
  }

  Widget _buildFavouriteWidget(BuildContext context) {
    return widget.list.favourite
        ? AnimatedBuilder(
            animation: _heartPulseController,
            builder: (context, child) {
              return Container(
                width: 80,
                child: GestureDetector(
                  child: Icon(
                    MaterialCommunityIcons.heart,
                    color: Theme.of(context).accentColor,
                    size: _heartPulseAnimation.value,
                  ),
                  onTap: () async {
                    await _heartPulseController.forward();
                    await _heartPulseController.reverse();
                    widget.list.favourite = false;
                    Provider.of<ListsProvider>(context, listen: false)
                        .updateList(widget.list);
                  },
                ),
              );
            },
          )
        : AnimatedBuilder(
            animation: _heartPulseAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: 0.4,
                child: Container(
                  width: 80,
                  child: GestureDetector(
                    child: Icon(
                      MaterialCommunityIcons.heart_outline,
                      color: Theme.of(context).accentColor,
                      size: _heartPulseAnimation.value,
                    ),
                    onTap: () async {
                      await _heartPulseController.forward();
                      await _heartPulseController.reverse();
                      widget.list.favourite = true;
                      Provider.of<ListsProvider>(context, listen: false)
                          .updateList(widget.list);
                    },
                  ),
                ),
              );
            },
          );
  }

  Widget _buildExpandedContent(
      BuildContext context, ListReminderModel reminder) {
    bool reminderSet = reminder != null;
    String formattedDate;
    String formattedTime;
    String repeatReminder;
    if (reminderSet) {
      final reminderDateTime = reminder.reminderDateTime;
      formattedDate = DateFormat.yMMMd().format(reminderDateTime);
      formattedTime = reminderDateTime.hour.toString() +
          ':' +
          reminderDateTime.minute.toString();
      switch (reminder.repeatReminder) {
        case RepeatReminder.Never:
          repeatReminder = 'Never';
          break;
        case RepeatReminder.Daily:
          repeatReminder = 'Daily';
          break;
        case RepeatReminder.Weekly:
          repeatReminder = 'Weekly';
          break;
      }
    }

    return Column(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.,
      children: <Widget>[
        reminderSet
            // Reminder has already been set, show reminder details
            ? Row(
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) {
                            return ListReminderScreen(list: widget.list);
                          },
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          MaterialCommunityIcons.alarm,
                          size: 16,
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '$formattedDate    $formattedTime    Repeat: $repeatReminder',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ],
              )
            // Reminder has not been set, show a button to set a reminder
            : Row(
                children: <Widget>[
                  // Set Reminder button with alarm icon
                  FlatButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) {
                            return ListReminderScreen(list: widget.list);
                          },
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          MaterialCommunityIcons.alarm,
                          size: 16,
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Set reminder',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ],
              ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: FlatButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Theme.of(context).accentColor,
                  child: Text('Edit name',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: FlatButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Theme.of(context).accentColor,
                  child: Text('Move to inactive',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: FlatButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Theme.of(context).accentColor,
                  child: Text('Delete',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
