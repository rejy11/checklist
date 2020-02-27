import 'package:checklist/providers/lists_provider.dart';
import 'package:checklist/view/widgets/core/text_field_submit_dialog.dart';
import 'package:checklist/view/widgets/list/lists_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class ListsScreen extends StatefulWidget {
  final int folderId;

  ListsScreen(this.folderId);

  @override
  _ListsScreenState createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  @override
  void initState() {
    Provider.of<ListsProvider>(context, listen: false)
        .loadListsForFolder(widget.folderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('list screen rebuild');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(MaterialCommunityIcons.format_list_checkbox),
            ),
            Text(
              'Lists',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 0,
        titleSpacing: 30,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _newListDialog,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListsListWidget(),
    );
  }

  _newListDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return TextFieldAndSubmitDialog(
          _insertList,
          'List Name',
          maxLength: 15,
        );
      },
    );
  }

  _insertList(String text) async {
    await Provider.of<ListsProvider>(context, listen: false).insertList(text);
  }
}
