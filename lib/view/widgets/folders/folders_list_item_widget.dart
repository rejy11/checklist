import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/folder_model.dart';
import '../../../providers/folders_provider.dart';
import '../core/text_field_submit_dialog.dart';
import 'folders_list_tile.dart';

class FoldersListItemWidget extends StatefulWidget {
  final FolderModel folder;
  final Function onLongPress;
  final Function onTap;

  const FoldersListItemWidget({
    this.folder,
    this.onLongPress,
    this.onTap,
  });

  @override
  _FoldersListItemWidgetState createState() => _FoldersListItemWidgetState();
}

class _FoldersListItemWidgetState extends State<FoldersListItemWidget>
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
        child: FoldersListTile(
          folder: widget.folder,
          onLongPress: widget.onLongPress,
          trailing: _buildListItemTrailing(),
          onTap: widget.onTap,
        ),
      ),
    );
  }

  Widget _buildListItemTrailing() {
    return Opacity(
      opacity: 0.3,
      child: PopupMenuButton(
        icon: Icon(Icons.edit),
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        itemBuilder: (ctx) {
          return [
            PopupMenuItem(
              child: widget.folder.isFavourite
                  ? Text(
                      'Unfavourite',
                      style: TextStyle(fontSize: 14),
                    )
                  : Text(
                      'Favourite',
                      style: TextStyle(fontSize: 14),
                    ),
              value: 1,
            ),
            PopupMenuItem(
              child: Text(
                'Change Name',
                style: TextStyle(fontSize: 14),
              ),
              value: 2,
            ),
          ];
        },
        onSelected: (value) async {
          if (value == 1) {
            widget.folder.isFavourite = !widget.folder.isFavourite;
            await Provider.of<FoldersProvider>(context, listen: false)
                .updateFolder(widget.folder);
            await _slideController.forward();
            await _slideController.reverse();
          } else if (value == 2) {
            showDialog(
              context: context,
              builder: (ctx) {
                return TextFieldAndSubmitDialog(                  
                  'Folder Name',
                  'Cancel',
                  'Add',
                  '',
                  text: widget.folder.name,
                  maxLength: 15,
                );
              },
            );
          }
        },
      ),
    );
  }

  _updateFolder(String text) async {
    widget.folder.name = text;
    await Provider.of<FoldersProvider>(context, listen: false)
        .updateFolder(widget.folder);
  }
}
