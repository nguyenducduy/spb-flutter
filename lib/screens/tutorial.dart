import 'package:flutter/material.dart';

class TutorialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Hướng dẫn sử dụng"),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                ),
                Text('Mời bạn xem video sau đây cách sử dụng',
                    style: TextStyle(
                        fontSize: 16,
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
                    width: double.infinity,
                  ),
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    color: Colors.indigoAccent,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(14.0),
                    child: Text('Tiếp tục'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/connect');
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
