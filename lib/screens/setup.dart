import 'package:flutter/material.dart';

class SetupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Xin chào',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Arial')),
                SizedBox(
                  height: 10,
                ),
                Text('Cùng thiết lập hộp thuốc thông minh',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Arial')),
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.all(28.0),
                  color: Colors.grey[300],
                  height: 300,
                  child: SizedBox(
                    width: 80,
                  ),
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.indigoAccent,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(14.0),
                    child: Text('Bắt đầu'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/tutorial');
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
