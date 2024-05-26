import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  late Future<int> _counterFuture;

  @override
  void initState() {
    super.initState();
    _counterFuture = _loadCounter();
  }

  Future<int> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('counter') ?? 0;
  }

  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    int newCounter = (prefs.getInt('counter') ?? 0) + 1;
    setState(() {
      prefs.setInt('counter', newCounter);
      _counterFuture = Future.value(newCounter);
    });
  }

  Future<void> _decrementCounter() async {
  final prefs = await SharedPreferences.getInstance();
  int currentCounter = prefs.getInt('counter') ?? 0;
  if (currentCounter > 0) {
    int newCounter = currentCounter - 1;
    setState(() {
      prefs.setInt('counter', newCounter);
      _counterFuture = Future.value(newCounter);
    });
  }
}


  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('counter', 0);
      _counterFuture = Future.value(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<int>(
              future: _counterFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // or any other loading indicator
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Counter Value:',
                    ),
                    Text(
                      '${snapshot.data}',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20), // Adjust the space between the counter value and the buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _decrementCounter,
                  tooltip: 'Decrement',
                  mini: true,
                  child: const Icon(Icons.remove),
                ),
                SizedBox(width: 20), // Adjust the space between the buttons
                Container(
                  width: 70, // Adjust the width as per your preference
                  height: 70, // Adjust the height as per your preference
                  child: FloatingActionButton(
                    onPressed: _incrementCounter,
                    tooltip: 'Increment',
                    child: const Icon(Icons.add),
                    // Making the + button big
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                    elevation: 4.0,
                    highlightElevation: 8.0,
                    splashColor: Colors.white54,
                    hoverElevation: 6.0,
                    focusElevation: 6.0,
                    hoverColor: Colors.white10,
                    focusColor: Colors.white10,
                    shape: const CircleBorder(),
                    heroTag: null,
                    mini: false,
                  ),
                ),
                SizedBox(width: 20), // Adjust the space between the buttons
                FloatingActionButton(
                  onPressed: _resetCounter,
                  tooltip: 'Reset',
                  mini: true,
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
