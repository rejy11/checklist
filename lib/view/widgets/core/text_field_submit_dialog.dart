import 'package:flutter/material.dart';

class TextFieldAndSubmitDialog extends StatefulWidget {
  final String inputHintText;
  final String text;
  final int maxLength;
  final String negativeButtonText;
  final String positiveButtonText;
  final String title;
  final Function negativeButtonOnPressed;
  final Function positiveButtonOnPressed;

  const TextFieldAndSubmitDialog(
    this.inputHintText,
    this.negativeButtonText,
    this.positiveButtonText,
    this.title, {
    this.text,
    this.maxLength,
    this.negativeButtonOnPressed,
    this.positiveButtonOnPressed,
  });

  @override
  _TextFieldAndSubmitDialogState createState() =>
      _TextFieldAndSubmitDialogState();
}

class _TextFieldAndSubmitDialogState extends State<TextFieldAndSubmitDialog> {
  TextEditingController nameController = TextEditingController();
  bool canOnCompletedBeCalled = false;

  @override
  void initState() {
    nameController.text = widget.text;
    if (widget.text != null) {
      if (widget.text.isNotEmpty) {
        canOnCompletedBeCalled = true;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      content: Container(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Create List',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: nameController,
                    autofocus: true,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    maxLength:
                        widget.maxLength != null ? widget.maxLength : null,
                    onChanged: (text) {
                      if (text.isNotEmpty & !canOnCompletedBeCalled) {
                        setState(() {
                          canOnCompletedBeCalled = true;
                        });
                      }
                      if (!text.isNotEmpty & canOnCompletedBeCalled) {
                        setState(() {
                          canOnCompletedBeCalled = false;
                        });
                      }
                    },
                    onSubmitted: (text) =>
                        canOnCompletedBeCalled = text.isNotEmpty,
                    decoration: InputDecoration(
                      hintText: widget.inputHintText,
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).accentColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.negativeButtonText,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    textColor: Theme.of(context).accentColor,
                    onPressed: widget.negativeButtonOnPressed,
                  ),
                ),
                Container(
                  width: 6,
                  height: 20,
                  child: VerticalDivider(
                    color: Colors.black12,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.positiveButtonText,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    textColor: Theme.of(context).accentColor,
                    onPressed: canOnCompletedBeCalled
                        ? () =>
                            widget.positiveButtonOnPressed(nameController.text)
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
