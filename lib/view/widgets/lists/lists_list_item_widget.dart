import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/list_model.dart';
import '../../../providers/lists_provider.dart';

class ListsListItemWidget extends StatefulWidget {
  final ListModel list;
  final Function onLongPress;
  final Function onTap;
  final bool selectListMode;
  final bool selected;

  const ListsListItemWidget(
    this.selectListMode,
    this.selected, {
    Key key,
    this.list,
    this.onLongPress,
    this.onTap,
  }) : super(key: key);

  @override
  _ListsListItemWidgetState createState() => _ListsListItemWidgetState();
}

class _ListsListItemWidgetState extends State<ListsListItemWidget>
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
        color: Colors.white54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: InkWell(
            onTap: () {
              if (widget.selectListMode) {
                Provider.of<ListsProvider>(context, listen: false)
                    .toggleListSelected(widget.list);
              } else {
                widget.onTap();
              }
            },
            onLongPress: () {
              Provider.of<ListsProvider>(context, listen: false)
                  .toggleListSelected(widget.list);
              widget.onLongPress();
            },
            child: Row(
              children: <Widget>[
                Container(
                  color: widget.list.favourite
                      ? Theme.of(context).accentColor
                      : Colors.transparent,
                  height: 80,
                  width: 0,
                ),
                widget.selectListMode
                    ? Container(
                        width: 80,
                        child: CircularCheckBox(
                            value: widget.selected,
                            inactiveColor: Colors.black26,
                            onChanged: (value) {
                              Provider.of<ListsProvider>(context, listen: false)
                                  .toggleListSelected(widget.list);
                            }),
                      )
                    : Container(
                        width: 80,
                        child: widget.list.favourite
                            ? Icon(
                                MaterialCommunityIcons.star,
                                color: Colors.yellowAccent[700],
                                size: 35,
                              )
                            : Container(),
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
                            color: Theme.of(context).primaryColor,
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
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Opacity(
                    opacity: widget.selectListMode ? 0.0 : 0.3,
                    child: PopupMenuButton(
                      icon: Icon(
                        MaterialCommunityIcons.dots_vertical,
                        color: Theme.of(context).primaryColor,
                      ),
                      enabled: !widget.selectListMode,
                      itemBuilder: (context) {
                        final textStyle = TextStyle(fontSize: 14);
                        return [
                          widget.list.active
                              ? PopupMenuItem(
                                  child: Text('Move to inactive',
                                      style: textStyle),
                                  value: 1,
                                )
                              : PopupMenuItem(
                                  child:
                                      Text('Move to active', style: textStyle),
                                  value: 2,
                                ),
                          widget.list.favourite
                              ? PopupMenuItem(
                                  child: Text('Unfavourite', style: textStyle),
                                  value: 3,
                                )
                              : PopupMenuItem(
                                  child: Text('Favourite', style: textStyle),
                                  value: 4,
                                ),
                        ];
                      },
                      onSelected: (value) {
                        if (value == 1) {
                          widget.list.active = false;
                        } else if (value == 2) {
                          widget.list.active = true;
                        } else if (value == 3) {
                          widget.list.favourite = false;
                        } else if (value == 4) {
                          widget.list.favourite = true;
                        }
                        Provider.of<ListsProvider>(context, listen: false)
                            .updateList(widget.list);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
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
