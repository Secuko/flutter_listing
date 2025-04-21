import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A base class for all Scopes that makes InheritedWidgets easier to use and
/// more reusable.
///
/// To create a custom scope, concrete class that extends [Scope] must override
/// abstract [createDelegate] method.
abstract class Scope extends StatefulWidget {
  const Scope({required Widget child, super.key}) : _child = child;
  final Widget _child;

  /// Accesses a delegate of a given scope through InheritedWidget location,
  /// thus making this method having complexity of O(1).
  static D delegateOf<S extends Scope, D extends ScopeDelegate<S>>(
    BuildContext context, {
    bool listen = false,
  }) {
    final scope = listen
        ? context.dependOnInheritedWidgetOfExactType<InheritedScope<S>>()
        : context.getElementForInheritedWidgetOfExactType<InheritedScope<S>>()?.widget
            as InheritedScope<S>?;
    assert(
      scope != null,
      'Unable to locate $D of $S. Either it was not declared as an ancestor '
      'of the widget that has tried to access it, or BuildContext does not '
      'contain its instance.',
    );
    return scope!.delegate as D;
  }

  /// Create a delegate of this Scope.
  ///
  /// Similar to [createState] method of [StatefulWidget].
  ScopeDelegate<Scope> createDelegate();

  @override
  //ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => createDelegate();
}

/// Mutable delegate of a Scope.
///
/// Similar to [State] of [StatefulWidget].
///
/// There are a few difference between [State] and [ScopeDelegate] classes:
///   * [ScopeDelegate] has [keys] getter that indicates whether or not a
/// dependant [Element] should be marked as dirty.
///   * [ScopeDelegate] has [scope] getter that allows accessing the delegating
/// [Scope].
///   * [ScopeDelegate] has [buildScoping] method that should be overriden
/// instead of the [build] method. Class that extends [ScopeDelegate] should
/// **NEVER OVERRIDE THE BUILD METHOD**. It will break things.
abstract class ScopeDelegate<S extends Scope> extends State<S> {
  Listenable? _mergedListenable;

  List<Object?> get keys => const [];

  Widget buildScoping(BuildContext context, Widget child) => child;

  S get scope => widget;

  List<Listenable> get dependOnListenables => const [];

  List<ChangeNotifier> get manageNotifiers => const [];

  void rebuild() {
    if (mounted) setState(() {});
  }

  void assign(dynamic object) {
    assert(object is! Future, 'Objects of type Future cannot be assigned.');
    rebuild();
  }

  @protected
  @mustCallSuper
  void initDelegate() {}

  @protected
  @mustCallSuper
  void disposeDelegate() {}

  @override
  void initState() {
    super.initState();
    if (dependOnListenables.isNotEmpty) {
      _mergedListenable = Listenable.merge(dependOnListenables);
      _mergedListenable?.addListener(rebuild);
    }
    initDelegate();
  }

  @override
  void dispose() {
    disposeDelegate();
    _mergedListenable?.removeListener(rebuild);
    for (final notifier in manageNotifiers) {
      notifier.dispose();
    }
    super.dispose();
  }

  @override
  @nonVirtual
  Widget build(BuildContext context) => InheritedScope<S>(
        delegate: this,
        // ignore: avoid-returning-widgets
        child: buildScoping(context, widget._child),
      );
}

class InheritedScope<S extends Scope> extends InheritedWidget {
  InheritedScope({
    required this.delegate,
    required super.child,
    super.key,
  }) : keys = delegate.keys;
  final List<Object?> keys;
  final ScopeDelegate<Scope> delegate;

  @override
  bool updateShouldNotify(InheritedScope<S> oldWidget) =>
      !const DeepCollectionEquality().equals(keys, oldWidget.keys);
}
