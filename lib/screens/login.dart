import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spb/config/client.dart';
import 'package:spb/graphql/user.dart';
import 'package:spb/services/shared_preferences_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _email = TextEditingController(text: "");
  TextEditingController _password = TextEditingController(text: "");
  bool loading = false;

  VoidCallback refetchQuery;
  @override
  Widget build(BuildContext context) {
    if (!loading) {
      return Scaffold(
          body: Mutation(
        options: MutationOptions(
          documentNode: gql(UserGraphql.login),
          update: (cache, result) {
            if (result.hasException) {
              print(['optimistic', result.exception.toString()]);
            }
          },
        ),
        builder: (RunMutation runMutation, QueryResult result) {
          return Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _titleWidget(),
                      _emailPasswordWidget(),
                      FlatButton(
                        child: Text('Đăng nhập'),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });

                            try {
                              final response = await http.post(
                                  "https://staging.users.iviet.com/v1/auth/login",
                                  headers: {
                                    "Accept": "application/json",
                                    "content-type": "application/json",
                                  },
                                  body: jsonEncode({
                                    'email': _email.text.trim(),
                                    'password': _password.text.trim()
                                  }));

                              final userServiceAuthInfo =
                                  json.decode(response.body)['data'];

                              // print(userServiceAuthInfo);

                              runMutation({
                                'uid': userServiceAuthInfo['id'],
                                'email': userServiceAuthInfo['email'],
                                'fullName': userServiceAuthInfo['full_name'],
                                'accessToken':
                                    userServiceAuthInfo['access_token']
                              });

                              setState(() {
                                loading = false;
                              });
                              // print(result.data['loginUser']);
                              final _token = result.data['loginUser']['token'];
                              print(_token);

                              if (_token != null) {
                                await sharedPreferenceService.setToken(_token);
                                Config.initailizeClient(_token);
                              } else {
                                setState(() {
                                  loading = false;
                                });
                              }
                            } on SocketException {
                              return null;
                            }
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(28.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Bạn đã có tài khoản?'),
                            FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text('Đăng nhập ngay',
                                    style:
                                        TextStyle(color: Colors.indigoAccent)))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        },
      ));
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Widget _titleWidget() {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.green,
            height: 80,
            child: SizedBox(
              width: 60,
              height: 100,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Đăng nhập',
                style: TextStyle(
                    color: Colors.blueGrey[500],
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto')),
          )
        ],
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          TextFormField(
            key: Key("Email"),
            controller: _email,
            decoration: InputDecoration(labelText: "Email"),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            key: Key("Password"),
            controller: _password,
            decoration: InputDecoration(labelText: "Password"),
            validator: (value) {
              return value.length < 8
                  ? "Password must be at least 8 characters long"
                  : null;
            },
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
