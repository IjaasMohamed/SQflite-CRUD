import 'package:flutter/material.dart';
import 'package:sqlflite_crud/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQflite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;

  void _refreshJournals () async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }
  @override
  void initState(){
    super.initState();
    _refreshJournals();
    // ignore: avoid_print
    print("..number of items ${_journals.length}");
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _showForm(int ? id) async {
    if (id != null ) {
      final existingJournal = _journals.firstWhere((element) => element['id'] == id );
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQL'),
      ),
      floatingActionButton: FloatingActionButton(
        child:  const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
