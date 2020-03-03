import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants.dart' as Constants;
import '../../providers/lists_provider.dart';
import '../widgets/core/text_field_submit_dialog.dart';
import '../widgets/lists/lists_list_widget.dart';

class ListsScreen extends StatefulWidget {
  final int folderId;
  final String folderName;

  ListsScreen(
    this.folderId,
    this.folderName,
  );

  @override
  _ListsScreenState createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ListsProvider>(context, listen: false)
        .loadListsForFolder(widget.folderId);
    _tabController.addListener(() {
      Provider.of<ListsProvider>(context, listen: false)
          .toggleSelectListMode(false);
    });

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.folderName,
            style: TextStyle(
                // color: Theme.of(context).accentColor,
                ),
          ),
          centerTitle: true,
          actions: <Widget>[
            Consumer<ListsProvider>(
              builder: (ctx, value, child) {
                if (!value.selectListMode) {
                  return IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    disabledColor: Theme.of(context).disabledColor,
                    onPressed: () async => await _newListDialog(context),
                  );
                } else {
                  return IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).disabledColor,
                    ),
                    onPressed: null,
                  );
                }
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Container(
                child: Text('Active'),
              ),
              Container(
                child: Text('Inactive'),
              ),
            ],
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black54,
            labelPadding: EdgeInsets.all(10),
          ),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 110),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListsListWidget(true),
                  ListsListWidget(false),
                ],
              ),
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

  Future _newListDialog(BuildContext context) async {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    await showDialog(
      context: context,
      builder: (ctx) {
        return TextFieldAndSubmitDialog(
          (text) async =>
              await Provider.of<ListsProvider>(context, listen: false)
                  .insertList(text),
          'List Name',
          maxLength: 15,
        );
      },
    );
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Constants.BACKGROUND_GRADIENT_START));
  }
}
