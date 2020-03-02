import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:provider/provider.dart';

import '../../../models/list_model.dart';
import '../../../providers/lists_provider.dart';
import '../../screens/list_screen.dart';
import '../core/action_panel_widget.dart';
import 'lists_list_item_widget.dart';

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
            delegate: ListsSliverHeader(50, 'Active Lists'),
            pinned: true,
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return ListsListItemWidget(
                list: activeLists[index],
                onLongPress: onListItemLongPress,
                onTap: () => _navigateToListItemScreen(
                    activeLists[index].id, activeLists[index].name),
              );
            }, childCount: activeLists.length),
          ),
          SliverPersistentHeader(
            delegate: ListsSliverHeader(50, 'Inactive Lists'),
            pinned: true,
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return ListsListItemWidget(
                list: inactiveLists[index],
                onLongPress: onListItemLongPress,
                onTap: () => _navigateToListItemScreen(
                    inactiveLists[index].id, inactiveLists[index].name),
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

class ListsSliverHeader implements SliverPersistentHeaderDelegate {
  final double height;
  final String title;

  ListsSliverHeader(
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
          height: constraints.maxHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
  // TODO: implement snapConfiguration
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  // TODO: implement stretchConfiguration
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;
}
