import 'package:flutter/material.dart';
import 'package:spb/screens/login.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spb/config/client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final routes = {'/login': (context) => LoginScreen()};

    return GraphQLProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: routes,
        home: LoginScreen(),
      ),
      client: Config.initailizeClient(""),
    );
  }
}
