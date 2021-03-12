import 'package:checklist/providers/lists_provider.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/list_reminder_model.dart';
import '../../enums/repeat_reminder.dart';
import '../../helpers/app_theme_helper.dart';
import '../../models/list_model.dart';

class ListReminderScreen extends StatefulWidget {
  final ListModel list;

  ListReminderScreen({
    @required this.list,
  });

  @override
  _ListReminderScreenState createState() => _ListReminderScreenState();
}

class _ListReminderScreenState extends State<ListReminderScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  DateTime dateTimeSet;
  bool hasSound;
  RepeatReminder repeatReminder;
  bool isDateSet = false;
  bool isTimeSet = false;
  bool isDirty = false;
  bool isNewReminder;
  double _saveButtonContainerWidth;

  @override
  void initState() {
    if (widget.list.reminder == null) {
      isNewReminder = true;
      hasSound = false;
      repeatReminder = RepeatReminder.Never;
      dateTimeSet = DateTime.now();
    } else {
      isNewReminder = false;
      isTimeSet = true;
      isDateSet = true;
      hasSound = widget.list.reminder.hasSound;
      repeatReminder = widget.list.reminder.repeatReminder;
      dateController.text =
          DateFormat.yMMMd().format(widget.list.reminder.reminderDateTime);
      timeController.text =
          widget.list.reminder.reminderDateTime.hour.toString() +
              ':' +
              widget.list.reminder.reminderDateTime.minute.toString();
      dateTimeSet = widget.list.dateTimeCreated;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _saveButtonContainerWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Set Reminder'),
          iconTheme: Theme.of(context).iconTheme,
          centerTitle: true,
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 56),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: _buildMainContent(),
            ),
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.jpg'), fit: BoxFit.none)
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [
              //     Constants.BACKGROUND_GRADIENT_START,
              //     Constants.BACKGROUND_GRADIENT_END,
              //   ],
              // ),
              ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 40),
          Text(widget.list.name, style: TextStyle(fontSize: 18)),
          SizedBox(height: 40),
          TextField(
            controller: dateController,
            readOnly: true,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Date',
              hintStyle: TextStyle(fontSize: 14),
            ),
            onTap: () async {
              AppThemeHelper.applyStatusBarThemeForDialog(context);
              var dateTime = DateTime.now();
              var date = await showRoundedDatePicker(
                context: context,
                initialDate: dateTime,
                firstDate: dateTime,
                lastDate: dateTime.add(Duration(days: 365 * 3)),
                fontFamily: 'Comfortaa',
                borderRadius: 40,
                theme: ThemeData(
                  primaryColor: Theme.of(context).primaryColor,
                  accentColor: Theme.of(context).accentColor,
                  accentTextTheme: TextTheme(
                    body2: TextStyle(color: Colors.white),
                  ),
                  primarySwatch: Colors.red,
                ),
              );
              AppThemeHelper.applyStatusBarTheme(context);
              if (date != null) {
                dateTimeSet = DateTime.now();
                final days = DateTime.now().difference(date);
                dateTimeSet.add(Duration(days: days.inDays));
                dateController.text = DateFormat.yMMMd().format(date);
                setState(() {
                  isDateSet = true;
                  if (!isNewReminder) {
                    isDirty = true;
                  }
                });
              }
            },
          ),
          SizedBox(height: 20),
          TextField(
            controller: timeController,
            readOnly: true,
            style: TextStyle(fontSize: 14),
            onTap: () async {
              AppThemeHelper.applyStatusBarThemeForDialog(context);
              final time = await showRoundedTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                fontFamily: 'Comfortaa',
                borderRadius: 40,
                theme: ThemeData(
                  primaryColor: Theme.of(context).primaryColor,
                  accentColor: Theme.of(context).accentColor,
                  accentTextTheme: TextTheme(
                    body2: TextStyle(color: Colors.white),
                  ),
                  primarySwatch: Colors.red,
                ),
              );
              AppThemeHelper.applyStatusBarTheme(context);
              if (time != null) {
                dateTimeSet = DateTime.now();
                String minuteText;
                dateTimeSet
                    .add(Duration(hours: time.hour, minutes: time.minute));

                if (time.minute < 10) {
                  minuteText = '0' + time.minute.toString();
                } else {
                  minuteText = time.minute.toString();
                }
                timeController.text = time.hour.toString() + ' : ' + minuteText;
                setState(() {
                  isTimeSet = true;
                  if (!isNewReminder) {
                    isDirty = true;
                  }
                });
              }
            },
            decoration: InputDecoration(
              hintText: 'Time',
              hintStyle: TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Text('Alert sound on?'),
              CircularCheckBox(
                value: hasSound,
                onChanged: (value) {
                  setState(() {
                    hasSound = value;
                    if (!isNewReminder) {
                      isDirty = true;
                    }
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Text('Repeat reminder?'),
              SizedBox(width: 20),
              PopupMenuButton(
                child: Row(
                  children: <Widget>[
                    Text(repeatReminder.toString().split('.')[1]),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
                itemBuilder: (context) {
                  return RepeatReminder.values.map((r) {
                    return PopupMenuItem(
                      child: Text(
                        r.toString().split('.')[1],
                        style: TextStyle(fontSize: 14),
                      ),
                      value: r,
                    );
                  }).toList();
                },
                onSelected: (RepeatReminder value) {
                  setState(() {
                    repeatReminder = value;
                    if (!isNewReminder) {
                      isDirty = true;
                    }
                  });
                },
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                offset: Offset(100, 0),
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          isNewReminder
              ? AnimatedContainer(
                 duration: Duration(milliseconds: 300),
                  width: _saveButtonContainerWidth,
                  child: FlatButton(
                    onPressed: _saveReminder,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Theme.of(context).accentColor,
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    !isNewReminder
                        ? Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: FlatButton(
                                onPressed: widget.list.reminder != null
                                    ? () async {
                                        await Provider.of<ListsProvider>(
                                                context,
                                                listen: false)
                                            .deleteReminder(
                                                widget.list.reminder.id);
                                        Navigator.of(context).pop();
                                      }
                                    : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Theme.of(context).accentColor,
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    _canSaveReminder()
                        ? Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: FlatButton(
                                onPressed: _saveReminder,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Theme.of(context).accentColor,
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
        ],
      ),
    );
  }

  void _saveReminder() async {
    ListReminderModel reminder = ListReminderModel(
      listId: widget.list.id,
      hasSound: hasSound,
      reminderDateTime: dateTimeSet,
      repeatReminder: repeatReminder,
    );
    if (isNewReminder) {
      await Provider.of<ListsProvider>(context, listen: false)
          .setReminder(reminder);
    } else {
      await Provider.of<ListsProvider>(context, listen: false)
          .updateReminder(reminder);
    }
    Navigator.of(context).pop();
  }

  bool _canSaveReminder() {
    if (isNewReminder) {
      return isDateSet && isTimeSet;
    } else {
      return isDirty;
    }
  }
}
