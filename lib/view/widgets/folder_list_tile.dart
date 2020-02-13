import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../models/folder_model.dart';
import '../../providers/folders_provider.dart';

class FolderListTile extends StatelessWidget {
  final FolderModel folder;
  final Function onTap;
  final Function onLongPress;
  final Widget trailing;

  const FolderListTile({
    this.folder,
    this.onTap,
    this.onLongPress,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Row(
          children: <Widget>[
            //favourite indicator
            Container(
              color: folder.isFavourite
                  ? Theme.of(context).accentColor
                  : Colors.transparent,
              height: 70,
              width: 7,
            ),
            //folder icon/checkbox
            Container(
              width: 80,
              child: Consumer<FoldersProvider>(
                builder: (BuildContext context, FoldersProvider value,
                    Widget child) {
                  if (value.deleteFolderMode) {
                    return CircularCheckBox(
                      value: value.isFolderChecked(folder.id),
                      onChanged: (value) {
                        Provider.of<FoldersProvider>(context, listen: false)
                            .toggleFolderDeleteCheckbox(folder.id, value);
                      },
                    );
                  } else {
                    return Icon(
                      folder.isFavourite
                          ? MaterialCommunityIcons.folder_star_outline
                          : MaterialCommunityIcons.folder_outline,
                      color: Theme.of(context).accentColor,
                    );
                  }
                },
              ),
            ),
            //folder name + number of items
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 10),
                  child: Text(
                    folder.name,
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
            trailing != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: trailing,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _getNumberOfItemsText() {
    final textStyle = TextStyle(fontSize: 12);
    if (folder.numberOfLists != 1) {
      return Text(
        '${folder.numberOfLists} items',
        style: textStyle,
      );
    }
    return Text(
      '${folder.numberOfLists} item',
      style: textStyle,
    );
  }
}
