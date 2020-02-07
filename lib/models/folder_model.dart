class FolderModel {
  int id;
  String folderName;
  DateTime dateTimeCreated;
  int numberOfLists;
  //List<ListModel> lists;

  FolderModel({
    this.id,
    this.folderName,
    this.dateTimeCreated,
    this.numberOfLists,
  });
}
