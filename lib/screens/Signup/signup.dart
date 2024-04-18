import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController customerorownerController;

  late Database _database;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: '');
    lastNameController = TextEditingController(text: '');
    emailController = TextEditingController(text: '');
    phoneController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    confirmPasswordController = TextEditingController(text: '');
    customerorownerController = TextEditingController(text: '');
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE my_table( id INTEGER PRIMARY KEY, text1 TEXT, text2 INTEGER, counter INTEGER) ',
        );
      },
      version: 1,
    );
    // _loadDataFromDatabase();
  }

  // Future<void> _loadDataFromDatabase() async {
  //   final List<Map<String, dynamic>> maps = await _database!.query('my_table');
  //   if (maps.isNotEmpty) {
  //     final data = maps.first;
  //     setState(() {
  //       textField1.text = data['text1'] ?? '';
  //       textField2.text = (data['text2'] ?? 0).toString();
  //       _counter = data['counter'] ?? 0;
  //     });
  //   }
  // }

  // Future<void> _saveDataToDatabase() async {
  //   await _database!.transaction((txn) async {
  //     await txn.rawInsert(
  //       'INSERT INTO my_table(id, text1, text2, counter) VALUES(1, ?, ?, ?)',
  //       [textField1.text, int.tryParse(textField2.text) ?? 0, _counter],
  //     );
  //   });
  // }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    // _saveDataToDatabase();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    customerorownerController.dispose();
    super.dispose();
    _database.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Text(
            //   'CINS467 Hello World',
            // ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
            // Text fields
            TextField(
              controller: firstNameController,
              style: const TextStyle(
                color: Color.fromARGB(255, 37, 5, 143),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(
                   fontWeight: FontWeight.bold,
                   color: Color.fromARGB(255, 17, 17, 1),
                ),
              ),
              // onChanged: (value) => _saveDataToDatabase(),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: lastNameController,
              // keyboardType: TextInputType.number,
              // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                color: Color.fromRGBO(9, 246, 17, 1),
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                // decoration: TextDecoration.underline,
              ),
              decoration: const InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 17, 17, 1),
              ),
              ),
              // onChanged: (value) => _saveDataToDatabase(),
            ),
            TextField(
              controller: emailController,
              style: const TextStyle(
                color: Color.fromARGB(255, 37, 5, 143),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                   fontWeight: FontWeight.bold,
                   color: Color.fromARGB(255, 17, 17, 1), 
                ),
              ),
              // onChanged: (value) => _saveDataToDatabase(),
            ),
            TextField(
              controller: phoneController,
              style: const TextStyle(
                color: Color.fromARGB(255, 37, 5, 143),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: 'Phone',
                labelStyle: TextStyle(
                   fontWeight: FontWeight.bold,
                   color: Color.fromARGB(255, 17, 17, 1), 
                ),
              ),
              // onChanged: (value) => _saveDataToDatabase(),
            ),
            TextField(
              controller: passwordController,
              style: const TextStyle(
                color: Color.fromARGB(255, 37, 5, 143),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                   fontWeight: FontWeight.bold,
                   color: Color.fromARGB(255, 17, 17, 1), 
                ),
              ),
              // onChanged: (value) => _saveDataToDatabase(),
            ),
            TextField(
              controller: confirmPasswordController,
              style: const TextStyle(
                color: Color.fromARGB(255, 37, 5, 143),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(
                   fontWeight: FontWeight.bold,
                   color: Color.fromARGB(255, 17, 17, 1), 
                ),
              ),
              // onChanged: (value) => _saveDataToDatabase(),
            ),
            TextField(
              controller: customerorownerController,
              style: const TextStyle(
                color: Color.fromARGB(255, 37, 5, 143),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                labelText: 'Customer or Owner?',
                labelStyle: TextStyle(
                   fontWeight: FontWeight.bold,
                   color: Color.fromARGB(255, 17, 17, 1),
                ),
              ),
              // onChanged: (value) => _saveDataToDatabase(),
            ),                                                
            ElevatedButton(
              onPressed: () {
                _incrementCounter();
                // _saveDataToDatabase();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

