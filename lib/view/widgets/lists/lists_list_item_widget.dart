import 'dart:math';

import 'package:checklist/view/screens/list_reminder_screen.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart' as Constants;
import '../../../container/injection_container.dart';
import '../../../models/list_model.dart';
import '../../../providers/lists_provider.dart';
import '../../../services/local_notification_service.dart';

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

    _containerHeight = 90;
    _isContainerExpanded = false;
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
                          ? Container(
                              width: 80,
                              child: CircularCheckBox(
                                value: widget.selected,
                                inactiveColor: Colors.black26,
                                onChanged: (value) {
                                  Provider.of<ListsProvider>(context,
                                          listen: false)
                                      .toggleListSelected(widget.list);
                                },
                              ),
                            )
                          : widget.list.favourite
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
                                          Provider.of<ListsProvider>(context,
                                                  listen: false)
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
                                            MaterialCommunityIcons
                                                .heart_outline,
                                            color:
                                                Theme.of(context).accentColor,
                                            size: _heartPulseAnimation.value,
                                          ),
                                          onTap: () async {
                                            await _heartPulseController
                                                .forward();
                                            await _heartPulseController
                                                .reverse();
                                            widget.list.favourite = true;
                                            Provider.of<ListsProvider>(context,
                                                    listen: false)
                                                .updateList(widget.list);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Opacity(
                                    opacity: 0.7,
                                    child: Text(
                                      widget.list.name,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            child: Opacity(
                              opacity: 0.4,
                              child: Text(
                                '${DateFormat.yMMMd().format(widget.list.dateTimeCreated)}',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Opacity(
                          opacity: widget.selectListMode ? 0.0 : 0.3,
                          child: AnimatedBuilder(
                              animation: _arrowAnimationController,
                              builder: (ctx, child) {
                                return Transform.rotate(
                                  angle: _arrowAnimation.value,
                                  child: IconButton(
                                    icon: Icon(
                                        MaterialCommunityIcons.chevron_down),
                                    color: Colors.black,
                                    onPressed: () {
                                      setState(() {
                                        _isContainerExpanded
                                            ? _containerHeight = 90
                                            : _containerHeight = 190;
                                        _isContainerExpanded =
                                            !_isContainerExpanded;
                                        if (_isContainerExpanded) {
                                          _arrowAnimationController.forward();
                                        } else {
                                          _arrowAnimationController.reverse();
                                        }
                                      });
                                    },
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: _isContainerExpanded
                        ? _buildExpandedContent()
                        : Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    bool reminderSet = widget.list.reminder != null;
    String formattedDate;
    String formattedTime;
    if (reminderSet) {
      final reminderDateTime = widget.list.reminder.reminderDateTime;
      formattedDate = DateFormat.yMMMd().format(reminderDateTime);
      formattedTime = reminderDateTime.hour.toString() +
          ':' +
          reminderDateTime.minute.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: <Widget>[
          reminderSet
              ? Row(
                  children: <Widget>[
                    Text(formattedDate),
                    Text(formattedTime),
                  ],
                )
              : Row(
                  children: <Widget>[],
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) {
                      return ListReminderScreen(list: widget.list);
                    },
                    fullscreenDialog: true,
                  ));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Theme.of(context).accentColor,
                child: Text('Set reminder', style: TextStyle(fontSize: 12)),
              ),
              FlatButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Theme.of(context).accentColor,
                child: Text('Move to inactive', style: TextStyle(fontSize: 12)),
              ),
              FlatButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Theme.of(context).accentColor,
                child: Text('Delete', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future _setReminderBottomSheet() async {
    TextEditingController dateController = TextEditingController();
    TextEditingController timeController = TextEditingController();

    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.list.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                readOnly: true,
                controller: dateController,
                style: TextStyle(fontSize: 14),
                onTap: () async {
                  final dateTime = DateTime.now();
                  final date = await showDatePicker(
                      context: context,
                      initialDate: dateTime,
                      firstDate: dateTime,
                      lastDate: dateTime.add(Duration(days: 365 * 3)));
                  if (date != null) {
                    dateController.text = DateFormat.yMMMd().format(date);
                  }
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  hintText: 'Reminder date',
                  hintStyle: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                readOnly: true,
                controller: timeController,
                style: TextStyle(fontSize: 14),
                onTap: () async {
                  final time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (time != null) {
                    timeController.text =
                        time.hour.toString() + ':' + time.minute.toString();
                    setState(() {});
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: timeController.text.isNotEmpty
                            ? Theme.of(context).primaryColor
                            : Colors.black12),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: timeController.text.isNotEmpty
                            ? Theme.of(context).primaryColor
                            : Colors.black12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: timeController.text.isNotEmpty
                            ? Theme.of(context).primaryColor
                            : Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: timeController.text.isNotEmpty
                            ? Theme.of(context).primaryColor
                            : Colors.black12),
                  ),
                  hintText: 'Reminder time',
                  hintStyle: TextStyle(fontSize: 14),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
