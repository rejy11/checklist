import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../constants.dart' as Constants;
import '../../enums/folders_order_by.dart';
import '../../providers/folders_provider.dart';
import '../widgets/core/text_field_submit_dialog.dart';
import '../widgets/folders/folders_list_widget.dart';

class FoldersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<FoldersProvider>(context, listen: false).loadFolders();

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(MaterialCommunityIcons.folder_outline),
              ),
              Text(
                'Your Folders',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            Consumer<FoldersProvider>(
              builder: (context, value, child) {
                final deleteFolderMode = value.deleteFolderMode;
                return PopupMenuButton(
                  enabled: !deleteFolderMode,
                  onSelected: (value) {
                    if (value == 'SortOrder') {
                      _showSortOrderBottomSheet(context);
                    }
                  },
                  itemBuilder: (ctx) {
                    return [
                      PopupMenuItem(
                        child: Text('Sort Order'),
                        value: 'SortOrder',
                      ),
                    ];
                  },
                );
              },
            ),
            Consumer<FoldersProvider>(
              builder: (context, value, child) {
                final deleteFolderMode = value.deleteFolderMode;
                return deleteFolderMode
                    ? IconButton(
                        icon: Icon(Icons.add),
                        onPressed: null,
                        disabledColor: Theme.of(context).disabledColor,
                      )
                    : IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) {
                              return TextFieldAndSubmitDialog(
                                (text) async =>
                                    await Provider.of<FoldersProvider>(context,
                                            listen: false)
                                        .insertFolder(text),
                                'Folder Name',
                                maxLength: 15,
                              );
                            },
                          );
                        },
                      );
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 56),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: FoldersListWidget(),
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Constants.BACKGROUND_GRADIENT_START,
                      Constants.BACKGROUND_GRADIENT_END,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showSortOrderBottomSheet(BuildContext context) {
    final radioButtonTextStyle = TextStyle(fontSize: 16);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   systemNavigationBarIconBrightness: Brightness.dark,
    //   systemNavigationBarColor: Colors.black45,
    // ));

    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Consumer<FoldersProvider>(
                  builder: (context, value, child) {
                    final orderBy = value.orderBy;
                    return Column(
                      children: <Widget>[
                        child,
                        Row(
                          children: <Widget>[
                            Radio(
                              value: FoldersOrderBy.Newest,
                              groupValue: orderBy,
                              onChanged: (value) {
                                Provider.of<FoldersProvider>(context,
                                        listen: false)
                                    .setOrderBy(FoldersOrderBy.Newest);
                              },
                            ),
                            Center(
                              child:
                                  Text('Newest', style: radioButtonTextStyle),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                              value: FoldersOrderBy.Oldest,
                              groupValue: orderBy,
                              onChanged: (value) {
                                Provider.of<FoldersProvider>(context,
                                        listen: false)
                                    .setOrderBy(FoldersOrderBy.Oldest);
                              },
                            ),
                            Text('Oldest', style: radioButtonTextStyle),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                              value: FoldersOrderBy.Favourite,
                              groupValue: orderBy,
                              onChanged: (value) {
                                Provider.of<FoldersProvider>(context,
                                        listen: false)
                                    .setOrderBy(FoldersOrderBy.Favourite);
                              },
                            ),
                            Text('Favourite', style: radioButtonTextStyle),
                          ],
                        ),
                      ],
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sort By',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    //SystemChrome.restoreSystemUIOverlays();
  }
}
