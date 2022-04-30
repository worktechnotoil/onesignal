import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final TextEditingController titlecontroller = TextEditingController();
final TextEditingController bodycontroller = TextEditingController();
final TextEditingController urlcontroller = TextEditingController();

class _MyHomePageState extends State<MyHomePage> {
  String? selectedValue;
  String selectedTag = "";
  bool isShow = false;

  List<String> items = [];

  List list = [];
  List lists = [];

  getUsers() async {
    final snapshot = await FirebaseDatabase.instance.ref('/').get();
    list = snapshot.value as List;

    for (int i = 0; i < list.length; i++) {
      items.add(list[i]["tech"]);
    }

    items = items.toSet().toList();

    setState(() {});
    print(items);
  }

  sendnotification(title, body, url) async {
    const String apiUrl = "https://onesignal.com/api/v1/notifications";

    Map datas = {
      "app_id": "458d8f96-d68c-4c9c-b642-e6ed9fd34819",
      "filters": [
        {"field": "tag", "key": "tech", "relation": "=", "value": selectedTag}
      ],
      "data": {"foo": url},
      "headings": {"en": title},
      "contents": {"en": body}
    };

    var bodya = json.encode(datas);
    final encoding = Encoding.getByName('utf-8');

    var response = await http.post(
      Uri.parse(apiUrl),
      body: bodya,
      encoding: encoding,
      headers: {
        "Authorization":
            "Basic MjgzM2VhMTktOGZjZS00MDQ1LWFmZDEtZDMxNThlOTNjODg0",
        "Content-Type": "application/json"
      },
    );

    print("imran " + response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Send Succsessfully",
        ),
      ));

      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titlecontroller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                  hintText: 'Enter your notification title'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: bodycontroller,
              keyboardType: TextInputType.multiline,
              minLines: 1, //Normal textInputField will be displayed
              maxLines: 5,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Body',
                  hintText: 'Enter your notification Body'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: urlcontroller,
              keyboardType: TextInputType.multiline,
              minLines: 1, //Normal textInputField will be displayed
              maxLines: 5,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'URL',
                  hintText: 'Enter your URL'),
            ),
            const SizedBox(
              height: 20,
            ),
            Flexible(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                    children: const <Widget>[
                      Text("Tags",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                    margin: const EdgeInsets.only(
                      right: 20,
                    ),
                    //
                    child: FormField<int>(
                      builder: (FormFieldState<int> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                              hintText: 'Select here',
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1))),
                          isEmpty: selectedValue == null,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedValue,
                              isDense: true,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedTag = newValue.toString();
                                  selectedValue = newValue;
                                  //state.didChange(newValue);
                                });
                              },
                              items: items.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text('$value'),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    )),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                    onTap: (() {
                      sendnotification(
                          titlecontroller.text.toString(),
                          bodycontroller.text.toString(),
                          urlcontroller.text.toString());
                    }),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 12, bottom: 12),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Send",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        isShow
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              )
                            : Container()
                      ],
                    )),
              ],
            ))
          ],
        ),
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
