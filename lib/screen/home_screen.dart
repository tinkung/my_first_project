import 'package:flutter/material.dart';
import 'package:my_first_project/connect.dart';
import 'package:my_first_project/screen/about_screen.dart';
import 'package:my_first_project/screen/add_screen.dart';
import 'package:my_first_project/screen/contact_screen.dart';
import 'package:mysql1/mysql1.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _todoItems = [];

  Future<void> _getTodos() async {
    var connect = await MySqlConnection.connect(mysqlSettings);
    var results = await connect.query("""
        SELECT * FROM todos
      """);

    for (var item in results) {
      setState(() {
        _todoItems.add({
          'todo_id': item.fields['todo_id'],
          'name': item.fields['name'],
          'status': item.fields['status'],
          'created_at': item.fields['created_at'],
        });
      });
    }
  }

  Future<void> _deleteTodo(int id) async {
    var connect = await MySqlConnection.connect(mysqlSettings);
    var results = await connect.query(
      """
DELETE FROM todos WHERE todo_id = ?
""",
      [id],
    );
    setState(() {
      _todoItems.removeWhere((element) => element['todo_id'] == id);
    });
  }

  Future<void> _updateTodo(int id, int status) async {
    var connect = await MySqlConnection.connect(mysqlSettings);
    var results = await connect.query(
      """
UPDATE todos SET status = ? WHERE todo_id = ?
""",
      [status, id],
    );

    setState(() {
      var item = _todoItems.firstWhere((element) => element['todo_id'] == id);
      item['status'] = status;
    });
  }

  @override
  void initState() {
    super.initState();
    _getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แอพของฉัน"),
      ),
      drawer: Drawer(),
      body: _todoItems.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _todoItems.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      var newStatus = _todoItems[index]['status'] == 0 ? 1 : 0;
                      _updateTodo(_todoItems[index]['todo_id'], newStatus);
                    },
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("คุณแน่ใจหรือไม่ที่จะลบรายการนี้ ?"),
                              content: Text(
                                  "หลังจากลบแล้วข้อมูลจะไม่สามารถกู้กลับมาได้"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("ยกเลิก"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteTodo(_todoItems[index]['todo_id']);
                                  },
                                  child: Text("ยืนยัน"),
                                ),
                              ],
                            );
                          });
                    },
                    title: Text(_todoItems[index]['name']),
                    subtitle: _todoItems[index]['status'] == 0
                        ? Text('ยังไม่เสร็จ')
                        : Text('เสร็จแล้ว'),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          switch (value) {
            case 0:
              Navigator.of(context).pushNamed(HomeScreen.routeName);
              break;
            case 1:
              Navigator.of(context).pushNamed(AboutScreen.routeName);
              break;
            case 2:
              Navigator.of(context).pushNamed(ContactScreen.routeName);
              break;
            default:
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_timeline),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Contact',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddScreen.routeName).then((value) {
            setState(() {
              _todoItems.clear();
            });
            _getTodos();
          });
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
