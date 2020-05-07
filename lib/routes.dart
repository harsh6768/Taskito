import 'package:flutter/material.dart';
import 'package:taskito/ui/new_task.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      // '/': (_) => MyApp(),
      '/add_task': (_) => NewTask(),
     
    };
  }
}
