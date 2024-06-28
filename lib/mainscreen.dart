import 'package:flutter/material.dart';
import 'package:myapp/add_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<List<String>> twodoList;

  addTwodo({required String twodoText}) async {
    final currentList = await twodoList;
    setState(() {
      currentList.add(twodoText);
    });
    writeLocalData();
    Navigator.pop(context);
  }

  writeLocalData() async {
    final SharedPreferences prefs = await _prefs;
    final List<String> todoList = await twodoList; 
    await prefs.setStringList('twodoList', todoList);
  }

  @override
  void initState() {
    super.initState();
    twodoList = _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList('twodoList') ?? [];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: Text("Drawer"),
      ),
      appBar: AppBar(
        title: const Text('TwoDo App'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            showModalBottomSheet(
              context: context, 
              builder: (context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: SizedBox(
                    height: 250,
                    child: AddTask(
                      addTwodo: addTwodo,
                    ),
                  ),
                );
            });
          }, icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: twodoList, 
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show a loading indicator while waiting
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]),
                );
              },
            );
          } else {
            return Center(child: Text('No data available')); // Handle the case where there's no data
          }
      }),
      // body: ListView.builder(
      //     itemCount: twodoList.length,
      //     itemBuilder: (context, i){
      //       return ListTile(
      //         onTap: () {
      //           showModalBottomSheet(context: context, builder: (context){
      //             return Container(
      //               width: double.infinity,
      //               padding: const EdgeInsets.all(20),
      //               child: ElevatedButton(
      //                 onPressed: (){
      //                   setState(() {
      //                     twodoList.removeAt(i);
      //                   });
      //                   writeLocalData();
      //                   Navigator.pop(context);
      //                 }, 
      //                 child: const Text("task done")
      //               ),
      //             );
      //           });
      //         },
      //         title: Text(twodoList[i]),
      //       );
      //     }
      //   )
    );
  }
}