import 'package:flutter/material.dart';

import 'form_model.dart' as f;

class FormViewModel {
  late final f.Form _form;
  final BuildContext _context;

  FormViewModel(this._context) {
    _form = f.Form();
  }

  dispose() {
    _form.dispose();
  }

  Stream<int> get ageStream => _form.ageStream;

  Stream<bool> get isAgeValidStream =>
      ageStream.map((age) => _ageValidator(age));

  incrementAge() => _form.ageSink.add(_form.age + 1);

  decrementAge() => _form.ageSink.add(_form.age - 1);

  setAge(String s) {
    if (_ageValidator(s)) {
      _form.ageSink.add(int.parse(s));
    } else {
      _form.ageSink.addError(Exception('Invalid age!'));
    }
  }

  Stream<bool> get canSubmitForm => isAgeValidStream;

  onSubmitPressed() => showDialog(
        context: _context,
        barrierDismissible: true,
        builder: (context) =>
            _getAlertDialog(context, title: 'Hey', body: 'Form submitted!'),
      );

  bool _ageValidator(Object? age) {
    final _age = int.tryParse(age.toString());
    return _age != null && _age > 0;
  }

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
