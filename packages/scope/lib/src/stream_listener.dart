import 'dart:async';

import 'package:flutter/material.dart';

typedef StreamWidgetListener<T> = void Function(BuildContext context, T value);

class StreamListener<T extends Object?> extends StatefulWidget {
  const StreamListener({
    required this.stream,
    required this.listener,
    required this.child,
    super.key,
  });

  final Stream<T> Function(BuildContext context) stream;
  final StreamWidgetListener<T> listener;
  final Widget child;

  @override
  State<StreamListener<T>> createState() => _StreamListenerState<T>();
}

class _StreamListenerState<T extends Object?> extends State<StreamListener<T>> {
  StreamSubscription<T>? subscription;

  @override
  void initState() {
    super.initState();

    subscription = widget.stream(context).listen(
      (v) {
        widget.listener(context, v);
      },
    );
  }

  @override
  void dispose() {
    unawaited(subscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
