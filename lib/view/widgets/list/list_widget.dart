import 'package:checklist/view/widgets/list/list_item_widget.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../../models/list_item_model.dart';
import '../../../providers/list_items_provider.dart';

class ListWidget extends StatefulWidget {
  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  TextEditingController _nameController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listItems = Provider.of<ListItemsProvider>(context).listItems;
    return listItems == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.only(top: 0),
            child: Column(
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
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ListItemWidget(listItems[i]),
                            );
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
                    color: Colors.white24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: _nameController,
                            focusNode: _focusNode,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'New item',hintStyle: TextStyle(color: Colors.white60),
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

  void _addItemToList() {
    if (_nameController.text.isNotEmpty) {
      Provider.of<ListItemsProvider>(context, listen: false)
          .insertListItem(_nameController.text);
      _nameController.clear();
      FocusScope.of(context).unfocus();
    }
  }
}
