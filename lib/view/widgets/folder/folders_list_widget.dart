import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../../models/folder_model.dart';
import '../../../providers/folders_provider.dart';
import '../../screens/lists_screen.dart';
import '../folder/folder_list_item_widget.dart';

class FoldersListWidget extends StatefulWidget {
  @override
  _FoldersListWidgetState createState() => _FoldersListWidgetState();
}

class _FoldersListWidgetState extends State<FoldersListWidget>
    with SingleTickerProviderStateMixin {
  bool _panelVisible = false;
  double _actionPanelHeight = 50;
  double _actionPanelPosition;
  double _listViewPadding = 0;
  double _actionPanelOpacity = 1.0;
  Duration _actionPanelSlideDuration = Duration(milliseconds: 350);

  @override
  void initState() {
    _actionPanelPosition = _actionPanelHeight * -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.delayed(const Duration(milliseconds: 0), () {
          return _onBackPressed(); //way to wrap a synchronous method in async call
        });
      },
      child: Stack(
        children: [
          _buildActionPanel(),
          FutureBuilder<List<FolderModel>>(
            future: Provider.of<FoldersProvider>(context).folders,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return AnimatedContainer(
                duration: _actionPanelSlideDuration,
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.only(top: _listViewPadding),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    final folder = snapshot.data[i];
                    return FolderListItemWidget(
                      folder: folder,
                      onLongPress: onListItemLongPress,
                      onTap: () => _navigateToListsScreen(folder.id),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionPanel() {
    final bool atleastOneFolderChecked =
        Provider.of<FoldersProvider>(context, listen: false)
            .atleastOneFolderChecked();
    return AnimatedPositioned(
      top: _actionPanelPosition,
      curve: Curves.easeOutCubic,
      duration: _actionPanelSlideDuration,
      child: AnimatedOpacity(
        duration: _actionPanelSlideDuration,
        opacity: _actionPanelOpacity,
        curve: Curves.ease,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: AnimatedContainer(
            duration: _actionPanelSlideDuration,
            height: _actionPanelHeight,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 17),
                        child: Container(
                          width: 80,
                          child: Consumer<FoldersProvider>(
                            builder: (context, provider, child) {
                              return CircularCheckBox(
                                value: provider.allFoldersChecked,
                                onChanged: (value) {
                                  provider
                                      .toggleAllFoldersDeleteCheckbox(value);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        'All',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(MaterialCommunityIcons.delete_outline),
                        onPressed:
                            atleastOneFolderChecked ? _deleteFolder : null,
                        color: Colors.white,
                        disabledColor: Colors.white30,
                      ),
                      IconButton(
                        icon: Icon(MaterialCommunityIcons.chevron_up),
                        color: Colors.white,
                        onPressed: () {
                          _hidePanel();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _hidePanel() {
    setState(() {
      _actionPanelPosition = _actionPanelHeight * -1;
      _listViewPadding = 0;
      _actionPanelOpacity = 1.0;
      _panelVisible = false;
    });
    Provider.of<FoldersProvider>(context, listen: false)
        .toggleDeleteFolderMode(false);
    Provider.of<FoldersProvider>(context, listen: false)
        .toggleAllFoldersDeleteCheckbox(false);
  }

  void _showPanel() {
    setState(() {
      _actionPanelPosition = 0;
      _listViewPadding = _actionPanelHeight;
      _actionPanelOpacity = 1.0;
      _panelVisible = true;
    });
  }

  void _navigateToListsScreen(int folderId) {
    final pageRouteBuilder = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ListsScreen(folderId),
      transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.ease));
        var fadeTween =
            Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.ease));

        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
    );
    Navigator.of(context).push(pageRouteBuilder);
  }

  void onListItemLongPress() {
    Provider.of<FoldersProvider>(context, listen: false)
        .toggleDeleteFolderMode(true); // removes fab from screen
    _showPanel();
  }

  void _deleteFolder() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            title: Text(
              'Delete Folder',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Are you sure you want to delete the selected folders?',
              style: TextStyle(height: 2),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _hidePanel();
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 100), () async {
                    await Provider.of<FoldersProvider>(context, listen: false)
                        .deleteFolders();
                    _hidePanel();
                  });
                },
                child: Text('DELETE',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          );
        });
  }

  bool _onBackPressed() {
    if (_panelVisible) {
      _hidePanel();
      return false;
    } else {
      return true;
    }
  }
}
