import 'package:flutter/material.dart';
import 'package:scope/src/bloc_scope.dart';
import 'package:scope/src/scope.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:liq/widget/widgets.dart';

@immutable
class ScopeAccess<S extends Scope, D extends ScopeDelegate<S>> {
  const ScopeAccess({
    bool listensByDefault = false,
  }) : _listensByDefault = listensByDefault;
  final bool _listensByDefault;

  D of(BuildContext context, {bool listen = false}) => Scope.delegateOf<S, D>(
        context,
        listen: listen,
      );

  ScopeData<T> select<T>(
    T Function(D delegate) data,
  ) =>
      // ignore: avoid_types_on_closure_parameters
      (context, {bool? listen}) => data(
            of(context, listen: listen ?? _listensByDefault),
          );

  ScopeData<bool> stateIs<T extends S>() => select((delegate) => delegate is T);

  NullaryScopeMethod nullary(
    void Function(D delegate) method,
  ) =>
      (context) => method(of(context));

  UnaryScopeMethod<A> unary<A extends Object?>(
    void Function(D delegate, A a) method,
  ) =>
      (context, a) => method(of(context), a);
}
