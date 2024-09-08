import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CounterState {
  final int counter;
  const CounterState({
    required this.counter,
  });

  factory CounterState.initial() {
    return const CounterState(counter: 0);
  }

  @override
  String toString() => 'CounterState(Counter: $counter)';

  CounterState copyWith({int? counter}) => CounterState(
        counter: counter ?? this.counter,
      );
}

class Increment {
  final int payload;
  Increment({
    required this.payload,
  });

  @override
  String toString() => 'Increment(Payload: $payload)';
}

class Decrement {
  final int payload;
  const Decrement({
    required this.payload,
  });
  @override
  String toString() => 'Decrement(Payload: $payload)';
}

CounterState counterReducer(CounterState state, dynamic action) {
  if (action is Increment) {
    return CounterState(counter: state.counter + action.payload);
  } else if (action is Decrement) {
    return state.copyWith(counter: state.counter - action.payload);
  }
  return state;
}

late final Store<CounterState> store;

void main() {
  store = Store<CounterState>(
    counterReducer,
    initialState: CounterState.initial(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<CounterState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<CounterState>(
      builder: (BuildContext countext, Store<CounterState> store) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Flutter redux counter'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '${store.state.counter}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        store.dispatch(
                          Increment(payload: 1),
                        );
                      },
                      child: const Icon(
                        Icons.add,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        store.dispatch(
                          const Decrement(payload: 1),
                        );
                      },
                      child: const Icon(
                        Icons.remove,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
