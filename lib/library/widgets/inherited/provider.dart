import 'package:flutter/material.dart';

class Provider<Model> extends InheritedWidget {
  final Model model;

  const Provider({super.key, required this.child, required this.model})
      : super(child: child);

  final Widget child;

  static Model? of<Model>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider<Model>>()?.model;
  }

  @override
  bool updateShouldNotify(Provider oldWidget) {
    return model != oldWidget;
  }
}
