import 'package:flutter/material.dart';

import 'form_view_model.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  var _modelInitialized = false;
  late final FormViewModel _viewModel;
  late final TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController(text: '0');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_modelInitialized) {
      _viewModel = FormViewModel(context);
      _modelInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            StreamBuilder<int>(
              stream: _viewModel.ageStream,
              builder: (context, snapshot) {
                return Text('Current age is: ${snapshot.data}');
              },
            ),
            TextField(
              controller: _ageController,
              onChanged: _viewModel.setAge,
            ),
            StreamBuilder<bool>(
              stream: _viewModel.canSubmitForm,
              builder: (context, snapshot) {
                return ElevatedButton(
                  onPressed: (snapshot.hasData && snapshot.data!)
                      ? _viewModel.onSubmitPressed
                      : null,
                  child: const Text('Submit form'),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _viewModel.incrementAge,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
    _ageController.dispose();
  }
}
