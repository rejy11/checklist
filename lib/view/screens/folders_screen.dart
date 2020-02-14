import 'package:checklist/enums/folders_order_by.dart';
import 'package:checklist/providers/folders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
        elevation: 0,
        centerTitle: false,titleSpacing: 30,
        title: Text(
          'Your Folders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          Consumer<FoldersProvider>(builder: (context, value, child) {
            final orderBy = value.orderBy;
            const textStyle = TextStyle(fontSize: 14);
            return PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)                
              ),
              itemBuilder: (ctx) {
                return [
                  CheckedPopupMenuItem(
                    child: Text('Newest', style: textStyle,),
                    checked: orderBy == FoldersOrderBy.Newest,
                    value: FoldersOrderBy.Newest,
                  ),
                  CheckedPopupMenuItem(
                    child: Text('Oldest', style: textStyle,),
                    checked: orderBy == FoldersOrderBy.Oldest,
                    value: FoldersOrderBy.Oldest,
                  ),
                  CheckedPopupMenuItem(
                    child: Text('Favourite', style: textStyle,),
                    checked: orderBy == FoldersOrderBy.Favourite,
                    value: FoldersOrderBy.Favourite,
                  ),
                ];
              },
              onSelected: (value) {
                if (value is FoldersOrderBy) {
                  Provider.of<FoldersProvider>(context, listen: false)
                      .setOrderBy(value);
                }
              },
              icon: Icon(MaterialCommunityIcons.sort),
            );
          }),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _newFolderDialog(context),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: FoldersListWidget(),
            ),
          ),
        ],
      ),
      // floatingActionButton: Consumer<FoldersProvider>(
      //   builder: (BuildContext context, FoldersProvider value, Widget child) {
      //     if (!value.deleteFolderMode) {
      //       _hideFabAnimation.forward();
      //     } else {
      //       _hideFabAnimation.reverse();
      //     }
      //     return ScaleTransition(
      //       scale: _scaleAnimation,
      //       child: FloatingActionButton(
      //         onPressed: () => _newFolderDialog(context),
      //         child: Icon(Icons.add),
      //         elevation: 1,
      //       ),
      //     );
      //   },
      // ),
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
