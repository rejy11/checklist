import 'package:checklist/providers/lists_provider.dart';
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
  Widget build(BuildContext context) {
    Provider.of<ListsProvider>(context, listen: false)
        .loadListsForFolder(widget.folderId);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(MaterialCommunityIcons.format_list_checkbox),
            ),
            Text('Lists', style: TextStyle(fontWeight: FontWeight.bold),),
            
          ],
        ),
        elevation: 0,
        titleSpacing: 30,
        actions: <Widget>[],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListsListWidget(),
    );
  }
}
