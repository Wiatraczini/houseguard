import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

const simpleTaskKey = "simpleTask";
const rescheduledTaskKey = "rescheduledTask";
const failedTaskKey = "failedTask";
const simpleDelayedTask = "simpleDelayedTask";
const simplePeriodicTask = "simplePeriodicTask";
const simplePeriodic1HourTask = "simplePeriodic1HourTask";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case simpleTaskKey:
        print("$simpleTaskKey was executed. inputData = $inputData");
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("test", true);
        print("Bool from prefs: ${prefs.getBool("test")}");
        break;
      case rescheduledTaskKey:
        final key = inputData!['key']!;
        final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('unique-$key')) {
          print('has been running before, task is successful');
          return true;
        } else {
          await prefs.setBool('unique-$key', true);
          print('reschedule task');
          return false;
        }
      case failedTaskKey:
        print('failed task');
        return Future.error('failed');
      case simpleDelayedTask:
        print("$simpleDelayedTask was executed");
        break;
      case simplePeriodicTask:
        print("$simplePeriodicTask was executed");
        AndroidBatteryInfo infoandroid = AndroidBatteryInfo();
        infoandroid = (await BatteryInfoPlugin().androidBatteryInfo)!;
        var pluggedstatus = infoandroid.pluggedStatus.toString();
        print("$pluggedstatus is plugged status");
        break;
      case simplePeriodic1HourTask:
        print("$simplePeriodic1HourTask was executed");
        break;
      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        Directory? tempDir = await getTemporaryDirectory();
        String? tempPath = tempDir.path;
        print(
            "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
        break;
    }

    return Future.value(true);
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum _Platform { android, ios }

class PlatformEnabledButton extends RaisedButton {
  final _Platform platform;

  PlatformEnabledButton({
    required this.platform,
    required Widget child,
    required VoidCallback onPressed,
  }) : super(
            child: child,
            onPressed: (Platform.isAndroid && platform == _Platform.android ||
                    Platform.isIOS && platform == _Platform.ios)
                ? onPressed
                : null);
}

class _MyAppState extends State<MyApp> {
  String batterylevel = "",
      batteryhealth = "",
      chargingstatus = "",
      pluggedstatus = "";

  @override
  void initState() {
    AndroidBatteryInfo infoandroid = AndroidBatteryInfo();

    //IosBatteryInfo infoios = IosBatteryInfo(); use for iOS
    //only battery level and charging status are retrived from iOS

    Future.delayed(Duration.zero, () async {
      //there is async (await) execution inside it
      infoandroid = (await BatteryInfoPlugin().androidBatteryInfo)!;
      // infoios = await BatteryInfoPlugin().iosBatteryInfo;  for iOS
      batterylevel = infoandroid.batteryLevel.toString();
      batteryhealth = infoandroid.health.toString();
      chargingstatus = infoandroid.chargingStatus.toString();
      pluggedstatus = infoandroid.pluggedStatus.toString();

      setState(() {
        //refresh UI
      });
    });

    BatteryInfoPlugin()
        .androidBatteryInfoStream
        .listen((AndroidBatteryInfo? batteryInfo) {
      //add listiner to update values if there is changes
      infoandroid = batteryInfo!;
      batterylevel = infoandroid.batteryLevel.toString();
      batteryhealth = infoandroid.health.toString();
      chargingstatus = infoandroid.chargingStatus.toString();
      pluggedstatus = infoandroid.pluggedStatus.toString();

      setState(() {
        //refresh UI
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter WorkManager Example"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Plugin initialization",
                  style: Theme.of(context).textTheme.headline6),
              RaisedButton(
                  child: Text("Start the Flutter background service"),
                  onPressed: () {
                    Workmanager().initialize(
                      callbackDispatcher,
                      isInDebugMode: true,
                    );
                  }),
              SizedBox(height: 16),
              Text("One Off Tasks (Android only)",
                  style: Theme.of(context).textTheme.headline6),
              //This task runs once.
              //Most likely this will trigger immediately
              PlatformEnabledButton(
                platform: _Platform.android,
                child: Text("Register OneOff Task"),
                onPressed: () {
                  Workmanager().registerOneOffTask(
                    "1",
                    simpleTaskKey,
                    inputData: <String, dynamic>{
                      'int': 1,
                      'bool': true,
                      'double': 1.0,
                      'string': 'string',
                      'array': [1, 2, 3],
                    },
                  );
                },
              ),
              PlatformEnabledButton(
                platform: _Platform.android,
                child: Text("Register rescheduled Task"),
                onPressed: () {
                  Workmanager().registerOneOffTask(
                    "1-rescheduled",
                    rescheduledTaskKey,
                    inputData: <String, dynamic>{
                      'key': Random().nextInt(64000),
                    },
                  );
                },
              ),
              PlatformEnabledButton(
                platform: _Platform.android,
                child: Text("Register failed Task"),
                onPressed: () {
                  Workmanager().registerOneOffTask(
                    "1-failed",
                    failedTaskKey,
                  );
                },
              ),
              //This task runs once
              //This wait at least 10 seconds before running
              PlatformEnabledButton(
                  platform: _Platform.android,
                  child: Text("Register Delayed OneOff Task"),
                  onPressed: () {
                    Workmanager().registerOneOffTask(
                      "2",
                      simpleDelayedTask,
                      initialDelay: Duration(seconds: 10),
                    );
                  }),
              SizedBox(height: 8),
              Text("Periodic Tasks (Android only)",
                  style: Theme.of(context).textTheme.headline6),
              //This task runs periodically
              //It will wait at least 10 seconds before its first launch
              //Since we have not provided a frequency it will be the default 15 minutes
              PlatformEnabledButton(
                  platform: _Platform.android,
                  child: Text("Register Periodic Task"),
                  onPressed: () {
                    Workmanager().registerPeriodicTask(
                      "3",
                      simplePeriodicTask,
                      initialDelay: Duration(seconds: 5),
                      frequency: Duration(seconds: 10),
                    );
                  }),
              //This task runs periodically
              //It will run about every hour
              PlatformEnabledButton(
                  platform: _Platform.android,
                  child: Text("Register 1 hour Periodic Task"),
                  onPressed: () {
                    Workmanager().registerPeriodicTask(
                      "5",
                      simplePeriodic1HourTask,
                      frequency: Duration(hours: 1),
                    );
                  }),
              PlatformEnabledButton(
                platform: _Platform.android,
                child: Text("Cancel All"),
                onPressed: () async {
                  await Workmanager().cancelAll();
                  print('Cancel all tasks completed');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
