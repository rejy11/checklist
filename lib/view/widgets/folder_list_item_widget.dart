import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/folder_model.dart';
import '../../providers/folders_provider.dart';
import 'folder_list_tile.dart';

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
        child: FolderListTile(
          folder: widget.folder,
          onLongPress: widget.onLongPress,
          trailing: _buildListItemTrailing(),
        ),
      ),
    );
  }

  Widget _buildListItemTrailing() {
    return Opacity(
      opacity: 0.3,
          child: PopupMenuButton(
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
      ),
    );
  }
}