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
  late final FormViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_modelInitialized) {
      viewModel = FormViewModel(context);
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
              stream: viewModel.ageStream,
              builder: (context, snapshot) {
                return Text('Current age is: ${snapshot.data}');
              },
            ),
            TextField(
              controller: viewModel.ageController,
              onChanged: viewModel.setAge,
            ),
            StreamBuilder<bool>(
              stream: viewModel.canSubmitForm,
              builder: (context, snapshot) {
                return ElevatedButton(
                  onPressed: (snapshot.hasData && snapshot.data!)
                      ? viewModel.onSubmitPressed()
                      : null,
                  child: const Text('Submit form'),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.incrementAge,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }
}
