import 'package:checklist/providers/lists_provider.dart';
import 'package:checklist/view/widgets/core/text_field_submit_dialog.dart';
import 'package:checklist/view/widgets/list/lists_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ListsScreen extends StatelessWidget {
  final int folderId;
  final String folderName;

  ListsScreen(
    this.folderId,
    this.folderName,
  );

  @override
  Widget build(BuildContext context) {
    Provider.of<ListsProvider>(context, listen: false)
        .loadListsForFolder(folderId);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(MaterialCommunityIcons.format_list_checkbox),
            ),
            Text(
              folderName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 0,
        titleSpacing: 30,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return TextFieldAndSubmitDialog(
                    (text) async =>
                        await Provider.of<ListsProvider>(context, listen: false)
                            .insertList(text),
                    'List Name',
                    maxLength: 15,
                  );
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListsListWidget(),
    );
  }
}
