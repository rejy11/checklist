import 'package:checklist/providers/list_items_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatelessWidget {
  final int listId;
  final String listName;

  ListScreen(
    this.listId,
    this.listName,
  );
  @override
  Widget build(BuildContext context) {
    Provider.of<ListItemsProvider>(context, listen: false)
        .loadListItemsForList(listId);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(listName, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
