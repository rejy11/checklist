import 'package:checklist/view/widgets/core/icon_above_text_button.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/folder_model.dart';
import '../../providers/folders_provider.dart';

class FoldersListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<FoldersProvider>(context);
    // final getAllFolders = provider.getFolders;

    return FutureBuilder<List<FolderModel>>(
      future: Provider.of<FoldersProvider>(context).getFolders(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, i) {
            final folder = snapshot.data[i];
            return Dismissible(
              onDismissed: (direction) {
                snapshot.data.removeAt(
                    i); // to avoid weird future builder issue with dismissible
                Provider.of<FoldersProvider>(context, listen: false)
                    .deleteFolder(folder.id);
              },
              background: Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 1,
                child: Container(
                  alignment: AlignmentDirectional.centerStart,
                  color: Theme.of(context).accentColor,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              key: UniqueKey(),
              direction: DismissDirection.startToEnd,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                elevation: 1,
                child: ListTile(
                  title: Text(folder.folderName),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50,
                        child: Consumer<FoldersProvider>(
                          builder: (BuildContext context, value, Widget child) {
                            return value.deleteFolderMode
                                ? CircularCheckBox(
                                    value: false,
                                    onChanged: (value) {},
                                  )
                                : Icon(
                                    Icons.folder,
                                    color: Theme.of(context).accentColor,
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                  subtitle: folder.numberOfLists != 1
                      ? Text('${folder.numberOfLists} items')
                      : Text('${folder.numberOfLists} item'),
                  onTap: () {},
                  onLongPress: () {
                    Provider.of<FoldersProvider>(context, listen: false)
                        .toggleDeleteFolderMode(true);
                    showBottomSheet(
                      elevation: 5,
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 70,
                          color: Theme.of(context).colorScheme.surface,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Expanded(
                                child: IconAboveTextButton(
                                  icon: Icon(Icons.cancel),
                                  text: 'Cancel',
                                  textColour: Colors.black,
                                  opacity: 0.65,
                                ),
                              ),
                              VerticalDivider(
                                color: Colors.black26,
                              ),
                              Expanded(
                                child: IconAboveTextButton(
                                  icon: Icon(Icons.delete),
                                  text: 'Delete',
                                  textColour: Colors.black,
                                  opacity: 0.65,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
