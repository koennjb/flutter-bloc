import 'dart:async';

import 'package:bloc_example/counter_event.dart';

class CounterBloc {

  int _counter = 0;

  // counterStateController is like a box
  final _counterStateController = StreamController<int>();
  // Sink is like an input to that box
  StreamSink<int> get _inCounter => _counterStateController.sink;
  // Stream is like the output
  // This is where the state will come from, that is why it's the only public method
  Stream<int> get counter => _counterStateController.stream;

  // Another controller, this one for events
  final _counterEventController = StreamController<CounterEvent>();
  // Needs a way to input events
  EventSink<CounterEvent> get counterEventSink => _counterEventController.sink;

  CounterBloc() {
    // Whenever a new event is input, map it to a state change
    _counterEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent event) {
    if (event is IncrementEvent) {
      _counter++;
    } else if (event is DecrementEvent) {
      _counter--;
    }

    _inCounter.add(_counter);
  }

  // Avoid memory leaks from the Stream
  void dispose() {
    _counterEventController.close();
    _counterStateController.close();
  }
    
}