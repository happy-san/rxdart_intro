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
            AgeTextField(viewModel: _viewModel),
            StreamBuilder<bool>(
              stream: _viewModel.canSubmitForm,
              initialData: false,
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
  }
}

class AgeTextField extends StatefulWidget {
  const AgeTextField({
    Key? key,
    required FormViewModel viewModel,
  })  : _viewModel = viewModel,
        super(key: key);

  final FormViewModel _viewModel;

  @override
  State<AgeTextField> createState() => _AgeTextFieldState();
}

class _AgeTextFieldState extends State<AgeTextField> {
  late final TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: widget._viewModel.ageStream,
      builder: (context, snapshot) {
        // Cursor won't jump around if value is updated from other sources.
        if (snapshot.hasData) {
          final selection = _ageController.selection;
          _ageController.text = snapshot.data.toString();
          try {
            _ageController.selection = selection;
          } catch (e) {
            _ageController.selection =
                TextSelection.collapsed(offset: _ageController.text.length);
          }
        }

        return StreamBuilder<bool>(
          stream: widget._viewModel.isAgeValidStream,
          initialData: true,
          builder: (context, snapshot) {
            return TextField(
              controller: _ageController,
              onChanged: widget._viewModel.setAge,
              decoration: InputDecoration(
                  errorText: snapshot.hasData && snapshot.data!
                      ? null
                      : 'Invalid age'),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _ageController.dispose();
  }
}
