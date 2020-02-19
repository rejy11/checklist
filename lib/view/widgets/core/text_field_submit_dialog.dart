import 'package:flutter/material.dart';

class TextFieldAndSubmitDialog extends StatefulWidget {
  final Function onCompleted;
  final String inputHintText;
  final String text;
  final int maxLength;

  const TextFieldAndSubmitDialog(
    this.onCompleted,
    this.inputHintText, {
    this.text,
    this.maxLength,
  });

  @override
  _TextFieldAndSubmitDialogState createState() =>
      _TextFieldAndSubmitDialogState();
}

class _TextFieldAndSubmitDialogState extends State<TextFieldAndSubmitDialog> {
  TextEditingController nameController = TextEditingController();
  bool canOnCompletedByCalled = false;

  @override
  void initState() {
    nameController.text = widget.text;
    if (widget.text != null) {
      if (widget.text.isNotEmpty) {
        canOnCompletedByCalled = true;
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
        borderRadius: BorderRadius.circular(15),
      ),
      content: Container(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, right: 10),
                    child: TextField(
                      controller: nameController,
                      autofocus: true,
                      maxLength:
                          widget.maxLength != null ? widget.maxLength : null,
                      onChanged: (text) {
                        if (text.isNotEmpty & !canOnCompletedByCalled) {
                          setState(() {
                            canOnCompletedByCalled = true;
                          });
                        }
                        if (!text.isNotEmpty & canOnCompletedByCalled) {
                          setState(() {
                            canOnCompletedByCalled = false;
                          });
                        }
                      },
                      onSubmitted: (text) =>
                          canOnCompletedByCalled = text.isNotEmpty,
                      decoration: InputDecoration(
                        hintText: widget.inputHintText,
                      ),
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: canOnCompletedByCalled
                      ? () async {
                          Navigator.pop(context);
                          widget.onCompleted(nameController.text);
                        }
                      : null,
                  mini: true,
                  elevation: 0,
                  child: Icon(
                    Icons.check,
                    color: canOnCompletedByCalled
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
