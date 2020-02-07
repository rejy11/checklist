import 'package:checklist/providers/folders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/folders_list_widget.dart';
import '../widgets/new_folder_dialog_widget.dart';

class FoldersScreen extends StatefulWidget {
  @override
  _FoldersScreenState createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen>
    with TickerProviderStateMixin<FoldersScreen> {
  AnimationController _hideFabAnimation;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    _hideFabAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
      value: 1,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _hideFabAnimation,
      curve: Curves.easeIn,
    );

    super.initState();
  }

  @override
  void dispose() {
    _hideFabAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Your Folders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          Consumer<FoldersProvider>(
            builder:
                (BuildContext context, FoldersProvider value, Widget child) {
              return value.deleteFolderMode
                  ? Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            value.toggleDeleteFolderMode(false);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {},
                        ),
                      ],
                    )
                  : Row();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: FoldersListWidget(),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _newFolderDialog(context),
      //   child: Icon(Icons.add),
      //   elevation: 1,
      // ),
      floatingActionButton: Consumer<FoldersProvider>(
        builder: (BuildContext context, FoldersProvider value, Widget child) {
          if (!value.deleteFolderMode) {
            _hideFabAnimation.forward();
          } else {
            _hideFabAnimation.reverse();
          }
          return ScaleTransition(
            scale: _scaleAnimation,
            child: FloatingActionButton(
              onPressed: () => _newFolderDialog(context),
              child: Icon(Icons.add),
              elevation: 1,
            ),
          );
          // return Column(children: [
          //   if (!value.deleteFolderMode)
          //     FloatingActionButton(
          //       onPressed: () => _newFolderDialog(context),
          //       child: Icon(Icons.add),
          //     )
          // ]);
          // return Opacity(
          //   opacity: !value.deleteFolderMode ? 1 : 0,
          //   child: FloatingActionButton(
          //     onPressed: () => _newFolderDialog(context),
          //     child: Icon(Icons.add),
          //     elevation: 1,
          //   ),
          // );
        },
      ),
    );
  }
}

_newFolderDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) {
      return NewFolderDialogWidget();
    },
  );
}
