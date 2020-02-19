import 'package:checklist/models/list_model.dart';
import 'package:checklist/providers/lists_provider.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListListItemWidget extends StatefulWidget {
  final ListModel list;
  final Function onLongPress;
  final Function onTap;

  const ListListItemWidget({
    Key key,
    this.list,
    this.onLongPress,
    this.onTap,
  }) : super(key: key);

  @override
  _ListListItemWidgetState createState() => _ListListItemWidgetState();
}

class _ListListItemWidgetState extends State<ListListItemWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _slideController;
  Animation<Offset> _offset;

  @override
  void initState() {
    _slideController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.05, 0))
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.ease));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        elevation: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          child: InkWell(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: Row(
              children: <Widget>[
                Container(
                  color: widget.list.favourite
                      ? Theme.of(context).accentColor
                      : Colors.transparent,
                  height: 80,
                  width: 7,
                ),
                Container(
                  width: 80,
                  child: Consumer<ListsProvider>(
                    builder: (context, value, child) {
                      return CircleAvatar(
                        child: Text(
                          '${widget.list.numberOfItems}',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Theme.of(context).accentColor,
                      );
                      // if (value.deleteFolderMode) {
                      //   return CircularCheckBox(
                      //     value: value.isFolderChecked(folder.id),
                      //     onChanged: (value) {
                      //       Provider.of<ListsProvider>(context, listen: false)
                      //           .toggleFolderDeleteCheckbox(folder.id, value);
                      //     },
                      //   );
                      // } else {
                      //   return Icon(
                      //     folder.isFavourite
                      //         ? MaterialCommunityIcons.folder_star_outline
                      //         : MaterialCommunityIcons.folder_outline,
                      //     color: Theme.of(context).accentColor,
                      //   );
                      // }
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          widget.list.name,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      child: Opacity(
                        opacity: 0.6,
                        child: Text(
                          '${DateFormat.yMMMd().format(widget.list.dateTimeCreated)}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularCheckBox(
                    value: widget.list.completed,
                    onChanged: (value) {
                      widget.list.completed = value;
                      Provider.of<ListsProvider>(context, listen: false)
                          .updateList(widget.list);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
