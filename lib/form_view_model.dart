import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'form_model.dart' as f;

class FormViewModel {
  late final f.Form _form;
  late final TextEditingController ageController;
  final BuildContext _context;

  FormViewModel(this._context) {
    _form = f.Form();
    ageController = TextEditingController();
    _form.ageStream.listen(_updateAgeController).onError(_showErrorDialog);
  }

  dispose() {
    _form.dispose();
    ageController.dispose();
  }

  Stream<int> get ageStream => _form.ageStream;

  incrementAge() => _form.ageSink.add(_form.age + 1);

  decrementAge() => _form.ageSink.add(_form.age - 1);

  setAge(String s) {
    _ageValidator(s)
        ? _form.ageSink.add(int.parse(s))
        : _form.ageSink.addError(Exception('Invalid age!'));
  }

  _updateAgeController(int age) {
    final s = age.toString();
    ageController.text = s;
    ageController.selection = TextSelection.collapsed(offset: s.length);
  }

  Stream<bool> get canSubmitForm => CombineLatestStream(
      [_form.ageStream], (values) => _ageValidator(values[0]));

  bool _ageValidator(Object? age) {
    final _age = int.tryParse(age.toString());
    return _age != null && _age > 0;
  }

  onSubmitPressed() => showDialog(
        context: _context,
        barrierDismissible: true,
        builder: (context) =>
            _getAlertDialog(context, title: 'Hey', body: 'Form submitted!'),
      );

  void _showErrorDialog(err) => showDialog(
        context: _context,
        barrierDismissible: true,
        builder: (context) => _getAlertDialog(context,
            title: 'Warning', body: 'Invalid age, please correct.'),
      );

  AlertDialog _getAlertDialog(BuildContext context,
          {required String title, required String body}) =>
      AlertDialog(
        title: Text(title),
        content: SafeArea(
          child: Container(
            height: 100,
            width: 200,
            color: Colors.white,
            child: Text(body),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Dismiss',
            ),
          ),
        ],
      );
}
