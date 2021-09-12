import 'dart:async';

import 'package:rxdart/rxdart.dart';

class Form {
  late final BehaviorSubject<int> _ageSubject;

  Form() {
    _ageSubject = BehaviorSubject.seeded(0);
  }

  dispose() {
    _ageSubject.close();
  }

  StreamSink<int> get ageSink => _ageSubject.sink;
  Stream<int> get ageStream => _ageSubject.stream;
  int get age => _ageSubject.value;
}
