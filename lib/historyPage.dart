import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool isMobile() {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> tryCopy(String s) async {
    try {
      await Clipboard.setData(ClipboardData(text: s));
      if (isMobile()) {
        Fluttertoast.showToast(
          msg: "Скопировано",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            duration: Duration(milliseconds: 1000),
            content: Center(
                child: Text(
              "Скопировано",
              style: TextStyle(color: Theme.of(context).hintColor),
            )),
          ),
        );
      }
    } catch (er) {}
  }

  bool _isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final List<List<String>> history = appState.history;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop())),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: history.isEmpty
                ? Center(
                    child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        const BoxShadow(
                          color: Colors.black,
                        ),
                        BoxShadow(
                          spreadRadius: -1,
                          blurRadius: 7.0,
                          offset: Offset(0, 7),
                          color: Theme.of(context).canvasColor,
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.folder_outlined,
                          size: 50,
                        ),
                        Text(
                          'Пусто',
                          style: TextStyle(fontSize: 24),
                        )
                      ],
                    ),
                  ))
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          child: Card(
                            child: ListTile(
                              title: Text(
                                  '${history[index][0]} = ${history[index][1]}'),
                            ),
                          ),
                          onLongPress: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 100,
                                  child: Center(
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black38,
                                            ),
                                            onPressed: () {
                                              tryCopy(history[index][0]);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Копировать выражение'),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black38,
                                              ),
                                              onPressed: () {
                                                tryCopy(history[index][1]);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Копировать ответ')),
                                        ]),
                                  ),
                                );
                              },
                            );
                          });
                    }),
          ),
        ],
      ),
    );
  }
}
