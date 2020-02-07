import 'package:checklist/providers/folders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewFolderDialogWidget extends StatefulWidget {
  @override
  _NewFolderDialogWidgetState createState() => _NewFolderDialogWidgetState();
}

class _NewFolderDialogWidgetState extends State<NewFolderDialogWidget> {
  TextEditingController nameController = TextEditingController();
  bool canInsertFolder = false;

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
                      onChanged: (text) {
                        if (text.isNotEmpty & !canInsertFolder) {
                          setState(() {
                            canInsertFolder = true;
                          });
                        }
                        if (!text.isNotEmpty & canInsertFolder) {
                          setState(() {
                            canInsertFolder = false;
                          });
                        }
                      },
                      onSubmitted: (text) => canInsertFolder = text.isNotEmpty,
                      decoration: InputDecoration(
                        hintText: 'Folder Name',
                      ),
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: canInsertFolder ? _insertFolder : null,
                  mini: true,
                  elevation: 0,
                  child: Icon(Icons.check),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _insertFolder() {
    Provider.of<FoldersProvider>(context, listen: false)
        .insertFolder(nameController.text);
    Navigator.pop(context);
  }
}
