import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'container/injection_container.dart';
import 'providers/folders_provider.dart';
import 'providers/list_items_provider.dart';
import 'providers/lists_provider.dart';
import 'view/screens/lists_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(App());
}

class App extends StatelessWidget {
  final colourScheme = ColorScheme(
    primary: Colors.indigo[500],
    background: Colors.indigo[50],
    brightness: Brightness.light,
    error: Colors.red,
    onBackground: Colors.black,
    onError: Colors.black,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    primaryVariant: Color.fromARGB(255, 0, 41, 132),
    secondaryVariant: Color.fromARGB(255, 199, 145, 0),
    secondary: Colors.amber[500],
    surface: Colors.grey[100],
    onSurface: Colors.black,
    
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: BACKGROUND_GRADIENT_START));
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Checklist',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.deepPurple[700],
          accentColor: Colors.deepPurpleAccent[100],
          iconTheme: IconThemeData(color: Colors.white),
          appBarTheme: AppBarTheme(actionsIconTheme: Theme.of(context).iconTheme),
          buttonTheme: ButtonThemeData(disabledColor: Colors.black26),
          errorColor: Colors.red[600],
          fontFamily: 'Comfortaa',
          primaryColorLight: Color.fromARGB(255, 117, 125, 232),
          disabledColor: Colors.white38,
        ),
        home: ListsScreen(1, 'Your Lists'),
      ),
      providers: [
        ChangeNotifierProvider<FoldersProvider>(
          create: (ctx) => FoldersProvider(
            serviceLocator(),
            serviceLocator(),
          ),
        ),
        ChangeNotifierProvider<ListsProvider>(
          create: (ctx) => ListsProvider(
            serviceLocator(),
          ),
        ),
        ChangeNotifierProvider<ListItemsProvider>(
          create: (ctx) => ListItemsProvider(
            serviceLocator(),
          ),
        ),
      ],
    );
  }
}
