import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:spb/graphql/pill_form.dart';
import 'package:spb/graphql/pill.dart';

class AddPillScreen extends StatefulWidget {
  AddPillScreen({Key key}) : super(key: key);

  @override
  _AddPillScreenState createState() => _AddPillScreenState();
}

class _AddPillScreenState extends State<AddPillScreen> {
  final _formKey = GlobalKey<FormState>();
  GraphQLClient _client;
  bool loading = false;

  TextEditingController _typeAheadController = TextEditingController();
  TextEditingController _amount = TextEditingController(text: "");
  TextEditingController _remain = TextEditingController(text: "");
  TextEditingController _note = TextEditingController(text: "");
  int _selectedPillForm = 0;
  String _selectedPill;

  List<DropdownMenuItem<int>> pillFormList = [];

  @override
  Widget build(BuildContext context) {
    _client = GraphQLProvider.of(context).value;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Thêm thuốc"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Query(
            options: QueryOptions(documentNode: gql(PillForm.list)),
            builder: (QueryResult result,
                {VoidCallback refetch, FetchMore fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.loading) {
                return Text('Loading');
              }

              if (!result.hasException && result.data != null) {
                final pillForm = result.data['listPillForm']['edges'];

                _selectedPillForm = _selectedPillForm != 0
                    ? _selectedPillForm
                    : int.parse(pillForm[0]['node']['id']);

                pillFormList = [];
                pillForm.forEach((item) {
                  pillFormList.add(new DropdownMenuItem(
                      child: new Text(item['node']['name']),
                      value: int.parse(item['node']['id'])));
                });

                return SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                                controller: this._typeAheadController,
                                decoration:
                                    InputDecoration(labelText: 'Tên thuốc')),
                            suggestionsCallback: (pattern) async {
                              List<String> output = [];

                              if (pattern.length > 0) {
                                final searchResult = await _client.query(
                                    QueryOptions(
                                        documentNode: gql(Pill.search),
                                        variables: {
                                      'filters': {
                                        'nameLike': '%' + pattern + '%'
                                      }
                                    }));

                                inspect(searchResult);

                                if (searchResult.data != null) {
                                  final pills =
                                      searchResult.data['listPill']['edges'];
                                  pills.forEach((item) {
                                    output.add(item['node']['name']);
                                  });
                                }
                              }

                              return output;
                            },
                            itemBuilder: (context, suggestion) {
                              print(suggestion);
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            transitionBuilder:
                                (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            onSuggestionSelected: (suggestion) {
                              this._typeAheadController.text = suggestion;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Vui lòng nhập tên thuốc';
                              }
                            },
                            onSaved: (value) => {this._selectedPill = value},
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 30,
                            child: Text(
                              'Thông tin thêm',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 200,
                                  child: Text(
                                    'Dạng',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.grey[600]),
                                  )),
                              Expanded(
                                child: DropdownButton(
                                    items: pillFormList.toList(),
                                    value: _selectedPillForm,
                                    isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedPillForm = value;
                                      });
                                    }),
                              ),
                            ],
                          ),
                          TextFormField(
                            key: Key("Amount"),
                            controller: _amount,
                            decoration:
                                InputDecoration(labelText: "Liều lượng"),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            key: Key("Remain"),
                            controller: _remain,
                            decoration:
                                InputDecoration(labelText: "Số viên còn lại"),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            key: Key("Note"),
                            maxLines: 4,
                            decoration: InputDecoration(labelText: "Ghi chú"),
                            controller: _note,
                            keyboardType: TextInputType.multiline,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              child: Text('Tiếp tục'),
                              color: Colors.indigoAccent,
                              textColor: Colors.white,
                              padding: EdgeInsets.all(14.0),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  // setState(() {
                                  //   loading = true;
                                  // });

                                  print(_selectedPill);
                                  print(_selectedPillForm);
                                  print(_amount);
                                  print(_remain);
                                }
                              },
                            ),
                          )
                        ]),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
