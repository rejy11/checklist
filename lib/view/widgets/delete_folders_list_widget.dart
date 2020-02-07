import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/folder_model.dart';
import '../../providers/folders_provider.dart';

class DeleteFoldersListWidget extends StatefulWidget {
  @override
  _DeleteFoldersListWidgetState createState() =>
      _DeleteFoldersListWidgetState();
}

class _DeleteFoldersListWidgetState extends State<DeleteFoldersListWidget> {
  @override
  Widget build(BuildContext context) {
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
            return Card(
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
                      child: CircularCheckBox(
                        value: false,
                        onChanged: (value) {},
                      ),
                    )
                  ],
                ),
                subtitle: folder.numberOfLists != 1
                    ? Text('${folder.numberOfLists} items')
                    : Text('${folder.numberOfLists} item'),
              ),
            );
          },
        );
      },
    );
  }
}
