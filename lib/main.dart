import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants.dart' as Constants;
import 'container/injection_container.dart';
import 'providers/folders_provider.dart';
import 'providers/list_items_provider.dart';
import 'providers/lists_provider.dart';
import 'services/local_notification_service.dart';
import 'view/screens/list_screen.dart';
import 'view/screens/lists_screen.dart';

// NotificationAppLaunchDetails notificationAppLaunchDetails;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  runApp(App(serviceLocator()));
}

class App extends StatefulWidget {
  final LocalNotificationService localNotificationService;

  App(this.localNotificationService);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // final colourScheme = ColorScheme(
  //   primary: Colors.indigo[500],
  //   background: Colors.indigo[50],
  //   brightness: Brightness.light,
  //   error: Colors.red,
  //   onBackground: Colors.black,
  //   onError: Colors.black,
  //   onPrimary: Colors.white,
  //   onSecondary: Colors.black,
  //   primaryVariant: Color.fromARGB(255, 0, 41, 132),
  //   secondaryVariant: Color.fromARGB(255, 199, 145, 0),
  //   secondary: Colors.amber[500],
  //   surface: Colors.grey[100],
  //   onSurface: Colors.black,
  // );

  @override
  void initState() {
    super.initState();
    widget.localNotificationService.initialise();
    widget.localNotificationService.configureSelectNotificationSubject(
      (int listId) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListScreen(listId, 'Your Listssss')),
      ),
    );
    // _configureSelectNotificationSubject();
  }

  @override
  void dispose() {
    // selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Constants.BACKGROUND_GRADIENT_START));
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Checklist',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Constants.BACKGROUND_GRADIENT_START,
          accentColor: Constants.BACKGROUND_GRADIENT_END,
          iconTheme: IconThemeData(color: Colors.white),
          appBarTheme:
              AppBarTheme(actionsIconTheme: Theme.of(context).iconTheme),
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
