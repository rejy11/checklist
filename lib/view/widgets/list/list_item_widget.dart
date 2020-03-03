import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../../models/list_item_model.dart';
import '../../../providers/list_items_provider.dart';

class ListItemWidget extends StatefulWidget {
  final ListItemModel listItem;

  ListItemWidget(this.listItem);

  @override
  _ListItemWidgetState createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        Provider.of<ListItemsProvider>(context, listen: false)
            .deleteListItem(widget.listItem.id);
      },
      background: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              MaterialCommunityIcons.delete_outline,
              color: Colors.white,
            )
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          color: Colors.white54,
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 2),
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.listItem.name,
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                    ),
                  ),
                  CircularCheckBox(
                    value: widget.listItem.completed,
                    inactiveColor: Colors.black26,
                    onChanged: (value) {
                      widget.listItem.completed = value;
                      Provider.of<ListItemsProvider>(context, listen: false)
                          .updateListItem(widget.listItem);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
