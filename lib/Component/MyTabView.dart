import 'package:flutter/material.dart';

class MyTabView extends StatefulWidget {
  final Widget child;

  const MyTabView({super.key, required this.child});

  @override
  State<MyTabView> createState() => _MyTabViewState();
}

class _MyTabViewState extends State<MyTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}