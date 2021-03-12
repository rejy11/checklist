import 'package:checklist/helpers/app_theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../constants.dart' as Constants;
import '../../enums/lists_sort.dart';
import '../../enums/order_by.dart';
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
        appBar: AppBar(
          // backgroundColor: Constants.BACKGROUND_GRADIENT_START,
          elevation: 0,
          title: Text(
            widget.folderName,
          ),
          centerTitle: true,
          actions: _buildAppBarActions(),
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
            indicatorSize: TabBarIndicatorSize.tab,
            // indicatorColor: Colors.white,
            // labelColor: Colors.white,
            unselectedLabelColor: Colors.black54,
            labelPadding: EdgeInsets.all(10),
          ),
        ),
        body: Container(
          // color: Constants.BACKGROUND_GRADIENT_END,
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
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      Consumer<ListsProvider>(
        builder: (ctx, value, child) {
          Color iconColour = Theme.of(context).iconTheme.color;
          Function onPressed = () async => await _newListDialog();
          if (value.selectListMode) {
            iconColour = Theme.of(context).disabledColor;
            onPressed = null;
          }
          return IconButton(
            icon: Icon(
              Icons.add,
              color: iconColour,
            ),
            onPressed: onPressed,
          );
        },
      ),
      Consumer<ListsProvider>(
        builder: (ctx, value, child) {
          Color iconColour = Theme.of(context).iconTheme.color;
          Function onPressed = () async => await _sortOrderDialog(
              value.sortBy, value.orderBy, value.isFavouritesPinned);
          if (value.selectListMode) {
            iconColour = Theme.of(context).disabledColor;
            onPressed = null;
          }
          return IconButton(
            icon: Icon(
              MaterialCommunityIcons.sort_variant,
              color: iconColour,
            ),
            onPressed: onPressed,
          );
        },
      ),
    ];
  }

  Future _sortOrderDialog(
      ListsSort sort, OrderBy order, bool pinFavourites) async {
    AppThemeHelper.applyStatusBarThemeForDialog(context);
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Sort Order',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Sort by:',
                      style: TextStyle(fontSize: 14),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Consumer<ListsProvider>(
                          builder: (ctx, value, child) {
                            return Radio(
                              value: ListsSort.DateCreated,
                              groupValue: value.sortBy,
                              onChanged: (_) {
                                Provider.of<ListsProvider>(context,
                                        listen: false)
                                    .setUserSettingsForScreen(
                                        ListsSort.DateCreated, value.orderBy);
                              },
                            );
                          },
                        ),
                        Center(child: Text('Date Created')),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Order by:',
                      style: TextStyle(fontSize: 14),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Consumer<ListsProvider>(
                          builder: (ctx, value, child) {
                            return Radio(
                              value: OrderBy.Ascending,
                              groupValue: value.orderBy,
                              onChanged: (_) {
                                Provider.of<ListsProvider>(context,
                                        listen: false)
                                    .setUserSettingsForScreen(
                                        value.sortBy, OrderBy.Ascending);
                              },
                            );
                          },
                        ),
                        Center(child: Text('Ascending')),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Consumer<ListsProvider>(
                          builder: (ctx, value, child) {
                            return Radio(
                              value: OrderBy.Descending,
                              groupValue: value.orderBy,
                              onChanged: (_) {
                                Provider.of<ListsProvider>(context,
                                        listen: false)
                                    .setUserSettingsForScreen(
                                        value.sortBy, OrderBy.Descending);
                              },
                            );
                          },
                        ),
                        Center(child: Text('Descending')),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Pin favourites?',
                          style: TextStyle(fontSize: 16),
                        ),
                        Consumer<ListsProvider>(
                          builder: (ctx, provider, child) {
                            return Switch(
                              value: provider.isFavouritesPinned,
                              onChanged: (value) {
                                provider.setIsFavouritesPinnedSetting(value);
                              },
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) => AppThemeHelper.applyStatusBarTheme(context));
  }

  Future _newListDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return TextFieldAndSubmitDialog(
          'Name',
          'Cancel',
          'Add',
          'New List',
          maxLength: 15,
          negativeButtonOnPressed: () {
            Navigator.of(context).pop();
          },
          positiveButtonOnPressed: (text) async {
            Navigator.of(context).pop();
            await Provider.of<ListsProvider>(context, listen: false)
                .insertList(text);
          },
        );
      },
    ).then((_) => AppThemeHelper.applyStatusBarTheme(context));
  }
}
