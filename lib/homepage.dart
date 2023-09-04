import 'package:flutter/material.dart';
import 'package:flutter_weather_demo/weather_manager.dart';
import 'package:watch_it/watch_it.dart';

import 'listview.dart';

class HomePage extends StatefulWidget with WatchItStatefulWidgetMixin {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final bool isRunning = watchValue((WeatherManager x) => x.isRunning);

    return Scaffold(
      appBar: AppBar(title: Text("WeatherDemo")),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              autocorrect: false,
              decoration: InputDecoration(
                hintText: "Filter cities",
                hintStyle: TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
              ),
              style: TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              onChanged: di<WeatherManager>().onTextChanged,
            ),
          ),
          Expanded(
            // Handle events to show / hide spinner
            child: Stack(
              children: [
                WeatherListView(),
                // if true we show a busy Spinner otherwise the ListView
                if (isRunning == true)
                  Center(
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            // We use a ValueListenableBuilder to toggle the enabled state of the button
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    child: Text("Update"),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: Color.fromARGB(255, 33, 150, 243)),
                    onPressed: () => di<WeatherManager>().update(''),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
