import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../models/folder_model.dart';
import '../../providers/folders_provider.dart';

class FolderListItemWidget extends StatefulWidget {
  final FolderModel folder;
  final Function onLongPress;

  const FolderListItemWidget({
    this.folder,
    this.onLongPress,
  });

  @override
  _FolderListItemWidgetState createState() => _FolderListItemWidgetState();
}

class _FolderListItemWidgetState extends State<FolderListItemWidget>
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
        child: Row(
          children: [
            Container(
              color: widget.folder.isFavourite
                  ? Theme.of(context).accentColor
                  : Colors.transparent,
              height: 70,
              width: 7,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                child: ListTile(
                  selected: false,
                  title: Text(widget.folder.name),
                  onTap: () {},
                  onLongPress: widget.onLongPress,
                  trailing: _buildListItemTrailing(),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50,
                        child: Consumer<FoldersProvider>(
                          builder: (BuildContext context, FoldersProvider value,
                              Widget child) {
                            if (value.deleteFolderMode) {
                              return CircularCheckBox(
                                value: value.isFolderChecked(widget.folder.id),
                                onChanged: (value) {
                                  Provider.of<FoldersProvider>(context,
                                          listen: false)
                                      .toggleFolderDeleteCheckbox(
                                          widget.folder.id, value);
                                },
                              );
                            } else {
                              return Icon(
                                MaterialCommunityIcons.folder_outline,
                                color: Theme.of(context).accentColor,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  subtitle: widget.folder.numberOfLists != 1
                      ? Text('${widget.folder.numberOfLists} items')
                      : Text('${widget.folder.numberOfLists} item'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItemTrailing() {
    return PopupMenuButton(
      itemBuilder: (ctx) {
        return [
          PopupMenuItem(
            child: widget.folder.isFavourite
                ? Text('Unfavourite')
                : Text('Favourite'),
            value: 1,
          )
        ];
      },
      onSelected: (value) async {
        if (value == 1) {
          widget.folder.isFavourite = !widget.folder.isFavourite;
          Provider.of<FoldersProvider>(context, listen: false)
              .updateFolder(widget.folder);
          await _slideController.forward();
          await _slideController.reverse();
        }
      },
    );
  }
}
