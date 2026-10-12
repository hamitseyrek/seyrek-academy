import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        color: Colors.amberAccent,
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hello, World!',
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text('Flutter',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.green,
                            )),
                        SizedBox(height: 8),
                        Text('Rocks!',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.purple,
                            )),
                      ],
                    ),
                    Text('Counter',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.red,
                        )),
                    SizedBox(width: 16),
                    Text(
                      '$counter',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter++;
          setState(() {});
          print(counter);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
