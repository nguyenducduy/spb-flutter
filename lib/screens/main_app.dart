import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spb/config/client.dart';
import 'package:spb/screens/welcome.dart';
import 'package:spb/screens/tutorial.dart';
import 'package:spb/screens/connect.dart';
import 'package:spb/screens/add_pill.dart';

class MainApp extends StatelessWidget {
  final token;

  const MainApp({Key key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/welcome': (context) => WelcomeScreen(),
      '/tutorial': (context) => TutorialScreen(),
      '/connect': (context) => ConnectScreen(),
      '/addpill': (context) => AddPillScreen(),
    };

    print(token);

    return GraphQLProvider(
      client: Config.initailizeClient(token),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Colors.indigoAccent,
              accentColor: Colors.indigoAccent,
              accentColorBrightness: Brightness.dark),
          routes: routes,
          home: AddPillScreen()),
    );
  }
}
