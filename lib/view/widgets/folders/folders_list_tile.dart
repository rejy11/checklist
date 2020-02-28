import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/folder_model.dart';
import '../../../providers/folders_provider.dart';

class FoldersListTile extends StatefulWidget {
  final FolderModel folder;
  final Function onTap;
  final Function onLongPress;
  final Widget trailing;

  const FoldersListTile({
    this.folder,
    this.onTap,
    this.onLongPress,
    this.trailing,
  });

  @override
  _FoldersListTileState createState() => _FoldersListTileState();
}

class _FoldersListTileState extends State<FoldersListTile>
    with SingleTickerProviderStateMixin {
  double _checkboxContainerWidth = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FoldersProvider>(context, listen: false);
    final deleteFolderMode = provider.deleteFolderMode;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
      child: InkWell(
        onTap: !deleteFolderMode
            ? widget.onTap
            : () {
                Provider.of<FoldersProvider>(context, listen: false)
                    .toggleFolderDeleteCheckbox(
                  widget.folder.id,
                  !widget.folder.isCheckedToBeDeleted,
                );
              },
        onLongPress: widget.onLongPress,
        child: Row(
          children: <Widget>[
            //favourite indicator
            Container(
              color: widget.folder.isFavourite
                  ? Theme.of(context).accentColor
                  : Colors.transparent,
              height: 80,
              width: 7,
            ),
            //folder icon/checkbox
            Consumer<FoldersProvider>(
              builder: (context, value, child) {
                _checkboxContainerWidth = value.deleteFolderMode ? 80 : 30;
                var _showCheckbox = _checkboxContainerWidth == 80;

                return AnimatedContainer(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 350),
                  width: _checkboxContainerWidth,
                  child: _showCheckbox
                      ? CircularCheckBox(
                          value: widget.folder.isCheckedToBeDeleted,
                          onChanged: (value) {
                            Provider.of<FoldersProvider>(context, listen: false)
                                .toggleFolderDeleteCheckbox(
                                    widget.folder.id, value);
                          },
                        )
                      : Container(),
                );
              },
            ),
            //folder name + number of items
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 10),
                  child: Text(
                    widget.folder.name,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
                Opacity(
                  opacity: 0.6,
                  child: _getNumberOfItemsText(),
                ),
              ],
            ),
            //white space
            Expanded(child: SizedBox()),
            //popup menu
            widget.trailing != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: widget.trailing,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _getNumberOfItemsText() {
    final textStyle = TextStyle(fontSize: 12);
    if (widget.folder.numberOfLists != 1) {
      return Text(
        '${widget.folder.numberOfLists} lists',
        style: textStyle,
      );
    }
    return Text(
      '${widget.folder.numberOfLists} list',
      style: textStyle,
    );
  }
}
