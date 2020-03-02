import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart' as Constants;
import '../../providers/lists_provider.dart';
import '../widgets/core/text_field_submit_dialog.dart';
import '../widgets/lists/lists_list_widget.dart';

class ListsScreen extends StatelessWidget {
  final int folderId;
  final String folderName;

  ListsScreen(
    this.folderId,
    this.folderName,
  );

  @override
  Widget build(BuildContext context) {
    Provider.of<ListsProvider>(context, listen: false)
        .loadListsForFolder(folderId);

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
              // Padding(
              //   padding: const EdgeInsets.only(right: 8),
              //   child: Icon(MaterialCommunityIcons.format_list_checkbox),
              // ),
              Text(
                folderName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return TextFieldAndSubmitDialog(
                      (text) async => await Provider.of<ListsProvider>(context,
                              listen: false)
                          .insertList(text),
                      'List Name',
                      maxLength: 15,
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 56),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListsListWidget(),
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
    );
  }
}
