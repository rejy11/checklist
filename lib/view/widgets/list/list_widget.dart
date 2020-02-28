import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/list_item_model.dart';
import '../../../providers/list_items_provider.dart';

class ListWidget extends StatefulWidget {
  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  TextEditingController _nameController = TextEditingController();
  bool _canOnCompletedByCalled = false;
  FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listItems = Provider.of<ListItemsProvider>(context).listItems;
    final statusBarHeight = MediaQuery.of(context).viewPadding.top;
    print(statusBarHeight);

    return listItems == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.only(top: 0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (_focusNode.hasFocus) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 56),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          itemBuilder: (context, i) {
                            return _buildListItem(listItems[i]);
                          },
                          itemCount: listItems.length,
                        ),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Container(
                    padding: EdgeInsets.only(left: 25),
                    height: 60,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: _nameController,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              hintText: 'New item',
                              border: InputBorder.none,
                            ),
                            onChanged: (_) {
                              setState(() {});
                            },
                          ),
                        ),
                        FlatButton(
                          child: Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          textColor: Theme.of(context).accentColor,
                          onPressed: _nameController.text.isNotEmpty
                              ? _addItemToList
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildListItem(ListItemModel item) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {},
      background: Card(
        color: Colors.white30,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.symmetric(vertical: 5),
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
                    item.name,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                CircularCheckBox(
                  value: item.completed,
                  onChanged: (value) {
                    item.completed = value;
                    Provider.of<ListItemsProvider>(context, listen: false)
                        .updateListItem(item);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Card(
          color: Colors.white30,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.symmetric(vertical: 5),
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
                      item.name,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  CircularCheckBox(
                    value: item.completed,
                    onChanged: (value) {
                      item.completed = value;
                      Provider.of<ListItemsProvider>(context, listen: false)
                          .updateListItem(item);
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

  void _addItemToList() {
    if (_nameController.text.isNotEmpty) {
      Provider.of<ListItemsProvider>(context, listen: false)
          .insertListItem(_nameController.text);
      _nameController.clear();
      FocusScope.of(context).unfocus();
    }
  }
}
