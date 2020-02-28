import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart' as Constants;
import '../../providers/list_items_provider.dart';
import '../widgets/list/list_widget.dart';

class ListScreen extends StatelessWidget {
  final int listId;
  final String listName;

  ListScreen(
    this.listId,
    this.listName,
  );
  @override
  Widget build(BuildContext context) {
    Provider.of<ListItemsProvider>(context, listen: false)
        .loadListItemsForList(listId);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(listName,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        body: Container(
          child: ListWidget(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // Color.fromARGB(255, 155, 197, 195),
                // Color.fromARGB(255, 97, 97, 97),

                Constants.BACKGROUND_GRADIENT_START,
                Constants.BACKGROUND_GRADIENT_END,

                // Color.fromARGB(255, 19, 106, 138),
                // Color.fromARGB(255, 38, 120, 113),

                // Color.fromARGB(255, 19, 80, 88),
                // Color.fromARGB(255, 241, 242, 181)
              ],
              // stops: [0.3, 1]
            ),
          ),
        ),
      ),
    );
  }
}
