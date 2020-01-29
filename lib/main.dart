import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'container/injection_container.dart';
import 'providers/folders_provider.dart';
import 'view/screens/folders_screen.dart';

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
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Checklist',
        theme: ThemeData(
          colorScheme: colourScheme,
          brightness: Brightness.light,
          primaryColor: Colors.indigo[500],
          accentColor: Colors.amber[500],
          backgroundColor: colourScheme.background,
        ),
        home: FoldersScreen(),
      ),
      providers: [
        ChangeNotifierProvider<FoldersProvider>(
          create: (ctx) => FoldersProvider(serviceLocator()),
        )
      ],
    );
  }
}
