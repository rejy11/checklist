import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../models/folder_model.dart';
import '../../providers/folders_provider.dart';
import '../widgets/folder_list_item_widget.dart';
import 'core/icon_above_text_button.dart';

class FoldersListWidget extends StatefulWidget {
  @override
  _FoldersListWidgetState createState() => _FoldersListWidgetState();
}

class _FoldersListWidgetState extends State<FoldersListWidget>
    with SingleTickerProviderStateMixin {
  double _bottomPanelHeight = 50;
  double _bottomPanelPosition;
  double _listViewBottomPadding = 0;
  Duration _bottomPanelSlideDuration = Duration(milliseconds: 150);

  @override
  void initState() {
    _bottomPanelPosition = _bottomPanelHeight * -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<List<FolderModel>>(
          future: Provider.of<FoldersProvider>(context).getFolders(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return AnimatedContainer(
              duration: _bottomPanelSlideDuration,
              padding: EdgeInsets.only(bottom: _listViewBottomPadding),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  final folder = snapshot.data[i];
                  return FolderListItemWidget(
                    folder: folder,
                    onLongPress: onListItemLongPress,
                  );
                },
              ),
            );
          },
        ),
        _buildBottomActionPanel(),
      ],
    );
  }

  void onListItemLongPress() {
    Provider.of<FoldersProvider>(context, listen: false)
        .toggleDeleteFolderMode(true); // removes fab from screen
    setState(() {
      _bottomPanelPosition = 0;
      _listViewBottomPadding = _bottomPanelHeight;
    });
  }

  Widget _buildBottomActionPanel() {
    final bool atleastOneFolderChecked =
        Provider.of<FoldersProvider>(context, listen: false)
            .atleastOneFolderChecked();
    return AnimatedPositioned(
      bottom: _bottomPanelPosition,
      duration: _bottomPanelSlideDuration,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Container(
          height: _bottomPanelHeight,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: IconAboveTextButton(
                    iconData: MaterialCommunityIcons.arrow_collapse_down,
                    text: 'Cancel',
                    textColour: Colors.black,
                    opacity: 0.65,
                    onTap: () {
                      Provider.of<FoldersProvider>(context, listen: false)
                          .toggleDeleteFolderMode(false);
                      setState(() {
                        _bottomPanelPosition = _bottomPanelHeight * -1;
                        _listViewBottomPadding = 0;
                      });
                    }),
              ),
              VerticalDivider(
                color: Colors.black26,
              ),
              Expanded(
                child: IconAboveTextButton(
                  iconData: MaterialCommunityIcons.star_outline,
                  opacity: 0.65,
                  onTap: null,
                ),
              ),
              VerticalDivider(
                color: Colors.black26,
              ),
              Expanded(
                child: IconAboveTextButton(
                  iconData: MaterialCommunityIcons.delete_outline,
                  text: 'Delete',
                  textColour: Colors.black,
                  opacity: 0.65,
                  onTap: atleastOneFolderChecked ? _deleteFolder : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteFolder() {
    Provider.of<FoldersProvider>(context, listen: false).deleteFolders();
    setState(() {
      _bottomPanelPosition = _bottomPanelHeight * -1;
      _listViewBottomPadding = 0;
    });
  }
}
