import 'package:flutter/material.dart';
import 'package:spb/services/shared_preferences_service.dart';
import 'package:spb/screens/login.dart';
import 'package:spb/screens/main_app.dart';

void main() {
  runApp(AuthCheck());
}

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  String _token;

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  Future<String> checkCurrentUser() async {
    try {
      _token = await sharedPreferenceService.getToken();

      return _token;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<String>(
          future: checkCurrentUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Scaffold(
                  body: Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              case ConnectionState.done:
                if (snapshot.data != null) {
                  return MainApp(token: _token);
                }

                return LoginScreen();
            }

            return null;
          },
        ));
  }
}

// For Mutations, we need the GraphQLClient object to update the database.
// First, we will initialise our GraphQLClient object inside our ToDo class.
// We can directly initialise client in the build(context){} as GraphQLClientneeds a context of the app to initialise itself. But, in this case, we have to wait for the context to get completely built, so that we can initialise it properly.
