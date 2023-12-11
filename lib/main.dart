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

  Future <void> _addItem() async {
    await SQLHelper.createItem(_titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  void _showForm(int ? id) async {
    if (id != null ) {
      final existingJournal = _journals.firstWhere((element) => element['id'] == id );
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }
  
  showModalBottomSheet(
    context: context,
    elevation: 5,
    isScrollControlled: true,
    builder: (_) => Container(
      padding: EdgeInsets.only(
        top:15,
        left: 15,
        right: 15,
        bottom: MediaQuery.of(context).viewInsets.bottom +120,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _titleController,
          decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              if (id == null ) {
                await _addItem();
              }
              if (id != null) {
           //     await _updateItem();
              }
              _titleController.text = '';
              _descriptionController.text = '';

              Navigator.of(context).pop();
            }, child: Text(id == null ? 'Create New' : 'Update'),
          )
        ],
      ),
    )
  );
  
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQL'),
      ),
      body: ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text(_journals[index]['title']),
            subtitle: Text(_journals[index]['description']),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child:  const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}
