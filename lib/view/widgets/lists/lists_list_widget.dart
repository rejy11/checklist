import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

import '../../../models/list_model.dart';
import '../../../providers/lists_provider.dart';
import '../../screens/list_screen.dart';
import '../core/action_panel_widget.dart';
import 'lists_list_item_widget.dart';

class ListsListWidget extends StatefulWidget {
  final bool activeLists;

  ListsListWidget(this.activeLists);

  @override
  _ListsListWidgetState createState() => _ListsListWidgetState();
}

class _ListsListWidgetState extends State<ListsListWidget>
    with SingleTickerProviderStateMixin {
  ListsProvider _provider;
  double _actionPanelHeight = 50;
  double _actionPanelPosition;
  double _listViewPadding = 0;
  double _actionPanelOpacity = 0.0;
  Duration _actionPanelSlideDuration = Duration(milliseconds: 450);
  Duration _actionPanelOpacityDuration = Duration(milliseconds: 500);
  bool _panelVisible = false;

  @override
  void initState() {
    _actionPanelPosition = _actionPanelHeight * -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<ListsProvider>(context, listen: true);
    final lists = _provider.lists;

    return WillPopScope(
      onWillPop: () {
        return Future.delayed(const Duration(microseconds: 0), () {
          return _onBackPressed();
        });
      },
      child: Stack(
        children: [
          _buildActionPanel(),
          lists == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _buildListViewContainer(
                  lists.where((l) => l.active == widget.activeLists).toList(),
                  _provider.selectListMode,
                )
        ],
      ),
    );
  }

  Widget _buildListViewContainer(List<ListModel> lists, bool selectListMode) {
    return AnimatedContainer(
      duration: _actionPanelSlideDuration,
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(top: _listViewPadding),
      child: ListView.builder(
        itemCount: lists.length,
        itemBuilder: (context, i) {
          return ListsListItemWidget(
            selectListMode,
            _provider.isSelected(lists[i].id),
            list: lists[i],
            onLongPress: onListItemLongPress,
            onTap: () => _navigateToListItemScreen(lists[i].id, lists[i].name),
          );
        },
      ),
    );
  }

  Widget _buildActionPanel() {
    return ActionPanelWidget(
      _actionPanelPosition,
      _actionPanelSlideDuration,
      _actionPanelHeight,
      _actionPanelOpacity,
      _actionPanelOpacityDuration,
      contentLeft: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularCheckBox(
              value: _provider.allListsSelected(),
              inactiveColor: Colors.black26,
              onChanged: (value) {
                _provider.toggleAllListsSelected(value);
              },
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              'All',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      contentRight: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(MaterialCommunityIcons.delete_outline),
              disabledColor: Theme.of(context).disabledColor,
              onPressed: _provider.atleastOneListSelected()
                  ? () async => await _provider.deleteSelectedLists()
                  : null,
            ),
            IconButton(
            icon: Icon(MaterialCommunityIcons.chevron_up),
            color: Colors.white,
            onPressed: _hidePanel,
          ),
          ],
        ),
      ),
    );
  }

  void onListItemLongPress() {
    _provider.toggleSelectListMode(true);
    _showPanel();
  }

  void _showPanel() {
    setState(() {
      _actionPanelPosition = 0;
      _actionPanelOpacity = 1.0;
      _listViewPadding = _actionPanelHeight;
      _panelVisible = true;
    });
  }

  void _hidePanel() {
    setState(() {
      _actionPanelPosition = _actionPanelHeight * -1;
      _actionPanelOpacity = 0.0;
      _listViewPadding = 0;
      _panelVisible = false;
    });
    _provider.toggleSelectListMode(false);
  }

  bool _onBackPressed() {
    if (_panelVisible) {
      _hidePanel();
      return false;
    } else {
      return true;
    }
  }

  void _navigateToListItemScreen(int listId, String listName) {
    final pageRouteBuilder = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ListScreen(listId, listName),
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
}
