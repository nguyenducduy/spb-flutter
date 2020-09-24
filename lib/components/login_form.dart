import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spb/graphql/user.dart';
import 'package:spb/services/shared_preferences_service.dart';
import 'package:spb/config/client.dart';
import 'package:spb/screens/main_app.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController(text: "duy@olli-ai.com");
  TextEditingController _password = TextEditingController(text: "12345678");
  bool loading = false;
  GraphQLClient _client;

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _client = GraphQLProvider.of(context).value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!loading) {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
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
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text('Đăng nhập'),
                  color: Colors.indigoAccent,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(14.0),
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

                        final QueryResult mutationResult = await _client.mutate(
                            MutationOptions(
                                documentNode: gql(UserGraphql.login),
                                variables: {
                              'uid': userServiceAuthInfo['id'],
                              'email': userServiceAuthInfo['email'],
                              'fullName': userServiceAuthInfo['full_name'],
                              'accessToken': userServiceAuthInfo['access_token']
                            }));

                        setState(() {
                          loading = false;
                        });

                        if (mutationResult.hasException == false) {
                          final _token =
                              mutationResult.data['loginUser']['token'];
                          final _user =
                              mutationResult.data['loginUser']['user'];
                          Config.initailizeClient(_token);
                          await sharedPreferenceService.setToken(_token);
                          await sharedPreferenceService.setUser(_user);

                          print('Login success');
                          return MainApp(
                            token: _token,
                          );
                        } else {
                          print('Error mutate loginUser graphql.');
                        }
                      } on SocketException {
                        return null;
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
