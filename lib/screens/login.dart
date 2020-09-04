import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:spb/config/client.dart';
import 'package:spb/components/login_form.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: Config.initailizeClient(''),
      child: MaterialApp(
          home: Scaffold(
              body: Container(
                  child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _titleWidget(),
              LoginForm(),
              Padding(
                padding: EdgeInsets.all(28.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bạn chưa có tài khoản?'),
                    FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text('Đăng ký ngay',
                            style: TextStyle(color: Colors.indigoAccent)))
                  ],
                ),
              ),
            ],
          ),
        ),
      )))),
    );
  }

  Widget _titleWidget() {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.grey[300],
            height: 100,
            child: SizedBox(
              width: 60,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Đăng nhập',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Arial')),
          )
        ],
      ),
    );
  }
}
