import 'package:b/ui/note_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Notes SQLite';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        // themeMode: ThemeMode.light,
        theme: ThemeData(
          primaryColor: Colors.greenAccent,
          scaffoldBackgroundColor: Color.fromARGB(255, 214, 214, 214),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(0, 12, 12, 12),
            elevation: 0,
          ),
        ),
        home: const NotesPage(),
      );
}
