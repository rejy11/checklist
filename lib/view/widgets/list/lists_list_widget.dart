import 'package:checklist/models/list_model.dart';
import 'package:checklist/view/widgets/core/action_panel_widget.dart';
import 'package:checklist/view/widgets/list/list_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:provider/provider.dart';

import '../../../providers/lists_provider.dart';

class ListsListWidget extends StatefulWidget {
  @override
  _ListsListWidgetState createState() => _ListsListWidgetState();
}

class _ListsListWidgetState extends State<ListsListWidget>
    with SingleTickerProviderStateMixin {
  ListsProvider _provider;
  double _actionPanelHeight = 50;
  double _actionPanelPosition;
  double _listViewPadding = 0;
  Duration _actionPanelSlideDuration = Duration(milliseconds: 350);
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
              : _buildListViewContainer(lists),
        ],
      ),
    );
  }

  Widget _buildListViewContainer(List<ListModel> lists) {
    final activeLists = lists.where((l) => l.active).toList();
    final inactiveLists = lists.where((l) => !l.active).toList();

    return AnimatedContainer(
      duration: _actionPanelSlideDuration,
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(top: _listViewPadding),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: MySliverPersistentHeader(50, 'Active Lists'),
            pinned: true,
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return ListListItemWidget(
                list: activeLists[index],
                onLongPress: onListItemLongPress,
                onTap: () {},
              );
            }, childCount: activeLists.length),
          ),
          SliverPersistentHeader(
            delegate: MySliverPersistentHeader(50, 'Inactive Lists'),
            pinned: true,
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return ListListItemWidget(
                list: inactiveLists[index],
                onLongPress: onListItemLongPress,
                onTap: () {},
              );
            }, childCount: inactiveLists.length),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPanel() {
    return ActionPanelWidget(
      _actionPanelPosition,
      _actionPanelSlideDuration,
      _actionPanelHeight,
    );
  }

  void onListItemLongPress() {
    _showPanel();
  }

  void _showPanel() {
    setState(() {
      _actionPanelPosition = 0;
      _listViewPadding = _actionPanelHeight;
      _panelVisible = true;
    });
  }

  void _hidePanel() {
    setState(() {
      _actionPanelPosition = _actionPanelHeight * -1;
      _listViewPadding = 0;
      _panelVisible = false;
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

class MySliverPersistentHeader implements SliverPersistentHeaderDelegate {
  final double height;
  final String title;

  MySliverPersistentHeader(
    this.height,
    this.title,
  );

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: Theme.of(context).accentColor,
          height: constraints.maxHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;
}
