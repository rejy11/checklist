import 'package:checklist/models/list_model.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart' as Constants;

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
          title: Text('Set Reminder', style: TextStyle(color: Colors.white),),
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
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Constants.BACKGROUND_GRADIENT_START,
                Constants.BACKGROUND_GRADIENT_END,
              ],
            ),
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
          ),
          TextField(
            controller: timeController,
            readOnly: true,
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
              hintText: 'Time',
              hintStyle: TextStyle(fontSize: 14),
            ),
          ),
          Row(
            children: <Widget>[
              Text('Alert sound on?'),
              CircularCheckBox(
                value: hasSound,
                onChanged: (value) {},
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text('Repeat reminder?'),
              DropdownButton(
                style: TextStyle(fontSize: 14, color: Colors.black87),
                
                value: 1,
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
                onChanged: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
