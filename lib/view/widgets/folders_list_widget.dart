import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../models/folder_model.dart';
import '../../providers/folders_provider.dart';
import '../widgets/folder_list_item_widget.dart';

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
  Duration _actionPanelSlideDuration = Duration(milliseconds: 150);

  @override
  void initState() {
    _actionPanelPosition = _actionPanelHeight * -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.delayed(Duration(milliseconds: 0), () {
          return _onBackPressed(); //way to wrap a synchronous method in async call
        });
      },
      child: Stack(
        children: [
          _buildBottomActionPanel(),
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
                padding: EdgeInsets.only(top: _listViewPadding),
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
        ],
      ),
    );
  }

  void onListItemLongPress() {
    Provider.of<FoldersProvider>(context, listen: false)
        .toggleDeleteFolderMode(true); // removes fab from screen
    _showPanel();
  }

  Widget _buildBottomActionPanel() {
    final bool atleastOneFolderChecked =
        Provider.of<FoldersProvider>(context, listen: false)
            .atleastOneFolderChecked();
    return AnimatedPositioned(
      top: _actionPanelPosition,
      duration: _actionPanelSlideDuration,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        child: Container(
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
                                provider.toggleAllFoldersDeleteCheckbox(value);
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
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(MaterialCommunityIcons.delete_outline),
                      onPressed: atleastOneFolderChecked ? _deleteFolder : null,
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
    );
  }

  void _hidePanel() {
    setState(() {
      _actionPanelPosition = _actionPanelHeight * -1;
      _listViewPadding = 0;
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
      _panelVisible = true;
    });
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
