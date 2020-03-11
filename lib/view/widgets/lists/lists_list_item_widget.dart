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
    with SingleTickerProviderStateMixin {
  AnimationController _slideController;
  Animation<Offset> _offset;

  @override
  void initState() {
    _slideController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.05, 0))
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.ease));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
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
            child: Row(
              children: <Widget>[
                Container(
                  color: widget.list.favourite
                      ? Theme.of(context).accentColor
                      : Colors.transparent,
                  height: 80,
                  width: 0,
                ),
                widget.selectListMode
                    ? Container(
                        width: 80,
                        child: CircularCheckBox(
                            value: widget.selected,
                            inactiveColor: Colors.black26,
                            onChanged: (value) {
                              Provider.of<ListsProvider>(context, listen: false)
                                  .toggleListSelected(widget.list);
                            }),
                      )
                    : Container(
                        width: 80,
                        child: widget.list.favourite
                            ? Icon(
                                MaterialCommunityIcons.star,
                                color: Colors.yellowAccent[700],
                                size: 35,
                              )
                            : Container(),
                      ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Opacity(
                          opacity: 0.7,
                          child: Text(
                            widget.list.name,
                            style: TextStyle(
                              fontSize: 16,
                              // color: Theme.of(context).primaryColor,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ),
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
                            // color: Theme.of(context).primaryColor,
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
                    child: PopupMenuButton(
                      icon: Icon(
                        MaterialCommunityIcons.dots_vertical,
                        color: Colors.black,
                      ),
                      enabled: !widget.selectListMode,
                      itemBuilder: (context) {
                        final textStyle = TextStyle(fontSize: 14);
                        return [
                          widget.list.active
                              ? PopupMenuItem(
                                  child: Text('Move to inactive',
                                      style: textStyle),
                                  value: 1,
                                )
                              : PopupMenuItem(
                                  child:
                                      Text('Move to active', style: textStyle),
                                  value: 2,
                                ),
                          widget.list.favourite
                              ? PopupMenuItem(
                                  child: Text('Unfavourite', style: textStyle),
                                  value: 3,
                                )
                              : PopupMenuItem(
                                  child: Text('Favourite', style: textStyle),
                                  value: 4,
                                ),
                          PopupMenuItem(
                            child: Text(
                              'Set reminder',
                              style: textStyle,
                            ),
                            value: 5,
                          ),
                        ];
                      },
                      onSelected: (value) async {
                        if (value == 1) {
                          widget.list.active = false;
                        } else if (value == 2) {
                          widget.list.active = true;
                        } else if (value == 3) {
                          widget.list.favourite = false;
                        } else if (value == 4) {
                          widget.list.favourite = true;
                        } else if (value == 5) {
                          await _setReminderBottomSheet();
                        }
                        Provider.of<ListsProvider>(context, listen: false)
                            .updateList(widget.list);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
