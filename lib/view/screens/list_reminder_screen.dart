import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';

import '../../helpers/app_theme_helper.dart';
import '../../models/list_model.dart';

enum RepeatReminder {
  Never,
  Daily,
  Weekly,
}

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
  bool hasSound;
  RepeatReminder repeatReminder;

  @override
  void initState() {
    if (widget.list.reminder == null) {
      hasSound = false;
      repeatReminder = RepeatReminder.Never;
    } else {
      hasSound = widget.list.reminder.hasSound;
      // repeatReminder = widget.list.reminder.repeatReminder;
      dateController.text =
          DateFormat.yMMMd().format(widget.list.reminder.reminderDateTime);
      timeController.text =
          widget.list.reminder.reminderDateTime.hour.toString() +
              ':' +
              widget.list.reminder.reminderDateTime.minute.toString();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          Text(widget.list.name, style: TextStyle(fontSize: 18)),
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
              final dateTime = DateTime.now();
              final date = await showRoundedDatePicker(
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
                dateController.text = DateFormat.yMMMd().format(date);
              }
            },
          ),
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
                timeController.text =
                    time.hour.toString() + ' : ' + time.minute.toString();
                setState(() {});
              }
            },
            decoration: InputDecoration(
              hintText: 'Time',
              hintStyle: TextStyle(fontSize: 14),
            ),
          ),
          Row(
            children: <Widget>[
              Text('Alert sound on?'),
              CircularCheckBox(
                value: hasSound,
                onChanged: (value) {
                  setState(() {
                    hasSound = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text('Repeat reminder?'),
              SizedBox(width: 20),
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  items: [
                    DropdownMenuItem(
                      child: Text('Never'),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text('Daily'),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text('Weekly'),
                      value: 3,
                    ),
                  ],
                  elevation: 1,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontFamily: 'Comfortaa'),
                  value: 1,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
