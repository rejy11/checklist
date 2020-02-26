import 'package:checklist/models/list_model.dart';
import 'package:checklist/view/widgets/list/list_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/lists_provider.dart';

class ListsListWidget extends StatefulWidget {
  @override
  _ListsListWidgetState createState() => _ListsListWidgetState();
}

class _ListsListWidgetState extends State<ListsListWidget> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.delayed(const Duration(microseconds: 0), () {
          return _onBackPressed();
        });
      },
          child: Stack(
        children: [
          _buildActionPanel(),
          FutureBuilder<List<ListModel>>(
            future: Provider.of<ListsProvider>(context).lists,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  final list = snapshot.data[i];
                  return ListListItemWidget(
                    list: list,
                    onLongPress: null,
                    onTap: () {},
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionPanel() {

  }

  bool _onBackPressed() {
    return true;
  }
}
